[ -z "$MY_PUPPET_HOME" ] && MY_PUPPET_HOME="/opt/my-puppet"
export MY_PUPPET_HOME

if [ -f $MY_PUPPET_HOME/.need_to_source_env_sh ]; then
	rm -f $MY_PUPPET_HOME/.need_to_source_env_sh
fi

for f in $MY_PUPPET_HOME/env.d/*.sh ; do
	if [ -f $f ] ; then
		source $f
	fi
done
