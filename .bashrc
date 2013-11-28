###
### Brian Chan (bchanx.com)
###

###
### V I R T U A L  E N V
###
BASE=~/bchanx
if [ -e $BASE/env ]; then
#  pushd . > /dev/null
  cd $BASE/venv
  source bin/activate
#  popd > /dev/null
  cd $BASE

  ###
  ### S E T U P
  ###
  export PATH=$PATH
  export PYTHONSTARTUP=/dev/null
  export GREP_OPTIONS='--color=auto'
  PS1='$ \w\[\e[1;34m\] (bchanx)\[\e[0m\]: '

  ###
  ### A L I A S E S
  ###
  alias py="python"
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

  ###
  ### F U N C T I O N S
  ###
  function min {
    java -jar $BASE/misc/closure-compiler.jar --compilation_level ADVANCED_OPTIMIZATIONS --js $1 --js_output_file $2
  }
  function copyright {
    python $BASE/misc/copyright.py $@
  }
fi

