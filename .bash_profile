#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -e /home/dwd/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dwd/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
source "/home/dwd/code/other/emsdk/emsdk_env.sh"
