apt-get install curl python-software-properties -y
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
apt-get update -y
apt-get upgrade -y
apt-get install nodejs -y
mkdir /var/app
cd /var/app
git clone https://github.com/redemptive/tube-data.git
cd ./tube-data
npm install
nodejs index.js