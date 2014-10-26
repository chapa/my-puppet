class my_puppet() inherits my_puppet::config {

	file { 'env.d folder':
		path => "${install_dir}/env.d",
		ensure => directory,
	}

	exec { 'need to source env.sh':
		command     => "touch ${install_dir}/.need_to_source_env_sh",
		refreshonly => true,
	}
	
}
