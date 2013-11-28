#!/bin/bash

###
### S E T U P  S C R I P T
### Brian Chan (bchanx.com)
###

###
### G L O B A L S
###
SOURCE=~/.bashrc
BASE=~/bchanx

###
### L O G G I N G
###
function log {
  echo -e "\033[1;32m--- $@ ---\033[0m"
}
function err {
  echo -e "\033[1;31m--- $@ ---\033[0m"
}

###
### U T I L S
###
function ensureExists {
  if [[ ! -e $1 ]]; then
    touch $1
  fi
}
function sourceIfExists {
  if [[ -e $1 ]]; then
    source $1
  fi
}
function addBash {
  ensureExists ~/.bashrc
  if ! grep -q "$@" ~/.bashrc; then
    echo "$@" >> ~/.bashrc 2>&1
  fi
}
function addPath {
  if [[ ! $(echo $PATH 2>&1) =~ $1 ]]; then
    addBash "export PATH=$1:\$PATH"
  fi
  sourceIfExists $SOURCE
}

###
### S E T U P
###
function setupBashProfile {
  SOURCE=~/.bash_profile
  ensureExists ~/.bash_profile
  if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
    echo "if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi" >> ~/.bash_profile
  fi
  log "[SETUP] .bash_profile"
}
function setupHomebrew {
  BREW_VER=$(brew --version 2>&1)
  if [[ $BREW_VER =~ "command not found" ]]; then
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
  fi
  addPath /usr/local/bin
  BREW_DOC=$(brew doctor 2>&1)
  if [[ ! $BREW_DOC =~ "Your system is ready to brew." ]]; then
    if [[ $BREW_DOC =~ "Your Homebrew is outdated." ]]; then
      brew update  
    else
      err "Run \`brew doctor\` and fix your system before continuing."
      err "If it's a path related issue, consider modifying /etc/paths."
      exit 1
    fi
  fi
  brew install wget
  log "[SETUP] Homebrew $BREW_VER"
}
function setupGit {
  # Git/Xcode/GCC
  GIT_VER=$(git --version 2>&1)
  if [[ ! $GIT_VER =~ "git version" ]]; then
    err "Download and install Xcode, then rerun this script."
    exit 1
  fi
  if [[ ! $(git config --get user.name 2>&1) =~ "bchanx" ]]; then
    git config --global user.name "bchanx"
  fi
  if [[ ! $(git config --get user.email 2>&1) =~ "bchanx@gmail.com" ]]; then
    git config --global user.email bchanx@gmail.com
  fi
  if [[ ! $(git config --get push.default 2>&1) =~ "simple" ]]; then
    git config --global push.default simple
  fi
  log "[SETUP] $GIT_VER"
}
function setupBashrc {
  ensureExists ~/.bashrc
  if ! grep -q "function bchanx" ~/.bashrc; then
    echo "function bchanx {
  if [ -f ~/.bashrc.bchanx ]; then
    source ~/.bashrc.bchanx
  fi
}" >> ~/.bashrc
  fi
  log "[SETUP] .bashrc"
}
function setupPython {
  brew install python
  PY_VER=$(python --version 2>&1)
  if [[ ! $PY_VER =~ "Python 2.7" ]]; then
    err "$PY_VER installed. (requires 2.7.x)"
    exit 1
  fi
  log "[SETUP] $PY_VER"
}
function setupNode {
  # Node & npm
  brew install node
  addPath /usr/local/share/npm/bin
  NPM_VER=$(npm --version 2>&1)
  if [[ $NPM_VER =~ "command not found" ]]; then
    wget -qO- https://npmjs.org/install.sh | sh
  fi
  if [[ $(lessc --version 2>&1) =~ "command not found" ]]; then
    npm install -g less@1.5.1
  fi
  log "[SETUP] Node $NPM_VER"
}
function setupSSH {
  if [[ ! -d ~/.ssh ]]; then
    pushd . > /dev/null
    cd ~
    ssh-keygen
    popd > /dev/null
  fi
  read -p "Make sure you have SSH keys added to Github (press enter to continue)"
}
function setupEnv {
  setupSSH
  if [[ ! -d $BASE ]]; then
    mkdir $BASE;
  fi;
  cd $BASE
  # Github repositories
  GITHUB_REPOS=(bchanx misc slidr logos-in-pure-css)
  for g in ${GITHUB_REPOS[@]}; do
    if [[ ! -d ${g} ]]; then
      git clone git@github.com:bchanx/${g}.git
    fi
  done
  # Symlinks
  ln -fs $BASE/misc/.bashrc ~/.bashrc.bchanx
  ln -fs $BASE/misc/.vimrc ~/.vimrc
  rm -rf ~/.vim
  ln -fs $BASE/misc/.vim/ ~/.vim
  # Closure compiler
  if [[ ! -e $BASE/misc/closure-compiler.jar ]]; then
    mkdir $BASE/misc/closure
    wget http://dl.google.com/closure-compiler/compiler-latest.zip -P $BASE/misc/closure
    unzip $BASE/misc/closure/compiler-latest.zip -d $BASE/misc/closure
    mv $BASE/misc/closure/compiler.jar $BASE/misc/closure-compiler.jar
    rm -rf $BASE/misc/closure
  fi
  log "[SETUP] $BASE"
}
function setupHeroku {
  addPath /usr/local/heroku/bin
  HEROKU_VER=$(heroku --version 2>&1)
  if [[ $HEROKU_VER =~ "command not found" ]]; then
    wget -qO- https://toolbelt.heroku.com/install.sh | sh
  fi
  cd $BASE/bchanx
  if [[ ! $(git remote 2>&1) =~ "heroku" ]]; then
    git remote add heroku git@heroku.com:bchanx.git
  fi
  heroku keys:add
  heroku config --shell > .env
  log "[SETUP] $HEROKU_VER"
}
function setupVirtualenv {
  cd $BASE
  pip install virtualenv
  if [[ ! -d venv ]]; then
    virtualenv venv
  fi
  sourceIfExists $SOURCE
  bchanx
  pip install flask==0.9
  pip install flask-sqlalchemy==0.16
  pip install alembic==0.4.2
  pip install requests
  log "[SETUP] virtualenv"
}

SYSTEM=$(uname)
if [ $SYSTEM = "Darwin" ]; then
  ###
  ### M A C  O S
  ###
  setupBashProfile
  setupHomebrew
  setupGit
  setupBashrc
  setupPython
  setupNode
  setupEnv
  setupHeroku
  setupVirtualenv
elif [ $SYSTEM = "Linux" ]; then
  ###
  ### U B U N T U
  ###
  echo "(TODO): automate this."
  # sudo apt-get install python-pip
  # sudo apt-get install python-virtualenv
  # sudo apt-get install curl
  # sudo apt-get install nodejs
  # wget https://npmjs.org/install.sh
  # sudo sh ./install.sh; rm install.sh
  # sudo npm install -g less@1.5.1
  # cd ~; mkdir bchanx; cd bchanx
  # git clone git@github.com:bchanx/misc.git
  # virtualenv venv
  # vim ~/.bashrc, add "alias bchanx='source ~/bchanx/misc/.bashrc'"
  # source ~/.bashrc; bchanx
  # pip install flask==0.9
  # pip install flask-sqlalchemy==0.16
  # pip install alembic==0.4.2
  # pip install requests
  # git clone git@github.com:bchanx/bchanx.git
  # git clone git@github.com:bchanx/slidr.git
  # git clone git@github.com:bchanx/logos-in-pure-css.git
  # wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
  # cd bchanx
  # git remote add heroku git@heroku.com:bchanx.git
  # heroku keys:add
  # heroku config --shell > .env
  # sudo apt-get install python-dev
  # sudo apt-get install libpq-dev
  # pip install psycopg2
  # sudo apt-get install openjdk-7-jre-headless
  # bchanx; cd misc; wget http://dl.google.com/closure-compiler/compiler-latest.zip; unzip compiler-latest.zip
  # mv compiler.jar closure-compiler.jar; rm compiler-latest.zip; rm COPYING; rm README
fi

