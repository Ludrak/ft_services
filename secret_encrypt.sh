# liste les mot de passe à mettre dans les secrets
echo -e "mariadb_rootID:\t\t$(echo -n 'root' | base64)"
echo -e "mariadb_rootPass:\t$(echo -n 'toor' | base64)"
echo -e "mariadbID:\t\t$(echo -n 'admin' | base64)"
echo -e "mariadbPass:\t\t$(echo -n 'adminpass' | base64)"