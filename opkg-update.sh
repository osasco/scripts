#!/bin/sh
/bin/opkg update
PKTS=$(/bin/opkg list-upgradable | /bin/sed -En "s/(.*) - .* - .*/\1/p")
if [ -n "$PKTS" ]; then
	/bin/echo "$PKTS" | /usr/bin/xargs opkg upgrade
	/usr/bin/find /etc -type f -iname "*-opkg" -print0 | /usr/bin/xargs -0r rm
fi
