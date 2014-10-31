class my_puppet() inherits my_puppet::config {

	file { [
		"${install_dir}/cache",
		"${install_dir}/config",
		"${install_dir}/data",
		"${install_dir}/env.d",
		"${install_dir}/log",
	]:
		ensure => directory,
	}

	exec { 'need to source env.sh':
		command     => "touch ${install_dir}/.need_to_source_env_sh",
		refreshonly => true,
	}

	exec { "cat ${my_puppet::config::install_dir}/.git/config | sed -E 's/url = https?:\\/\\/([a-zA-Z.]+)\\//url = git@\\1:/' > ${my_puppet::config::install_dir}/.git/config":
		unless => "cat ${my_puppet::config::install_dir}/.git/config | grep 'url = git@'",
	}
	
}
