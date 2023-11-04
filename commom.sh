check_status() {
  if [ $? -gt 0 ]; then
    echo -e "\e[31m failed the script \e[0m"
  else
    echo -e "\e[32m success the script \e[0m"
  fi
}
