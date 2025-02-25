#!/bin/sh

# Шаг 1: Проверка серого IP через 2ip.ru
USER_IP=$(curl -s4 https://2ip.ru)

is_cgnat_ip() {
    [ "$(echo "$1" | grep -E '^100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\..*')" ] || 
    [ "$(echo "$1" | grep -E '^10\..*')" ] ||
    [ "$(echo "$1" | grep -E '^172\.(1[6-9]|2[0-9]|3[01])\..*')" ] || 
    [ "$(echo "$1" | grep -E '^192\.168\..*')" ]
}

if is_cgnat_ip "$USER_IP"; then
    echo "Ваш внешний IP-адрес: $USER_IP"
    echo "❌ У вас серый IP-адрес (CG-NAT). Туннель 6in4 не будет работать."
    echo "Попробуйте подключить белый IP у провайдера или использовать VPN."
    exit 1
fi

echo "✅ У вас белый IP-адрес ($USER_IP). Продолжаем настройку 6in4..."

# Шаг 2: Проверка и установка пакетов 6in4 и luci-proto-ipv6
echo "Проверка наличия пакетов 6in4 и luci-proto-ipv6..."

opkg update
if ! opkg list-installed 6in4 >/dev/null 2>&1; then
    echo "Пакет 6in4 не установлен. Устанавливаем..."
    opkg install 6in4
else
    echo "Пакет 6in4 уже установлен."
fi

if ! opkg list-installed luci-proto-ipv6 >/dev/null 2>&1; then
    echo "Пакет luci-proto-ipv6 не установлен. Устанавливаем..."
    opkg install luci-proto-ipv6
else
    echo "Пакет luci-proto-ipv6 уже установлен."
fi

# Шаг 3: Запрашиваем данные у пользователя для настройки туннеля
echo "Пожалуйста, введите данные для настройки туннеля 6in4."

read -p "Введите SERVER IP: " SERVER_IP
read -p "Введите IPv6 CLIENT P2P: " CLIENT_P2P
read -p "Введите IPv6 PD ADDRESS/64: " PD_ADDRESS

# Шаг 4: Настройка интерфейса 6in4
echo "Настройка интерфейса 6in4..."
cat <<EOF > /etc/config/network
config interface 'tunnel_6in4'
    option proto '6in4'
    option peeraddr '$SERVER_IP'  # IP удалённого сервера
    option ip6addr '$CLIENT_P2P'  # Твой IPv6-адрес
    list ip6prefix '$PD_ADDRESS'  # IPv6 PD ADDRESS/64
EOF

# Шаг 5: Настройка фаервола
echo "Настройка фаервола..."
uci set firewall.@zone[1].network='wan tunnel_6in4'
uci commit firewall
/etc/init.d/firewall restart

# Шаг 6: Запрос API-ключа и Tunnel ID у пользователя
echo "Для динамического обновления IP, введите ваш API-ключ и Tunnel ID."

read -p "Введите ваш API-ключ: " API_KEY
read -p "Введите ваш Tunnel ID: " TUNNEL_ID

# Шаг 7: Создание скрипта для динамического обновления IP
echo "Создание скрипта для динамического обновления IP..."
cat <<EOF > /etc/hotplug.d/iface/90-online
#!/bin/sh
if [ "${INTERFACE}" = "loopback" ]; then
    exit 0
fi

if [ "${ACTION}" != "ifup" ] && [ "${ACTION}" != "ifupdate" ]; then
    exit 0
fi

if [ "${ACTION}" = "ifupdate" ] && [ -z "${IFUPDATE_ADDRESSES}" ] && [ -z "${IFUPDATE_DATA}" ]; then
    exit 0
fi

hotplug-call online
EOF

# Шаг 8: Добавление в sysupgrade.conf
echo "Добавление в sysupgrade.conf..."
cat <<EOF >> /etc/sysupgrade.conf
/etc/hotplug.d/iface/90-online
EOF

# Шаг 9: Создание директории для online
mkdir -p /etc/hotplug.d/online

# Шаг 10: Скрипт для отправки WAN IP на 6in4.ru
echo "Создание скрипта для отправки WAN IP на 6in4.ru..."
cat <<EOF > /etc/hotplug.d/online/10-send-wan-ip-to-6in4ru
#!/bin/sh
. /lib/functions/network.sh
network_flush_cache
network_find_wan WAN_IF
network_get_ipaddr WAN_ADDR "${WAN_IF}"

curl -v --request PUT \
--url https://6in4.ru/tunnel/$API_KEY/$TUNNEL_ID \
--header 'Content-Type: application/json' \
--data '{"ipv4remote": "'$WAN_ADDR'"}'
EOF

# Шаг 11: Добавление в sysupgrade.conf для online скрипта
echo "Добавление в sysupgrade.conf для online..."
cat <<EOF >> /etc/sysupgrade.conf
/etc/hotplug.d/online/10-send-wan-ip-to-6in4ru
EOF

# Завершение настройки
echo "Конфигурация завершена. Приятного использования!"
