export JAVA_HOME="/usr/lib/jvm/java-8-oracle/"
PATH="$JAVA_HOME/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# mahout
export MAHOUT_HOME=/home/cyniphile/sumzero/mahout_test/mahout/
export MAHOUT_LOCAL=true # for running standalone on your dev machine, 
# unset MAHOUT_LOCAL for running on a cluster

source ~/.bashrc

# OPAM configuration
. /home/cyniphile/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
