source common.sh

echo -e "\e[32m installing nginx \e[0m"
sudo dnf install nginx &>>log_file
check_status

echo -e "\e[32m copying the repo file into expense.conf \e[0m"
cp expens.conf /etc/nginx/default.d/expense.conf &>>log_file
check_status

echo -e "\e[32m removing default content of nginx \e[0m"
rm -rf /usr/share/nginx/html/* &>>log_file
check_status

echo -e "\e[32m downloading the frontend content \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>log_file
check_status

echo -e "\e[32m unzip the download content by changing the location \e[0m"
cd /usr/share/nginx/html &>>log_file
unzip /tmp/frontend.zip &>>log_file
check_status

echo -e "\e[32m starting the nginx service \e[0m"
systemctl enable nginx &>>log_file
systemctl restart nginx &>>log_file
check_status


