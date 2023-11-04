source common.sh

MY_SQL_PASSWORD=$1

if [ -z "$1" ]; then

  echo -e "\e[31 input is missing \e[0m"
  exit

fi

echo -e "\e[32m disable the default nodejs version \e[0m"
dnf module disable nodejs -y &>>log_file
check_status

echo -e "\e[32m enabling the nodejs:18 \e[0m"
dnf module enable nodejs:18 -y &>>log_file
check_status

echo -e "\e[32m installing the nodejs \e[0m"
dnf install nodejs -y &>>log_file
check_status

echo -e "\e[32m copying the service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>log_file
check_status

id expense &>>log_file
if [ $? -ne 0 ]; then
  echo -e "\e[32m deleting the existing the user \e[0m"
  useradd expense &>>log_file
  check_status
fi

if [ ! -d /app ]; then
  echo -e "\e[32m creating the app directory \e[0m"
  mkdir /app &>>log_file
  check_status
fi

echo -e "\e[32m changing the app directory \e[0m"
rm -rf /app/* &>>log_file
check_status

echo -e "\e[32m Download the application code \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>log_file
check_status

echo -e "\e[32m changing the app directory \e[0m"
cd /app &>>log_file
check_status

echo -e "\e[32m unzip the content \e[0m"
unzip /tmp/backend.zip &>>log_file
check_status

echo -e "\e[32m downloading the dependencies \e[0m"
npm install &>>log_file
check_status

echo -e "\e[32m installing the mysql client \e[0m"
dnf install mysql -y &>>log_file
check_status

echo -e "\e[32m load the scheme \e[0m"
mysql -h 172.31.43.125 -uroot -p${MY_SQL_PASSWORD} </app/schema/backend.sql &>>log_file
check_status

echo -e "\e[32m starting the service \e[0m"
systemctl daemon-reload &>>log_file
systemctl enable backend &>>log_file
systemctl restart backend &>>log_file
check_status


