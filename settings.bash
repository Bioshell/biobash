#Settings:
export user="Zhou Shiyi"
export EMAIL="zhoushiyi25@hotmail.com"
# setfont /share/backup/zhoushiyi/opt/fonts:$font

# Change the TERM environment variable (to get 256 colors) even if you are
# accessing your system through ssh and using either Tmux or GNU Screen:
if [ "$TERM" = "xterm" ] || [ "$TERM" = "xterm-256color" ]
    then
        export TERM=xterm-256color
        export HAS_256_COLORS=yes
fi
if [ "$TERM" = "screen" ] && [ "$HAS_256_COLORS" = "yes" ]
    then
        export TERM=screen-256color
fi
#
prompt_context() {
   if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
      prompt_segment black default "%(!.%{%F{yellow}%}.)"
   fi
}

# Other sources
source ~/.bash/exports.bash
source ~/.bash/aliases.bash
source ~/.bash/functions.bash
source ~/.bash/template.bash
#Working related settings
# source ~/.bashrc

