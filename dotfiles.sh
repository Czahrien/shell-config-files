#!/bin/zsh
# This script should be run once manually then can be sourced in your zshrc files
# $ . dotfiles.sh
# $ source dotfiles.sh

BASENAME=$(basename ${0})
DRY_RUN=${DRY_RUN-}
DEST_PREFIX=${DEST_PREFIX-~}

# we only really care about this stuff if we have an interactive terminal
if [[ -o interactive ]]; then
    BASEDIR=$(readlink -f $(dirname ${0}))

  # pull the latest copy of the files if this is a login shell
  #if shopt -q login_shell; then
  if [[ -o login ]]; then
      pushd $BASEDIR
      $DRY_RUN git pull origin main
      popd
  fi

# make links to resource files
    pushd $BASEDIR/dotfiles/
    PREFIX=_
    SLASH_PATTERN=__
    FILES=( ./${PREFIX}* )
    for file in "${FILES[@]}"; do
        FILE_DEST=${DEST_PREFIX}/${file#*/${PREFIX}}
        FILE_DEST=${FILE_DEST//__/\/}
        if [[ ! -e ${FILE_DEST} ]]; then
            DIRNAME=$(dirname $FILE_DEST)
            echo $DIRNAME
            $DRY_RUN mkdir -p $DIRNAME
            echo "[${BASENAME}]  Creating symbolic link ${FILE_DEST} --> ${file}"
            $DRY_RUN ln -s $file ${FILE_DEST}
        fi
    done
    popd
fi
