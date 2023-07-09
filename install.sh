## Open firewall ports
sudo firewall-cmd --add-port=5432/tcp --permanent # PostgreSQL
sudo firewall-cmd --reload


## Enable the postgresql 12 or postgresql 13 module stream
sudo dnf module reset -y postgresql
sudo dnf module enable -y postgresql:13

## Install the database
sudo dnf install -y postgresql-server

## Initialize the database
sudo postgresql-setup --initdb

## In the /var/lib/pgsql/data/postgresql.conf file, switch the password storage mechanism from md5 to scram-sha-256
sudo sed -i "s/#password_encryption.*/password_encryption = scram-sha-256/"  /var/lib/pgsql/data/postgresql.conf

## Uncomment the "listen_addresses" line
sudo sed -i "s/#listen_addresses/listen_addresses/" "/var/lib/pgsql/data/postgresql.conf"

## Change "localhost" with the host name
sudo sed -i "s/localhost/$HOSTNAME/" "/var/lib/pgsql/data/postgresql.conf"

## Add the following line to "pg_hba.conf"
sudo sh -c 'echo "host  all  all 0.0.0.0/0 scram-sha-256" >> /var/lib/pgsql/data/pg_hba.conf'

## Enable and start the database
sudo systemctl enable --now postgresql
