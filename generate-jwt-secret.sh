SECRET=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32`
sed -i -e "s/^\(JWT_SECRET=\).*/\1$SECRET/" ./config/koel-config.env