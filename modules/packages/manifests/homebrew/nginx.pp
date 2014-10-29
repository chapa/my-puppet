class packages::homebrew::nginx(
	$config_dir  = undef,
	$config_file = undef,
	$data_dir    = undef,
	$executable  = undef,
	$log_dir     = undef,
	$log_file    = undef,
	$pid_file    = undef,
	$sites_dir   = undef,
) {

	require homebrew

	homebrew::package{ 'nginx':
		ensure => 'present',
		notify => Service['dev.nginx'],
	}

	file { [$config_dir, $data_dir, $log_dir, $sites_dir]:
		ensure => directory,
		notify => Service['dev.nginx'],
	}

	file { $config_file:
		content => template('packages/homebrew/nginx/nginx.conf.erb'),
		require => File[$config_dir],
		notify  => Service['dev.nginx'],
	}

	file { "${config_dir}/mime.types":
		source => 'puppet:///modules/packages/homebrew/nginx/config/mime.types',
		require => File[$config_dir],
		notify  => Service['dev.nginx'],
	}

	file { "${config_dir}/public":
		ensure  => directory,
		recurse => true,
		require => File[$config_dir],
		source  => 'puppet:///modules/packages/homebrew/nginx/config/public'
	}

	file { '/Library/LaunchDaemons/dev.nginx.plist':
		content => template('packages/homebrew/nginx/dev.nginx.plist.erb'),
		owner   => 'root',
		group   => 'wheel',
		notify  => Service['dev.nginx'],
	}

	service { 'dev.nginx':
		ensure  => running,
		require => Homebrew::Package['nginx'],
	}

}
