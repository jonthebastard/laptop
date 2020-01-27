##### shell stuff ####################
if [ ! -f ~/.oh-my-zsh/custom/themes/gitster/gitster.zsh-theme ] ; then
  cd ~/.oh-my-zsh/custom/themes/gitster/
  curl --remote-name https://raw.githubusercontent.com/shashankmehta/dotfiles/blob/master/thesetup/zsh/.oh-my-zsh/custom/themes/gitster.zsh-theme
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gitster/gitster"
plugins=(git gitfast)
source $ZSH/oh-my-zsh.sh

for ve in pyenv rbenv ; do eval "$(${ve} init -)" ; done
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
eval "$(hub alias -s)"
export NVM_DIR="$HOME/.nvm"

export PATH="$HOME/.rbenv:$HOME/.pyenv:/usr/local/sbin:/usr/local/opt/go/libexec/bin:$HOME/.bin:$PATH"

##### ssh ####################
for key in $(find ~/.ssh -name '*.pub') ; do
  if [ -f $key ] ; then
    while ! ssh-add -L | grep -q "$(cat ${key})" ; do
      ssh-add -K $key
    done
  fi
done

##### github ####################
alias gs="git status"
alias gl="run git log --pretty=oneline --no-abbrev-commit -n 10"
alias gpom="run git pull origin master"
alias gom="run git checkout master && gpom"
alias bc="git rev-parse HEAD | tr -d '\n' | pbcopy"

function gid() { cd "${HOME}/GitHub/18F/identity-${1}"; }

function newb() {
  gom
  run git checkout -b "${1}"
}

function gpb() {
  run git add --all
  run git commit -m "$@"
  run git push --set-upstream origin $(git_current_branch)
}

function delb() {
  local branch=$1
  [ -z ${1} ] && branch=$(git_current_branch)
  gom
  run gbd $branch
}

function gmpr() {
  local branch=$1
  [ -z ${1} ] && branch=$(git_current_branch)
  gom
  run git checkout $branch
  run git merge master
  run git checkout master
  run git merge --no-ff $branch
  run git push origin master
  delb $branch
}

export STACKBIT_API_KEY=860e29660f9e8015a450ff52078b836f2b230a977678aab0a767eec4e29b2a4d