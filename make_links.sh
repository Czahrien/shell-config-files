#!/usr/bin/env zsh

set -x
BASENAME=$(basename ${0})
BASEDIR=$(readlink -f $(dirname ${0}))
DEST_PREFIX=${DEST_PREFIX-~}

PLATFORM_PREFIX=$(uname -s -m | tr ' ' '-')
PLATFORM_PREFIX=${PLATFORM_PREFIX:l}

HOST_PREFIX="${HOST-}"

# check_git - Check git repository for updates and pull latest copy of code from origin
check_git() {
  pushd $BASEDIR
  if git remote show origin > /dev/null 2>&1; then
    git pull origin main
  fi
  popd
}


make_links() {
  PKG_DIR=${BASEDIR}/dotfiles
  PLATFORM_DIR=${BASEDIR}/platform_dotfiles/${PLATFORM_PREFIX}
  HOST_DIR=${BASEDIR}/host_dotfiles/${HOST_PREFIX}

  mkdir -p ${PLATFORM_DIR}/zsh/
  mkdir -p ${HOST_DIR}/zsh/

  for x in $PKG_DIR $PLATFORM_DIR $HOST_DIR; do
    pushd $x
    stow --dotfiles --verbose --restow --target="${HOME}" * 2>&1
    popd
  done
}

main() {
  #check_git
  make_links
}

main
