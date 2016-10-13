#Settings:

setfont /share/backup/zhoushiyi/opt/fonts:$font
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

#Working related settings
source ~/.bashrc

