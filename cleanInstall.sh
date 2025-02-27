#!/bin/bash
STORE="$PWD/store"
CTMUX="$HOME/.tmux.conf" # .tmux.conf's filePath
PTMUX="$HOME/.tmux/plugins"
CZSH="$HOME/.zshrc"
CNVIM="$HOME/.config/nvim"
STARTER="false"

LVIM="https://github.com/LazyVim/starter"
GITMUX="https://github.com/tmux-plugins/tpm"

echo -n "Starting CLEAN install========================================================================"
# echo -n "You may need to run this as Sudo in order for installation to work correctly, you have been warned"

for i in "$@"; do
	case $i in
	-s | --starter)
		STARTER="true"
		shift
		;;
	-*)
		echo "Unknown option $i"
		exit 1
		;;
	*) ;;

	esac
done
if [ $STARTER == "true" ]; then echo "STARTER OPTION HAS BEEN SELECTED: Modifying config files respectively"; fi

assertDir() {
	local fPath=$1
	if [ -d "$fPath" ]; then
		echo "$fPath found"
	else
		mkdir "$1"
	fi

}

#ZSH PORTION
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [ "$STARTER" == "true" ]; then echo "ZSH is now installed, add plugins in .zshrc, you can find lists of plugins online, I'd recommend powerlevel10k but you'll have to install seperately from their github for that"; fi

#TMUX PORTION
apt install tmux
("git clone https://github.com/$GITMUX $PTMUX/tpm")
if [ "$STARTER" == "true" ]; then
	echo "run '~/.tmux/plugins/tpm/tpm'" >>"$CTMUX"
	echo "TMUX and its plugin manager have been installed,  I recommend catppuccin and gitmux and just fiddle around for a bit to get a feel for it"
fi

#NVIM PORTION
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo rm nvim-linux-x86_64.tar.gz
assertDir "$CNVIM"
("git clone $LVIM $CNVIM")
if [ "$STARTER" == "true" ]; then
	echo "export PATH=$PATH:/opt/nvim-linux-x86_64/bin" >>"$CZSH"
	echo "NVIM INSTALLED: You now use vim btw"
fi

##GITHUBCLI PORTION
# (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
# 	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
#         && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
#         && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
# 	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
# 	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
# 	&& sudo apt update \
# 	&& sudo apt install gh -y

echo -n "config installer is done====================================="
