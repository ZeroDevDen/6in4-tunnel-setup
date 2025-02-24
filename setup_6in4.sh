{\rtf1\ansi\ansicpg1251\cocoartf2821
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
\
# \uc0\u1064 \u1072 \u1075  1: \u1055 \u1088 \u1086 \u1074 \u1077 \u1088 \u1082 \u1072  \u1080  \u1091 \u1089 \u1090 \u1072 \u1085 \u1086 \u1074 \u1082 \u1072  \u1087 \u1072 \u1082 \u1077 \u1090 \u1086 \u1074  6in4 \u1080  luci-proto-ipv6\
echo "\uc0\u1055 \u1088 \u1086 \u1074 \u1077 \u1088 \u1082 \u1072  \u1085 \u1072 \u1083 \u1080 \u1095 \u1080 \u1103  \u1087 \u1072 \u1082 \u1077 \u1090 \u1086 \u1074  6in4 \u1080  luci-proto-ipv6..."\
\
# \uc0\u1059 \u1089 \u1090 \u1072 \u1085 \u1086 \u1074 \u1082 \u1072  \u1087 \u1072 \u1082 \u1077 \u1090 \u1086 \u1074  6in4 \u1080  luci-proto-ipv6\
opkg update\
if ! opkg list-installed 6in4 >/dev/null 2>&1; then\
    echo "\uc0\u1055 \u1072 \u1082 \u1077 \u1090  6in4 \u1085 \u1077  \u1091 \u1089 \u1090 \u1072 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 . \u1059 \u1089 \u1090 \u1072 \u1085 \u1072 \u1074 \u1083 \u1080 \u1074 \u1072 \u1077 \u1084 ..."\
    opkg install 6in4\
else\
    echo "\uc0\u1055 \u1072 \u1082 \u1077 \u1090  6in4 \u1091 \u1078 \u1077  \u1091 \u1089 \u1090 \u1072 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 ."\
fi\
\
if ! opkg list-installed luci-proto-ipv6 >/dev/null 2>&1; then\
    echo "\uc0\u1055 \u1072 \u1082 \u1077 \u1090  luci-proto-ipv6 \u1085 \u1077  \u1091 \u1089 \u1090 \u1072 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 . \u1059 \u1089 \u1090 \u1072 \u1085 \u1072 \u1074 \u1083 \u1080 \u1074 \u1072 \u1077 \u1084 ..."\
    opkg install luci-proto-ipv6\
else\
    echo "\uc0\u1055 \u1072 \u1082 \u1077 \u1090  luci-proto-ipv6 \u1091 \u1078 \u1077  \u1091 \u1089 \u1090 \u1072 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 ."\
fi\
\
# \uc0\u1064 \u1072 \u1075  2: \u1047 \u1072 \u1087 \u1088 \u1072 \u1096 \u1080 \u1074 \u1072 \u1077 \u1084  \u1076 \u1072 \u1085 \u1085 \u1099 \u1077  \u1091  \u1087 \u1086 \u1083 \u1100 \u1079 \u1086 \u1074 \u1072 \u1090 \u1077 \u1083 \u1103  \u1076 \u1083 \u1103  \u1085 \u1072 \u1089 \u1090 \u1088 \u1086 \u1081 \u1082 \u1080  \u1090 \u1091 \u1085 \u1085 \u1077 \u1083 \u1103 \
echo "\uc0\u1055 \u1086 \u1078 \u1072 \u1083 \u1091 \u1081 \u1089 \u1090 \u1072 , \u1074 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  \u1076 \u1072 \u1085 \u1085 \u1099 \u1077  \u1076 \u1083 \u1103  \u1085 \u1072 \u1089 \u1090 \u1088 \u1086 \u1081 \u1082 \u1080  \u1090 \u1091 \u1085 \u1085 \u1077 \u1083 \u1103  6in4."\
\
read -p "\uc0\u1042 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  SERVER IP: " SERVER_IP\
read -p "\uc0\u1042 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  IPv6 CLIENT P2P: " CLIENT_P2P\
read -p "\uc0\u1042 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  IPv6 PD ADDRESS/64: " PD_ADDRESS\
\
# \uc0\u1064 \u1072 \u1075  3: \u1053 \u1072 \u1089 \u1090 \u1088 \u1086 \u1081 \u1082 \u1072  \u1080 \u1085 \u1090 \u1077 \u1088 \u1092 \u1077 \u1081 \u1089 \u1072  6in4\
echo "\uc0\u1053 \u1072 \u1089 \u1090 \u1088 \u1086 \u1081 \u1082 \u1072  \u1080 \u1085 \u1090 \u1077 \u1088 \u1092 \u1077 \u1081 \u1089 \u1072  6in4..."\
cat <<EOF > /etc/config/network\
config interface 'tunnel_6in4'\
    option proto '6in4'\
    option peeraddr '$SERVER_IP'  # IP \uc0\u1091 \u1076 \u1072 \u1083 \u1105 \u1085 \u1085 \u1086 \u1075 \u1086  \u1089 \u1077 \u1088 \u1074 \u1077 \u1088 \u1072 \
    option ip6addr '$CLIENT_P2P'  # \uc0\u1058 \u1074 \u1086 \u1081  IPv6-\u1072 \u1076 \u1088 \u1077 \u1089 \
    list ip6prefix '$PD_ADDRESS'  # IPv6 PD ADDRESS/64\
EOF\
\
# \uc0\u1064 \u1072 \u1075  4: \u1053 \u1072 \u1089 \u1090 \u1088 \u1086 \u1081 \u1082 \u1072  \u1092 \u1072 \u1077 \u1088 \u1074 \u1086 \u1083 \u1072 \
echo "\uc0\u1053 \u1072 \u1089 \u1090 \u1088 \u1086 \u1081 \u1082 \u1072  \u1092 \u1072 \u1077 \u1088 \u1074 \u1086 \u1083 \u1072 ..."\
uci set firewall.@zone[1].network='wan tunnel_6in4'\
uci commit firewall\
/etc/init.d/firewall restart\
\
# \uc0\u1064 \u1072 \u1075  5: \u1047 \u1072 \u1087 \u1088 \u1086 \u1089  API-\u1082 \u1083 \u1102 \u1095 \u1072  \u1080  Tunnel ID \u1091  \u1087 \u1086 \u1083 \u1100 \u1079 \u1086 \u1074 \u1072 \u1090 \u1077 \u1083 \u1103 \
echo "\uc0\u1044 \u1083 \u1103  \u1076 \u1080 \u1085 \u1072 \u1084 \u1080 \u1095 \u1077 \u1089 \u1082 \u1086 \u1075 \u1086  \u1086 \u1073 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 \u1080 \u1103  IP, \u1074 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  \u1074 \u1072 \u1096  API-\u1082 \u1083 \u1102 \u1095  \u1080  Tunnel ID."\
\
read -p "\uc0\u1042 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  \u1074 \u1072 \u1096  API-\u1082 \u1083 \u1102 \u1095 : " API_KEY\
read -p "\uc0\u1042 \u1074 \u1077 \u1076 \u1080 \u1090 \u1077  \u1074 \u1072 \u1096  Tunnel ID: " TUNNEL_ID\
\
# \uc0\u1064 \u1072 \u1075  6: \u1057 \u1086 \u1079 \u1076 \u1072 \u1085 \u1080 \u1077  \u1089 \u1082 \u1088 \u1080 \u1087 \u1090 \u1072  \u1076 \u1083 \u1103  \u1076 \u1080 \u1085 \u1072 \u1084 \u1080 \u1095 \u1077 \u1089 \u1082 \u1086 \u1075 \u1086  \u1086 \u1073 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 \u1080 \u1103  IP\
echo "\uc0\u1057 \u1086 \u1079 \u1076 \u1072 \u1085 \u1080 \u1077  \u1089 \u1082 \u1088 \u1080 \u1087 \u1090 \u1072  \u1076 \u1083 \u1103  \u1076 \u1080 \u1085 \u1072 \u1084 \u1080 \u1095 \u1077 \u1089 \u1082 \u1086 \u1075 \u1086  \u1086 \u1073 \u1085 \u1086 \u1074 \u1083 \u1077 \u1085 \u1080 \u1103  IP..."\
cat <<EOF > /etc/hotplug.d/iface/90-send-wan-ip-to-6in4\
#!/bin/sh\
\
# \uc0\u1055 \u1088 \u1086 \u1074 \u1077 \u1088 \u1103 \u1077 \u1084 , \u1095 \u1090 \u1086  \u1080 \u1085 \u1090 \u1077 \u1088 \u1092 \u1077 \u1081 \u1089  \u1072 \u1082 \u1090 \u1080 \u1074 \u1077 \u1085 \
if [ "\\$INTERFACE" = "wan" ] && [ "\\$ACTION" = "ifup" ]; then\
    # \uc0\u1055 \u1086 \u1083 \u1091 \u1095 \u1072 \u1077 \u1084  \u1074 \u1085 \u1077 \u1096 \u1085 \u1080 \u1081  IPv4 \u1072 \u1076 \u1088 \u1077 \u1089 \
    WAN_IP=\\$(ifstatus wan | jsonfilter -e '@.interface.ipaddr[0]')\
\
    # \uc0\u1054 \u1090 \u1087 \u1088 \u1072 \u1074 \u1083 \u1103 \u1077 \u1084  \u1086 \u1073 \u1085 \u1086 \u1074 \u1083 \u1105 \u1085 \u1085 \u1099 \u1081  IP \u1085 \u1072  \u1089 \u1077 \u1088 \u1074 \u1077 \u1088  6in4\
    curl -v --request PUT \\\
    --url "https://6in4.ru/tunnel/\\$API_KEY/\\$TUNNEL_ID" \\\
    --header 'Content-Type: application/json' \\\
    --data '\{"ipv4remote": "\\$WAN_IP"\}'\
fi\
EOF\
\
# \uc0\u1044 \u1077 \u1083 \u1072 \u1077 \u1084  \u1089 \u1082 \u1088 \u1080 \u1087 \u1090  \u1080 \u1089 \u1087 \u1086 \u1083 \u1085 \u1080 \u1084 \u1099 \u1084 \
chmod +x /etc/hotplug.d/iface/90-send-wan-ip-to-6in4\
\
# \uc0\u1064 \u1072 \u1075  7: \u1059 \u1076 \u1072 \u1083 \u1077 \u1085 \u1080 \u1077  \u1089 \u1077 \u1082 \u1094 \u1080 \u1080  youtube \u1080  \u1076 \u1086 \u1084 \u1077 \u1085 \u1086 \u1074  \u1080 \u1079  other_zapret \u1074  /etc/config/youtubeUnblock\
echo "\uc0\u1059 \u1076 \u1072 \u1083 \u1077 \u1085 \u1080 \u1077  \u1089 \u1077 \u1082 \u1094 \u1080 \u1080  'youtube' \u1080  \u1076 \u1086 \u1084 \u1077 \u1085 \u1086 \u1074  \u1080 \u1079  'other_zapret' \u1074  \u1082 \u1086 \u1085 \u1092 \u1080 \u1075 \u1091 \u1088 \u1072 \u1094 \u1080 \u1080  youtubeUnblock..."\
\
# \uc0\u1059 \u1076 \u1072 \u1083 \u1103 \u1077 \u1084  \u1089 \u1077 \u1082 \u1094 \u1080 \u1102  youtube\
sed -i '/config section.*youtube/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*youtube.com/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*ggpht.com/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*ytimg.com/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*play.google.com/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*youtu.be/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*googleapis.com/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*googleusercontent.com/d' /etc/config/youtubeUnblock\
sed -i '/list sni_domains.*gstatic.com/d' /etc/config/youtubeUnblock\
\
# \uc0\u1059 \u1076 \u1072 \u1083 \u1103 \u1077 \u1084  \u1076 \u1086 \u1084 \u1077 \u1085 \u1099  \u1080 \u1079  \u1089 \u1077 \u1082 \u1094 \u1080 \u1080  other_zapret\
DOMAINS=("cdninstagram.com" "instagram.com" "ig.me" "fbcdn.net" "facebook.com" "facebook.net" "twitter.com" "t.co" "twimg.com" "ads-twitter.com" "x.com" "pscp.tv" "twtrdns.net" "twttr.com" "periscope.tv" "tweetdeck.com" "twitpic.com" "twitter.co" "twitterinc.com" "twitteroauth.com" "twitterstat.us")\
for DOMAIN in "$\{DOMAINS[@]\}"; do\
    sed -i "/list sni_domains.*$DOMAIN/d" /etc/config/youtubeUnblock\
done\
\
# \uc0\u1055 \u1088 \u1080 \u1084 \u1077 \u1085 \u1103 \u1077 \u1084  \u1080 \u1079 \u1084 \u1077 \u1085 \u1077 \u1085 \u1080 \u1103  \u1080  \u1087 \u1077 \u1088 \u1077 \u1079 \u1072 \u1087 \u1091 \u1089 \u1082 \u1072 \u1077 \u1084  \u1089 \u1083 \u1091 \u1078 \u1073 \u1091  youtubeUnblock\
echo "\uc0\u1055 \u1088 \u1080 \u1084 \u1077 \u1085 \u1077 \u1085 \u1080 \u1077  \u1080 \u1079 \u1084 \u1077 \u1085 \u1077 \u1085 \u1080 \u1081  \u1080  \u1087 \u1077 \u1088 \u1077 \u1079 \u1072 \u1087 \u1091 \u1089 \u1082  \u1089 \u1083 \u1091 \u1078 \u1073 \u1099  youtubeUnblock..."\
/etc/init.d/youtubeUnblock restart\
\
# \uc0\u1042 \u1099 \u1074 \u1086 \u1076 \u1080 \u1084  \u1092 \u1080 \u1085 \u1072 \u1083 \u1100 \u1085 \u1086 \u1077  \u1089 \u1086 \u1086 \u1073 \u1097 \u1077 \u1085 \u1080 \u1077 \
echo "\uc0\u1050 \u1086 \u1085 \u1092 \u1080 \u1075 \u1091 \u1088 \u1072 \u1094 \u1080 \u1103  \u1079 \u1072 \u1074 \u1077 \u1088 \u1096 \u1077 \u1085 \u1072 . \u1055 \u1088 \u1080 \u1103 \u1090 \u1085 \u1086 \u1075 \u1086  \u1080 \u1089 \u1087 \u1086 \u1083 \u1100 \u1079 \u1086 \u1074 \u1072 \u1085 \u1080 \u1103 !"\
}