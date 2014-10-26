define my_puppet::env_script(
	$source = undef,
	$content = undef,
) {
	
	if $source == undef and $content == undef {
		fail('One of source or content must not be undef!')
	}

	include my_puppet

	file { "${my_puppet::config::install_dir}/env.d/${name}.sh":
		ensure  => 'present',
		mode    => '0644',
		source  => $source,
		content => $content,
		require => File["${my_puppet::install_dir}/env.d"],
		notify  => Exec['need to source env.sh'],
	}

}