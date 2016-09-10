#############################################################
# Generic configuration that applies to all shells
#############################################################

source ~/.shellvars
source ~/.shellfn
source ~/.shellpaths
source ~/.shellaliases
source ~/shell_config

# Private/Proprietary shell aliases (not to be checked into the public repo) :)
#source ~/Dropbox/Private/Boxes/osx/.shellaliases

if [ -d $HOME/.dotfiles/zsh/ ]; then
  if [ "$(ls -A $HOME/.dotfiles/zsh/)" ]; then
    for config_file ($HOME/.dotfiles/zsh/*.zsh) source $config_file
  fi
fi


