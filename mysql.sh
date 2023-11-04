source common.sh

echo -e "\e[32m disabling the default mysql \e[0m"
dnf module disable mysql -y

echo -e "\e[32m copying the repo file  \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[32m installing the mysql \e[0m"
dnf install mysql-community-server -y

echo -e "\e[32m setting up the root password \e[0m"
mysql_secure_installation --set-root-pass ExpenseApp@1

echo -e "\e[32m starting the mysql service \e[32m"
systemctl enable mysqld
systemctl restart mysqld