#
#       For use @ Ministry of Social Development
#       Credit to Thomas Blakely (Thomas.Blakely001@msd.govt.nz)
#

##### PATH AND SHELL

	export PATH=${PATH}:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/boksm/bin/

	export PS1="\[\e[32m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[31m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\[\e[35m\]\t\[\e[m\]\[\e[36m\]]\[\e[m\]\] \[\e[32m\]\W\[\e[m\] \[\e[36m\]~$\[\e[m\] "
	export PS2="\[\e[33m\]>>\[\e[m\]  "

##### ALIASES

	alias	  bc='bc -l'
	alias	 cls='clear'
	alias	 src='source ~/.bash_profile ; clear'
	alias	  ll='ls --color -lha'
	alias	  ls='ls --color=auto'
	alias	logf="ls -t | egrep -e '[0-9].log$' | head -1"

if [ -f "$(command -v vim)" ]; then
	alias vi='$(command -v vim)'
fi

##### FUNCTIONS

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

proxy_off(){
	proxyVariables=( \
		"http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY" \
		"FTP_PROXY" "SOCKS_PROXY" \
		"no_proxy" "NO_PROXY" \
	)

	for i in "${proxyVariables[@]}"; do
		unset $i
	done
}

## Solaris Boxes
if [ "$(uname)" = 'SunOS' ]; then
	alias logs='cd /var/opt/gcti/logs/'
	
	if [ -f /var/opt/gcti/logs/supertail.sh ]; then
		alias stail='/var/opt/gcti/logs/supertail.sh'
	fi

	# Solaris doesn't like screen/tmux
	if [ $TERM == "screen" ]; then
		export TERM=xterm
    fi

## Linux Boxes
elif [ "$(uname)" = 'Linux' ]; then
	alias logs='cd /log/gcti'
	: # more to come
fi

### Print Screen sessions
if [ -f "$(command -v screen)" ]; then
	if screen -list | grep -q "No Sockets"; then
		: # do nothing
	else
		printf "Screens connected:\n"
		screen -list | grep Detached | awk '{print "  *  " $1}'
	fi
fi

### Print tmux sessions
if [ -f "$(command -v tmux)" ]; then
	tmuxSessions=$(( tmux ls ) 2>&1 | grep -c 'failed')
	if [ $tmuxSessions -eq 1 ]; then
		: # do nothing
	else
		printf "Current tmux sessions:\n"
		printf "\t* " ; tmux ls | awk '{print $1}' | sed 's/://g'
	fi
fi
