#!/bin/sh

# Шаг 1: Проверка серого IP через 2ip.ru
USER_IP=$(curl -s4 https://2ip.ru)

is_cgnat_ip() {
    # Проверка на серый IP
    echo "$1" | grep -E -q '^100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\..*' && return 0
    echo "$1" | grep -E -q '^10\..*' && return 0
    echo "$1" | grep -E -q '^172\.(1[6-9]|2[0-9]|3[01])\..*' && return 0
    echo "$1" | grep -E -q '^192\.168\..*' && return 0
    return 1
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
cat <<EOF > /etc/hotplug.d/iface/90-send-wan-ip-to-6in4
#!/bin/sh

if [ "\$INTERFACE" = "wan" ] && [ "\$ACTION" = "ifup" ]; then
    WAN_IP=\$(ifstatus wan | jsonfilter -e '@.interface.ipaddr[0]')

    curl -v --request PUT \
    --url "https://6in4.ru/tunnel/\$API_KEY/\$TUNNEL_ID" \
    --header 'Content-Type: application/json' \
    --data '{"ipv4remote": "\$WAN_IP"}'
fi
EOF

chmod +x /etc/hotplug.d/iface/90-send-wan-ip-to-6in4

# Шаг 8: Удаление секции youtube и доменов из other_zapret в /etc/config/youtubeUnblock
echo "Удаление секции 'youtube' и доменов из 'other_zapret' в конфигурации youtubeUnblock..."

sed -i '/config section.*youtube/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*youtube.com/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*ggpht.com/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*ytimg.com/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*play.google.com/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*youtu.be/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*googleapis.com/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*googleusercontent.com/d' /etc/config/youtubeUnblock
sed -i '/list sni_domains.*gstatic.com/d' /etc/config/youtubeUnblock

DOMAINS=("cdninstagram.com" "instagram.com" "ig.me" "fbcdn.net" "facebook.com" "facebook.net" "twitter.com" "t.co" "twimg.com" "ads-twitter.com" "x.com" "pscp.tv" "twtrdns.net" "twttr.com" "periscope.tv" "tweetdeck.com" "twitpic.com" "twitter.co" "twitterinc.com" "twitteroauth.com" "twitterstat.us")
for DOMAIN in "${DOMAINS[@]}"; do
    sed -i "/list sni_domains.*$DOMAIN/d" /etc/config/youtubeUnblock
done

# Применяем изменения и перезапускаем службу youtubeUnblock
echo "Применение изменений и перезапуск службы youtubeUnblock..."
/etc/init.d/youtubeUnblock restart

echo "Конфигурация завершена. Приятного использования!"
