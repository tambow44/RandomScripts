#

PATH=${PATH}:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

#export PS1="\[\e[32m\]\u\[\e[m\]@\[\e[31m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\e[35m\]\A\[\e[m\]\[\e[36m\]]\[\e[m\] ~  \n\$ "
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[31m\]\h\[\e[m\] \[\e[36m\][\[\e[m\]\[\[\e[35m\]\A\[\e[m\]\[\e[36m\]]\[\e[m\]\] \[\e[32m\]\W\[\e[m\] \[\e[36m\]~$\[\e[m\] "

# User specific aliases and functions
##### ALIAS #####

alias    cls='clear'
alias    src='source ~/.bash_profile'
alias     bc='bc -l'
alias   logf="ls -t | egrep -e '[0-9].log$' | head -1"


if [ -f "$(command -v vim)" ]; then
        alias vi='$(command -v vim)'
fi


##### FUNCTIONS #####

tit () {
        tail -f "$(logf)" |
                if (( $# )); then
                    grep "$@"
                else
                    cat
                fi
}

lit () {
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
            zgrep $1 *$2* /dev/null | sed 's/\:/: /g'
        ;;
        3)
            case "$1" in
                "-c")
                    zgrep -c $2 *$3* /dev/null | grep --color=auto -v ":0" | sed 's/\:/: /g'
                ;;
                "-i")
                    zgrep -i $2 *$3* /dev/null | sed 's/\:/: /g'
                ;;
                *[ic])
                    zgrep -ic $2 *$3* /dev/null | grep --color=auto -v ":0" | sed 's/\:/: /g'
                ;;
            esac
        ;;
    esac
}

if [ -d /u01/app/oracle/product/10.2.0/client ]; then
        ORACLE_HOME=/u01/app/oracle/product/10.2.0/client; export ORACLE_HOME
        PATH=/usr/local/bin:$ORACLE_HOME/bin:/usr/sbin:/usr/bin:/usr/jre1.5.0_03/lib/sparc; export PATH
        LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib:/usr/dt/lib; export LD_LIBRARY_PATH
fi

## Solaris Boxes
if [ "$(uname)" = 'SunOS' ]; then
        alias logs='cd /var/opt/gcti/logs/'

        if [ -f /var/opt/gcti/logs/supertail.sh ]; then
                alias stail='/var/opt/gcti/logs/supertail.sh'
        fi
elif [ "$(uname)" = 'Linux' ]; then
        alias logs='cd /log/gcti'
fi
