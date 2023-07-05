#!/bin/zsh

BASENAME=$(basename ${0})
BASEDIR=$(readlink -f $(dirname ${0}))
DRY_RUN=${DRY_RUN-}
DEST_PREFIX=${DEST_PREFIX-~}
PLATFORM_PREFIX=$(uname -s -m | tr ' ' '-')
PLATFORM_PREFIX=${PLATFORM_PREFIX:l}

check_git() {
  # pull the latest copy of the files if this is a login shell
  if [[ ! -o login ]]; then
    return
  fi

  pushd $BASEDIR
  $DRY_RUN git pull origin main
  popd
}

symlink_dotfiles() {
# make links to resource files
  pushd $BASEDIR/dotfiles/
  PREFIX=_
  SLASH_PATTERN=__
  FILES=( ./${PREFIX}* )
  for file in "${FILES[@]}"; do
    FILE_DEST=${DEST_PREFIX}/${file#*/${PREFIX}}
    FILE_DEST=${FILE_DEST//__/\/}
    if [[ -e ${FILE_DEST} ]]; then
      continue
    fi

    DIRNAME=$(dirname $FILE_DEST)
    $DRY_RUN mkdir -p $DIRNAME
    echo "[${BASENAME}]  Creating symbolic link ${FILE_DEST} --> ${file}"
    $DRY_RUN ln -s ${BASEDIR}/dotfiles/$file ${FILE_DEST}
  done
  popd
}

main() {
  # we only really care about this stuff if we have an interactive terminal
  #if [[ ! -o interactive ]]; then
  #  return
  #fi

  check_git
  symlink_dotfiles
  
  PLATFORM_LINK=${DEST_PREFIX}/.zshrc-platform.d
  PLATFORM_DIR=${BASEDIR}/dotfiles/${PLATFORM_PREFIX}
  if [[ ! -e ${PLATFORM_LINK} ]]; then
    echo "Linking ${PLATFORM_LINK} -> ${PLATFORM_DIR}"
    mkdir -p ${PLATFORM_DIR}
    ln -s ${PLATFORM_DIR} -T ${PLATFORM_LINK}
  fi
}

main
