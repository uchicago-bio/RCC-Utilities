# .bashrc
# For RCC at UChicago
#
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# ==============================================================================
# User specific environment
# ==============================================================================
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# ==============================================================================
# Load software modules needed for RCC
# ==============================================================================
module load emacs
module load python

# ==============================================================================
# Customize your shell
# ==============================================================================
export PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\n\$ "

# ==============================================================================
# User specific aliases and functions
# ==============================================================================
echo "Setting up common aliases..."
echo ""

# Make 'ls' more informative and colorful
alias ls='ls -F --color=auto'

# Create 'll' for a detailed, long-format listing of all files
alias ll='ls -alF'

# Add color to 'grep' results to make them easier to read
alias grep='grep --color=auto'

# Shortcut to go up one directory
alias ..='cd ..'

# Safety alias: prompt before overwriting or removing files
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias clean='rm *~ *.o core .*~ #*'
alias h="history"
alias m="more"
alias q="squeue --user=$USER"
alias clean_slurm="rm *.err *.out"
alias clean_slurm_bang="rm -f *.err *.out"
alias gh='cd /home/$USER/RCC-Utilities'
alias p='cd /project/mpcs56430'
alias p2='cd /project2/mpcs56430'
alias s2='cd /scratch/midway2/$USER'
alias s3='cd /scratch/midway3/$USER'

