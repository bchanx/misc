####
#### B C H A N X   B A S H R C
####
export PATH=$PATH
export PYTHONSTARTUP=/dev/null
export GREP_OPTIONS='--color=auto'

BASE=~/bchanx
VENV=venv

####
#### V I R T U A L  E N V
####
if [ -e $BASE/$VENV ]
then
  pushd . > /dev/null
  cd $BASE/$VENV
  source bin/activate
  popd > /dev/null
fi
cd $BASE/bchanx


####
#### D A R W I N
####
if [ $(uname) = 'Darwin' ]; then
  if test -d /usr/local/share/npm/bin; then
    export PATH=$PATH:/usr/local/share/npm/bin
  fi
fi


####
#### P R O M P T
#### Place after virtual env so it doesn't get overwritten.
####
PS1='$ \w\[\e[1;34m\] (bchanx)\[\e[0m\]: '


####
#### F U N C T I O N S
####
function sourceIfExists {
  if test -e $1; then
    source $1
  fi
}

####
#### A L I A S E S
####
alias py='python'

function min {
  java -jar $BASE/misc/closure-compiler.jar --compilation_level ADVANCED_OPTIMIZATIONS --js $1 --js_output_file $2
}

function copyright {
  python $BASE/misc/copyright.py $@
}

function bchanxx {
  sourceIfExists ~/.bash_profile
}

