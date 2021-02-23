export GOPATH=$HOME/.go/

# Enable ccache
#PATH+=":/usr/lib/ccache/bin"

PATH+=":/usr/games/bin"
PATH+=":$GOPATH/bin"
PATH+=":$HOME/.cargo/bin"
PATH+=":$HOME/.cabal/bin"
PATH+=":$HOME/.local/bin"
PATH+=":/home/david/Soft/Projects/helper_scripts"

export PATH

LD_LIBRARY_PATH+=":/usr/local/lib"

export LD_LIBRARY_PATH
