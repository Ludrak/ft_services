set -e

sed -i "s~\$cfg\['blowfish_secret'\] = '';~\$cfg\['blowfish_secret'\] = 'STRINGOFTHIRTYTWORANDOMCHARACTERS';~g" ${PMA_LOCATION}/config.inc.php
sed -i "s~\$cfg\['Servers'\]\[\$i\]\['user'\] = '';~\$cfg\['Servers'\]\[\$i\]\['user'\] = '$(cat /etc/secret-volume/username)';~g" ${PMA_LOCATION}/config.inc.php
sed -i "s~\$cfg\['Servers'\]\[\$i\]\['password'\] = '';~\$cfg\['Servers'\]\[\$i\]\['password'\] = '$(cat /etc/secret-volume/password)';~g" ${PMA_LOCATION}/config.inc.php
