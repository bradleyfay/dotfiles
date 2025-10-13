# History configuration

# History file location
HISTFILE=~/.zsh_history

# Number of commands to remember in memory
HISTSIZE=10000

# Number of commands to save to file
SAVEHIST=10000

# Share history between all sessions
setopt SHARE_HISTORY

# Don't save duplicate commands
setopt HIST_IGNORE_DUPS

# Don't save commands that start with a space
setopt HIST_IGNORE_SPACE
