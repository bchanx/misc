###
### Brian Chan (bchanx.com)
###

###
### V I R T U A L  E N V
###
export BASEPATH=~/bchanx
if [ -e $BASEPATH/venv ]; then
  cd $BASEPATH/venv
  source bin/activate
  cd $BASEPATH

  ###
  ### S E T U P
  ###
  export PATH=$PATH
  export PYTHONSTARTUP=/dev/null
  export GREP_OPTIONS="--color=auto"
  PS1='$ \w\[\e[1;34m\] (bchanx)\[\e[0m\]: '

  ###
  ### A L I A S E S
  ###
  # Python shortcut
  alias py="python"
  # Show login screen
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
  # Always show helpers
  alias ls="ls -F"
  # Trim new lines and copy to clipboard
  alias c="tr -d '\n' | pbcopy"
  # ROT13-encode text
  alias rot13="tr a-zA-Z n-za-mN-ZA-M"
  # Show/hide hidden files in Finder
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

  ###
  ### F U N C T I O N S
  ###
  function min {
    java -jar $BASEPATH/misc/closure-compiler.jar --compilation_level ADVANCED_OPTIMIZATIONS --js $1 --js_output_file $2
  }
  function copyright {
    python $BASEPATH/misc/copyright.py $@
  }
  export -f copyright
fi

