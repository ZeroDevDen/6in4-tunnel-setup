#!/bin/sh

# Шаг 1: Проверка IP
USER_IP=$(curl -s4 https://2ip.ru)

# Функция для проверки серого IP (CG-NAT)
is_cgnat_ip() {
    case "$1" in
        10.*|100.*|172.*|192.*) return 0 ;;
        *) return 1 ;;
    esac
}

# Проверяем, является ли IP серым
if is_cgnat_ip "$USER_IP"; then
    echo "Ваш внешний IP-адрес: $USER_IP"
    echo "❌ У вас серый IP-адрес (CG-NAT). Туннель 6in4 не будет работать."
    echo "Попробуйте подключить белый IP у провайдера или использовать VPN."
    exit 1
fi

echo "✅ У вас белый IP-адрес ($USER_IP). Продолжаем настройку 6in4..."

# Шаг 2: Проверка пакетов
opkg update

# Проверяем, установлен ли пакет 6in4
if ! opkg list-installed 6in4 >/dev/null 2>&1; then
    echo "Пакет 6in4 не установлен. Устанавливаем..."
    opkg install 6in4
else
    echo "Пакет 6in4 уже установлен."
fi

# Проверяем, установлен ли пакет luci-proto-ipv6
if ! opkg list-installed luci-proto-ipv6 >/dev/null 2>&1; then
    echo "Пакет luci-proto-ipv6 не установлен. Устанавливаем..."
    opkg install luci-proto-ipv6
else
    echo "Пакет luci-proto-ipv6 уже установлен."
fi

# Шаг 3: Запрос данных для настройки
echo "Пожалуйста, введите данные для настройки туннеля 6in4."

# Запрашиваем IP удалённого сервера
echo "Введите IP-адрес удалённого сервера (SERVER IP):"
read SERVER_IP
if [ -z "$SERVER_IP" ]; then
    echo "Ошибка: IP-адрес не может быть пустым."
    exit 1
fi

# Запрашиваем IPv6-адрес клиента
echo "Введите ваш IPv6-адрес для клиента (CLIENT P2P):"
read CLIENT_P2P
if [ -z "$CLIENT_P2P" ]; then
    echo "Ошибка: IPv6-адрес не может быть пустым."
    exit 1
fi

# Запрашиваем Prefix
echo "Введите IPv6 Prefix (например, '2001:db8::/64'):"
read PD_ADDRESS
if [ -z "$PD_ADDRESS" ]; then
    echo "Ошибка: Префикс не может быть пустым."
    exit 1
fi

# Шаг 4: Проверка введённых данных
if [ -z "$SERVER_IP" ] || [ -z "$CLIENT_P2P" ] || [ -z "$PD_ADDRESS" ]; then
    echo "Ошибка: Все данные должны быть введены!"
    exit 1
fi

# Шаг 5: Настройка интерфейса 6in4
echo "Настройка интерфейса 6in4..."
cat <<EOF > /etc/config/network
config interface 'tunnel_6in4'
    option proto '6in4'
    option peeraddr '$SERVER_IP'
    option ip6addr '$CLIENT_P2P'
    list ip6prefix '$PD_ADDRESS'
EOF

# Шаг 6: Настройка фаервола
echo "Настройка фаервола..."
uci set firewall.@zone[1].network='wan tunnel_6in4'
uci commit firewall
/etc/init.d/firewall restart

# Шаг 7: Запрос API-ключа и Tunnel ID
echo "Для динамического обновления IP, введите ваш API-ключ и Tunnel ID."

echo "Введите ваш API-ключ:"
read API_KEY
if [ -z "$API_KEY" ]; then
    echo "Ошибка: API-ключ не может быть пустым."
    exit 1
fi

echo "Введите ваш Tunnel ID:"
read TUNNEL_ID
if [ -z "$TUNNEL_ID" ]; then
    echo "Ошибка: Tunnel ID не может быть пустым."
    exit 1
fi

# Шаг 8: Создание скрипта для динамического обновления IP
echo "Создание скрипта для динамического обновления IP..."
mkdir -p /etc/hotplug.d/iface
cat <<EOF > /etc/hotplug.d/iface/90-online
if [ "\$INTERFACE" = "loopback" ]; then
    exit 0
fi

if [ "\$ACTION" != "ifup" ] && [ "\$ACTION" != "ifupdate" ]; then
    exit 0
fi

if [ "\$ACTION" = "ifupdate" ] && [ -z "\$IFUPDATE_ADDRESSES" ] && [ -z "\$IFUPDATE_DATA" ]; then
    exit 0
fi

hotplug-call online
EOF

cat <<EOF >> /etc/sysupgrade.conf
/etc/hotplug.d/iface/90-online
EOF

# Шаг 9: Создание скрипта для отправки WAN IP на 6in4.ru
mkdir -p /etc/hotplug.d/online
cat <<EOF > /etc/hotplug.d/online/10-send-wan-ip-to-6in4ru
. /lib/functions/network.sh
network_flush_cache
network_find_wan WAN_IF
network_get_ipaddr WAN_ADDR "\$WAN_IF"
curl -v --request PUT \
--url "https://6in4.ru/tunnel/$API_KEY/$TUNNEL_ID" \
--header 'Content-Type: application/json' \
--data '{"ipv4remote": "'\$WAN_ADDR'"}'
EOF

cat <<EOF >> /etc/sysupgrade.conf
/etc/hotplug.d/online/10-send-wan-ip-to-6in4ru
EOF

echo "Конфигурация завершена. Приятного использования!"
