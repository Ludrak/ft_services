# liste les mot de passe à mettre dans les secrets
echo -e "mariadbID:\t$(echo -n 'admin' | base64)"
echo -e "mariadbPass:\t$(echo -n 'adminpass' | base64)"