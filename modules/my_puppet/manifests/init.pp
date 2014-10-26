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
	
}
