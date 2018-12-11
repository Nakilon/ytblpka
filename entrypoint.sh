sed "s/localhost/$HOSTNAME/; s/hackme/$PASSWORD/g; s/<bind-address>127\.0\.0\.1</<bind-address>0.0.0.0</" < /etc/icecast.xml > icecast.xml
sed -i "s/localhost/$HOSTNAME/g; s/TITLE/$TITLE/g" /usr/share/icecast/web/player.htm
exec icecast -c icecast.xml
