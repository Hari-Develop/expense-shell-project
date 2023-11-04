source common.sh

echo -e "\e[32m disable the default nodejs version \e[0m"
dnf module disable nodejs -y
check_status

echo -e "\e[32m enabling the nodejs:18 \e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[32m installing the nodejs \e[0m"
dnf install nodejs -y

echo -e "\e[32m copying the service file \e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[32m deleting the existing the user \e[0m"
userdel -r expense

echo -e "\e[32m adding the user \e[0m"
useradd expense

echo -e "\e[32m removing the directory \e[0m"
rm -rf /app

echo -e "\e[32m creating the app directory \e[0m"
mkdir /app

echo -e "\e[32m Download the application code \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip

echo -e "\e[32m changing the app directory \e[0m"
cd /app

echo -e "\e[32m unzip the content \e[0m"
unzip /tmp/backend.zip

echo -e "\e[32m downloading the dependencies \e[0m"
npm install

echo -e "\e[32m installing the mysql client \e[0m"
dnf install mysql -y

echo -e "\e[32m load the scheme \e[0m"
mysql -h 172.31.43.125 -uroot -pExpenseApp@1 < /app/schema/backend.sql

echo -e "\e[32m starting the service \e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend


