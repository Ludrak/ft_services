#! /bin/bash

set -e

sed -i "s~\$cfg\['blowfish_secret'\] = '';~\$cfg\['blowfish_secret'\] = 'STRINGOFTHIRTYTWORANDOMCHARACTERS';~g" ${PMA_LOCATION}/config.inc.php
sed -i "s~\$cfg\['Servers'\]\[\$i\]\['user'\] = '';~\$cfg\['Servers'\]\[\$i\]\['user'\] = '$(cat /etc/kub/secret-volume/dbuser)';~g" ${PMA_LOCATION}/config.inc.php
sed -i "s~\$cfg\['Servers'\]\[\$i\]\['password'\] = '';~\$cfg\['Servers'\]\[\$i\]\['password'\] = '$(cat /etc/kub/secret-volume/dbpass)';~g" ${PMA_LOCATION}/config.inc.php

# REVIEW uncomment this for production
# chmod 000 /etc/kub

# start nginx and php servers
php-fpm7 && nginx