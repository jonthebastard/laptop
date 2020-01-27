##### shell stuff ####################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gitster/gitster"
plugins=(git gitfast)
source $ZSH/oh-my-zsh.sh
source $HOME/.login-functions

for ve in pyenv rbenv ; do eval "$(${ve} init -)" ; done
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
eval "$(hub alias -s)"
export NVM_DIR="$HOME/.nvm"

export PATH="$HOME/.rbenv:$HOME/.pyenv:$HOME/GitHub/18F/identity-devops/bin:/usr/local/sbin:/usr/local/opt/go/libexec/bin:$HOME/.bin:$PATH"

##### ssh ####################
export GITHUB_SSH_KEY="$HOME/.ssh/id_github"
export KITCHEN_EC2_SSH_KEYPAIR_ID='jonathan.pirro:id_rsa'
export KITCHEN_EC2_SSH_KEY="$HOME/.ssh/id_rsa"
export OPENSC_LIB=/usr/local/lib/opensc-pkcs11.so

for key in $(env | grep ".*SSH_KEY=" | sed 's/=.*$//') ; do
  if [ -f $(eval echo \$$key) ] ; then
    while ! ssh-add -L | grep -q $key ; do
      ssh-add -K $(eval echo \$$key)
    done
  fi
done

ssh-add -L | grep -q opensc || pivssh

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

##### login.gov ####################
export AWS_PROFILE=sandbox-admin
export GSA_USERNAME=bleachbyte
export GSA_FULLNAME="Jonathan Pirro"
export GSA_EMAIL=jonathan.pirro@gsa.gov
LOGIN_REVS="jgrevich,sharms,mzia,amitfreeman-gov,pauldoomgov"

alias bb="git checkout stages/${GSA_USERNAME}"
alias bbm="bb & gpom"
alias laptop='bash <(curl -s https://raw.githubusercontent.com/18F/laptop/master/laptop)'

function pbj() {
  local revs="${1}"
  local msg=("${@:2}")
  git pull-request -p -r "${revs}" -m "${msg[@]}" -e
}

function gpr() {
  local revs="${LOGIN_REVS}"
  local msg=("${@}")
  gpb "${msg[@]}"
  pbj "${revs}" "${msg[@]}"
}

function gv() {
  gpsup
  git push --tags
}

function idcb() {
  sed -i '' -E "s/(IdentityCookbooksRef = ).*\'/\1\'${1}\'/" Berksfile
  vbe -bu
}

function poison () {
  [[ -z ${2} ]] || AWS_PROFILE="${2}"
  av -dc aws autoscaling set-instance-health --instance-id ${1} --health-status Unhealthy
  av -dc aws autoscaling describe-auto-scaling-instances --instance-ids ${1}
}

function hbi () {
  if brew cask info ${1} >/dev/null ; then
    brew cask install ${1}
  else
    brew install ${1}
  fi
}
