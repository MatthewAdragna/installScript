#!/bin/bash

assertDir() {
  local fPath=$1
  if [ -d "$fPath" ]; then
    echo "$fPath found"
  else
    echo "Making A directory at $1"
    mkdir "$1/"
  fi

}
# ~ is stored at home
# Want to configure some basic things
#  -> zshrc ? install if not installed
#  -> tmux ? install if not installed
#  -> GitHub cli ? install if not installed
#  -> catpuccin ? um i dno
#  -> tmux plugin manager ? um i dno
#  -> nvim install ? install lazyvim and all that if not installed
#  ssh keys will have be done manually i fear
#
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
STORE="$SCRIPT_DIR/store"
CONFIG="$SCRIPT_DIR/configVar.sh"

# These are modifiable
REPO="false"
CTMUX="$HOME/.tmux.conf" # .tmux.conf's filePath
PTMUX="$HOME/.tmux/plugins"
CZSH="$HOME/.zshrc"
CNVIM="$HOME/.config/nvim"
NVIMINSTALL="$HOME/nvim/"
CLEAN="false"
STARTER="false"

if [ -f "$CONFIG" ]; then
  source "$CONFIG"
else
  echo "configVar.sh not found... continuing"
fi

DEBUG="$STORE/debug.txt"
rm "$DEBUG"
assertDir "$STORE"
touch "$DEBUG"
echo "Starting config install========================================================================"
echo "You may need to run this as Sudo in order for installation to work correctly, you have been warned"

for i in "$@"; do
  case $i in
  -r=* | --repo=*)
    REPO="${i#*=}"
    shift
    ;;
  -push | --push)
    PUSH="TRUE"
    PULL="false"
    shift
    ;;
  -pull | --pull)
    PULL="TRUE"
    PUSH="false"
    shift
    ;;
  -c | --clean)
    CLEAN="true"
    shift
    ;;
  -s | --starter)
    CLEAN="true"
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

if which git &>"$DEBUG"; then
  echo "Git is installed - Make sure you have correct ssh-keys"
else
  echo "Install Git and register your ssh keys to continue"
fi

if [ $CLEAN != "false" ]; then
  if [ $STARTER != "false" ]; then
    echo "Starter Install"
    ("bin/bash $SCRIPT_DIR/cleanInstall.sh -s")

  else
    echo "Normal Clean Install"
    ("bin/bash $SCRIPT_DIR/cleanInstall.sh")
  fi

fi

NOW=$(date '+%F_%H:%M:%S')
if [ "$PULL" != "false" ] || [ "$PUSH" != "false" ]; then
  if [ "$REPO" == "false" ]; then
    echo "Valid Repo not found: Please specify your repo using the -r or --repo flags"
    echo "Usage: -r=git@github.com/username/repo.git or similiarly --repo=git@github.com/username/repo.git"
    echo "Config installer has failed: Reason REPO not found"
    exit 2
  else
    echo "$SCRIPT_DIR/.git"
    # if [ -f "$SCRIPT_DIR/.git" ]; then
    #   echo "Git found"
    # else
    #   echo "ATTEMPTING TO CLONE"
    #   git clone "$REPO"
    # fi
  fi
  echo "Pulling from origin"
  git fetch origin

  if [ "$PULL" != "false" ]; then
    echo "Pulling from $REPO"
    echo "Pull - $REPO - $NOW" >>"$DEBUG"
    #Pull from Git
    git reset --hard origin/main
    #Disperse files
    cp -r "$STORE/nvim" "$CNVIM"
    cp "$STORE/.tmux.conf" "$CTMUX"
    cp -r "$STORE/.tmux/plugins" "$PTMUX"
    cp "$STORE/.zshrc" "$CZSH"

  else
    echo "Pushing to $REPO"
    #Concentrate files
    assertDir "$STORE/nvim"
    # cp -r "$CNVIM" "$STORE/nvim"
    rsync -av --exclude=".git" --exclude=".gitignore" "$CNVIM" "$STORE/nvim"
    # if [ -n "$STORE" ]; then rm -rf "$STORE/nvim/.git"; fi
    cp "$CTMUX" "$STORE/.tmux.conf"

    assertDir "$STORE/.tmux"
    assertDir "$STORE/.tmux/plugins"
    # cp -r "$PTMUX" "$STORE/.tmux/plugins"
    rsync -av --exclude=".git" --exclude=".gitignore" "$PTMUX" "$STORE/.tmux/plugins"
    cp "$CZSH" "$STORE/.zshrc"
    #Push to git
    echo "Push - $REPO - $NOW" >>"$DEBUG"
    git add "$STORE/"
    git commit -m "$NOW - Config Update"
    git push -f "$REPO"
  fi
else
  echo "Please specify whether you are pushing or pulling from your repo with a -push or -pull flag"
fi

echo "config installer is done====================================="
