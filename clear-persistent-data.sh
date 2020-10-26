read -p "Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	exit 1
fi

rm -r persist/db/*
rm persist/ssl/certs/*
rm persist/ssl/private/*
