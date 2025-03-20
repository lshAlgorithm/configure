#!/bin/bash
username=""
password=""

# Check weather already connected to the Internet.
if curl -4 -s ip.sb -m 10 > /dev/null 2>&1; then
  response=$(curl -4 -s ip.sb)
  if [[ $response =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e $(date '+[%Y-%m-%d %H:%M:%S]')" \e[32mYou have \e[1malready\e[0m \e[32mconnected to the Internet.\e[0m"
    echo -e $(date '+[%Y-%m-%d %H:%M:%S]')" Your current IPv4 address is \e[1m$(curl -4 -s ip.sb)\e[0m."
    if curl -6 -s ip.sb > /dev/null 2>&1; then
      echo -e $(date '+[%Y-%m-%d %H:%M:%S]')" Your current IPv6 address is \e[1m$(curl -6 -s ip.sb)\e[0m."
    fi
    exit 0
  fi
fi

response=$(curl -s "http://123.123.123.123/")
data=wlanuserip=$(echo "$response" | awk -F"wlanuserip=" '{print $2}' | awk -F"'</script>" '{print $1}')
encoded_data=$(jq -sRrn --arg x "$data" '$x|@uri')
urldata='userId='$username'&password='$password'&service=shu&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false&queryString='$encoded_data

# Fetch the webpage
response=$(curl -s 'http://10.10.9.9/eportal/InterFace.do?method=login' -H 'Accept: */*' -H 'Accept-Language: zh-CN,zh;q=0.9' -H 'Connection: keep-alive' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_OPERATORPWD=; JSESSIONID=' -H 'DNT: 1' -H 'Origin: http://10.10.9.9' -H 'Referer: http://10.10.9.9/eportal/index.jsp?$data' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' --insecure --data-raw  $urldata)

# Check if the string "success" is in the response
if [[ $response == *"success"* ]]; then
  # Print the success message in green
  echo -e $(date '+[%Y-%m-%d %H:%M:%S]')" \e[32mSuccessfully connected to the Internet.\e[0m"
  echo -e $(date '+[%Y-%m-%d %H:%M:%S]')" Your current IPv4 address is \e[1m$(curl -4 -s ip.sb)\e[0m."
  if curl -6 -s ip.sb > /dev/null 2>&1; then
      echo -e $(date '+[%Y-%m-%d %H:%M:%S]')" Your current IPv6 address is \e[1m$(curl -6 -s ip.sb)\e[0m."
  fi
else
  # Print an error message
  echo $(date '+[%Y-%m-%d %H:%M:%S]') "\e[31mFailed to connect to the Internet.\e[0m"
  echo $(date '+[%Y-%m-%d %H:%M:%S]') $response
fi
