#!/bin/bash
#Instagram: @sprx.sh
##############################
#          Colors
#   PURPLE = '\033[95m'
#   CYAN = '\033[96m'
#   WHITE = '\033[37m'
#   DARKCYAN = '\033[36m'
#   BLUE = '\033[94m'
#   GREEN = '\033[92m'
#   YELLOW = '\033[93m'
#   RED = '\033[91m'
#   BOLD = '\033[1m'
#   HEADER = '\033[95m'
#   OKBLUE = '\033[94m'
#   OKGREEN = '\033[92m'
#   WARNING = '\033[93m'
#   FAIL = '\033[91m'
#   UNDERLINE = '\033[4m'
#   END = '\033[0m'
#   COREGREEN = '\033[1;35;32m'
#W  = '\033[0m'  # white (normal)
#R  = '\033[31m' # red
#G  = '\033[32m' # green
#O  = '\033[33m' # orange
#B  = '\033[34m' # blue
#P  = '\033[35m' # purple
#C  = '\033[36m' # cyan
#GR = '\033[37m' # gray
#T  = '\033[93m' # tan
#CG = '\033[1;35;32m' # magenta
##############################

csrftoken=$(curl https://www.instagram.com/accounts/login/ajax -L -i -s | grep "csrftoken" | cut -d "=" -f2 | cut -d ";" -f1)


logininstagram() {

if [[ "$yourusername" == "" ]]; then
read -p $'\033[93m ┌─ \033[96m[✗]─[username@instagram]: \e[0m' username
else
username="${username:-${yourusername}}"
fi

if [[ "$yourpassword" == "" ]]; then
read -s -p $'\033[93m └─ \033[96m[✗]─[password@instagram]: \e[0m' password
else
password="${password:-${yourpassword}}"
fi

ck_login=$(curl -c cookies.txt 'https://www.instagram.com/accounts/login/ajax/' -H 'Cookie: csrftoken='$csrftoken'' -H 'X-Instagram-AJAX: 1' -H 'Referer: https://www.instagram.com/' -H 'X-CSRFToken:'$csrftoken'' -H 'X-Requested-With: XMLHttpRequest' --data 'username='$username'&password='$password'&intent' -L --compressed -s | grep -o '"authenticated": true')

if [[ "$ck_login" == *'"authenticated": true'* ]]; then

printf "\n\033[91m✡\033[96m Login Successful \033[91m✡\n"
else
printf "\n\033[91m[!] Login Information Incorrect, Resetting.\n\e[0m"
sleep 3
reset
banner
logininstagram
fi

}

writemessage() {

IFS=$'\n'
safeamount="10"
safemessage="Follow @sprx.sh :)"
read -p $'\033[93m ┌─ \033[96m[✗]─[message@instagram]: ' spammessage
message="${spammessage:-${safemessage}}"
read -p $'\033[93m │ \033[96m [✗]─[amount@instagram]: ' spamamount
amount="${spamamount:-${safeamount}}"

}


selectaccount() {

read -p $'\033[93m └─ \033[96m[✗]─[target@instagram]: ' accountuser

checkaccount=$(curl -L -s https://www.instagram.com/$accountuser/ | grep -c "PAGE NOT FOUND")
if [[ "$checkaccount" == 1 ]]; then
printf "\n\033[91m[!] User Not Found, Resetting.\n\e[0m"
sleep 1
account
fi

curl -s -L https://www.instagram.com/$accountuser | grep  -o '"id":"..................[0-9]' | cut -d ":" -f2 | tr -d '"' > media_id
postnumber="1"
printf "\033[91m✡\033[96m Account Selected Successful \033[91m✡\n"
printf "\033[93m\n   Darker Text = Latest Post\n"
printf "\033[93m┌──────────────────────────────┐\n"
for id in $(cat media_id); do
printf "\033[93m│  \033[91mPost: \033[37m%s \033[93m  │\e[1;77m %s\n" $id $postnumber
let postnumber++
done
printf "\033[93m└──────────────────────────────┘\n"
latestpost="0"
read -p $'\033[93m └─ \033[96m[✗]─[postselect@instagram]: ' post
post="${post:-${latestpost}}"

media_id=$(sed ''$post'q;d' media_id)

}

spammer() {

ending=.
for i in $(seq 1 $amount); do

printf "     \033[91m✗\033[96m[Sending Message]:\e[1;93m%s\e[1;77m/\e[0m\e[1;93m%s\e[0m" $i $amount
IFS=$'\n'

comment=$(curl  -i -s -k  -X $'POST'     -H $'Host: www.instagram.com' -H $'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0' -H $'Accept: */*' -H $'Accept-Language: en-US,en;q=0.5' -H $'Accept-Encoding: gzip, deflate'  -H $'X-CSRFToken:'$csrftoken'' -H $'X-Instagram-AJAX: 9de6d949df8f' -H $'Content-Type: application/x-www-form-urlencoded' -H $'X-Requested-With: XMLHttpRequest' -H $'Cookie: csrftoken='$csrftoken'; ' -H $'Connection: close'     -b cookies.txt     --data-binary $'comment_text='$message' '$count'&replied_to_comment_id='     $'https://www.instagram.com/web/comments/'$media_id'/add/' -w "\n%{http_code}\n" | grep -a "HTTP/2 200"); if [[ "$comment" == *'HTTP/2 200'* ]]; then printf "\n";  printf "%s\n" $media_id >> commented.txt ; else printf "\e[1;93m [ERROR] \e[0m \e[1;77m- [1:30 Second Break]\e[0m\n"; sleep 90;  fi; 
sleep 1
done
printf "\033[91m[Instagram] \033[37m- https://www.instagram.com/sprx.sh/ - @sprx.sh\033[93m\n"
}

dependencies() {

command -v curl > /dev/null 2>&1 || { echo >&2 "CURL not Installed! Run ./install.sh. Exiting..."; exit 1; }

}

banner() {

reset
printf "\033[96m██╗ ██████╗       ███████╗██████╗  █████╗ ███╗   ███╗\n"
printf "██║██╔════╝       ██╔════╝██╔══██╗██╔══██╗████╗ ████║\n"
printf "██║██║  ███╗█████╗███████╗██████╔╝███████║██╔████╔██║\n"
printf "██║██║   ██║╚════╝╚════██║██╔═══╝ ██╔══██║██║╚██╔╝██║\n"
printf "██║╚██████╔╝      ███████║██║     ██║  ██║██║ ╚═╝ ██║\n"
printf "╚═╝ ╚═════╝       ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝\n"
printf "              \033[36mBy: @sprx.sh | <3                      \n"
printf "\n"
printf "\033[93m┌─────────────────────────────────────────────────────────────────┐\n"
printf "│ \033[91m[Instagram] \033[37m- https://www.instagram.com/sprx.sh/\033[93m                │\n"
printf "│ \033[91m[Updater] \033[37m- https://github.com/sprxsh/ig-spammer\033[93m                │\n"
printf "└─────────────────────────────────────────────────────────────────┘\n"
}

banner
dependencies
logininstagram
writemessage
selectaccount
spammer




