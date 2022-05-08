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
alias q="squeue --user=abinkowski"
alias clean_slurm="rm *.[err|out]"

. /software/Anaconda3-5.1.0-el6-x86_64/etc/profile.d/conda.sh
