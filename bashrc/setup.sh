#!/usr/bin/env bash
set -eu -o pipefail

SETUP_SCRIPT_DIR=$(dirname $(readlink -f $BASH_SOURCE))

git_sh_path="${HOME}/.local/share/git"
mkdir -p ${git_sh_path}
[ ! -f ${git_sh_path}/git-completion.sh ] && curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ${git_sh_path}/git-completion.sh
[ ! -f ${git_sh_path}/git-prompt.sh ] && curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ${git_sh_path}/git-prompt.sh

cat ${SETUP_SCRIPT_DIR}/bashrc.sh > "${HOME}/.bashrc"
