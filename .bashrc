# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias clean='rm *~ *.o core .*~ #*'
alias h="history"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias m="more"
