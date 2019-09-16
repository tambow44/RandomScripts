##### ENV
	export PATH=${PATH}:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/boksm/bin/

	export PS1="\[\e[32m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[31m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\[\e[35m\]\t\[\e[m\]\[\e[36m\]]\[\e[m\]\] \[\e[32m\]\W\[\e[m\] \[\e[36m\]~$\[\e[m\] "
#	export PS1="\[\e[32m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[31m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\e[35m\]\t\[\e[m\]\[\e[36m\]]\[\e[m\] \[\e[32m\]\W\[\e[m\] \[\e[36m\]$\[\e[m\] \[$(tput sgr0)\]"
	export PS2="\[\e[33m\]>>\[\e[m\]  "

##### ALIASES
alias  cls='clear'
alias  src='source ~/.bash_profile; cls'
alias   bc='bc -l'
alias   ll='ls --color=auto -lha'
alias   ls='ls --color=auto'
alias   df='df -kh'
#alias	logf="ls -t | egrep -e '[0-9].log$' | head -1"

if [ -f "$(command -v vim)" ]; then
	alias vi='$(command -v vim)'
	export EDITOR=vim
fi

##### FUNCTIONS

clang () {
    if [ $# != 1 ]; then
	printf "error: no input files"
	return 1
else
	FILE="$(echo $1 | sed 's/\.[a-z]*$//g')"
	/usr/bin/clang $1 -o $FILE.o -Wall -Wextra -Wpedantic -std=c99
fi
}


tit () {
	printf "Tailing: $(logf) ... \n"
	tail -f "$(logf)" |
	
	if (( $# )); then
		grep -n "$@"
	else
		cat
	fi
}

lit () {
	printf "Tailing: $(logf) ... \n"
	tail -f "$(logf)" |

	if (( $# )); then
		less -p "$@" $(logf)
	else
		less $(logf)
	fi
}

grit () {
	case "$#" in
		0 | 1)
			printf "Usage: {-c|-i}\n";
			printf "\tgrit [-ci] \$string \$file\n";
			printf "\t-c to invoke only count condition.\n";
			printf "\t-i to invoke only insenitive condition.\n"
		;;
		2)
			zgrep -n $1 *$2* /dev/null | sed 's/\:/: /g'
		;;
		3)
	case "$1" in
		"-c")
			zgrep -c $2 *$3* /dev/null | grep -v ":0" | sed 's/\:/: /g'
                ;;
                "-i")
			zgrep -in $2 *$3* /dev/null | sed 's/\:/: /g'
                ;;
                *[ic])
			zgrep -ic $2 *$3* /dev/null | grep -v ":0" | sed 's/\:/: /g'
                ;;
            esac
        ;;
    esac
}

proxy_on ()
{
    proxy="webproxysouth"
    domain="corp.ssi.govt.nz"
    port="8080"
    printf "Enter your network username: "
    read name
    echo -n "Enter your network password: "
    read -s password
    password=$(printf $password | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
    http_proxy="http://$name:$password@$proxy.$domain:$port"
	export {https_proxy,HTTP_PROXY,HTTPS_PROXY,FTP_PROXY,SOCKS_PROXY}=$http_proxy
	export {no_proxy,NO_PROXY}="localhost,127.0.0.1,$USERDNSDOMAIN"
}

proxyVariables=( \
	"http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY" \
)

proxy_off(){
	for i in "${proxyVariables[@]}"; do
		unset $i
	done
}

proxy_on ()
{
    if [ -f "$(command -v xxd)" ]; then
        proxydomain="webproxy.ssi.govt.nz"
        port="8080"
        printf "Username: "
        read name
        echo -n "Password: "
        read -s password
   echo
        password=$(printf $password | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')
	for i in "${proxyVariables[@]}"; do
    		export $i="http://$name:$password@$proxydomain:$port"
	done
             unset name password port proxydomain
     else
	printf "function requires 'xxd'. "
	printf "Usually in /usr/bin/xxd.\n"
    fi
}

function gitGo() {
   if [ -z "$http_proxy" ]; then
      printf "No proxy set, enter details:\n"
      proxy_on
   fi

   if [[ "$(git status --porcelain | wc -l)" -gt 0 ]]; then
      git add .
      git status

      printf "Enter commit message: "
      read gitCommitMessage

      git commit -m "$gitCommitMessage"
      git push origin master
   fi
}

##### Differences for Sun vs. Linux
# To add more, should we run into any other OS... Fear the HP-UX

## Solaris Boxes
if [ "$(uname)" = 'SunOS' ]; then
	alias logs='cd /var/opt/gcti/logs/'
	
	if [ -f /var/opt/gcti/logs/supertail.sh ]; then
		alias stail='/var/opt/gcti/logs/supertail.sh'
	fi

	# Sun doesn't much like screen/tmux \
	# Programs like vi/m won't work unless this is 'tricked'
	if [ $TERM == "screen" ]; then
		export TERM=xterm
	fi

## Linux Boxes
elif [ "$(uname)" = 'Linux' ]; then
	alias	  ll='ls --color -lha'
	alias	  ls='ls --color=auto'
	alias	logs='cd /log/gcti'

	: # more to come
	
fi

### Print screen/tmux sessions
if [ $TERM == "screen" ]; then
	: # do nothing, we shouldn't be nesting!
else
	### SCREEN
	if [ -f "$(command -v screen)" ]; then
		if screen -list | grep -q "No Sockets"; then
			: # do nothing, no sessions!
		else
			printf "Screen connections:\n"
			screen -list | grep 'Detached' | awk '{print "\t= " $1}'
		fi
	fi
	
	### TMUX
	if [ -f "$(command -v tmux)" ]; then
		tmuxSession=$(( tmux ls ) 2>&1 | grep -c 'failed')
		
		if [ $tmuxSession -gt 0 ]; then
			: # do nothing, no sessions!
		else
			printf "tmux connections:\n"
			tmux ls | awk '{print "\t= " $1}' | sed 's/://g'
		fi
	fi
fi

