class packages::homebrew::dnsmasq(
	$config_dir  = undef,
	$config_file = undef,
	$data_dir    = undef,
	$executable  = undef,
	$log_dir     = undef,
	$log_file    = undef,
) {
	
	require homebrew

	homebrew::package{ 'dnsmasq':
		ensure => 'present',
		notify => Service['dev.dnsmasq'],
	}

	file { [$config_dir, $log_dir, $data_dir]:
		ensure => directory,
		notify => Service['dev.dnsmasq'],
	}

	file { "${config_file}":
		content => template('packages/homebrew/dnsmasq/dnsmasq.conf.erb'),
		require => File[$config_dir],
		notify  => Service['dev.dnsmasq'],
	}

	file { "/Library/LaunchDaemons/dev.dnsmasq.plist":
		content => template('packages/homebrew/dnsmasq/dev.dnsmasq.plist.erb'),
		owner   => 'root',
		group   => 'wheel',
		notify  => Service['dev.dnsmasq'],
	}

	file { '/etc/resolver':
		ensure => directory,
		owner  => 'root',
		group  => 'wheel',
	}

	file { "/etc/resolver/dev":
		content => 'nameserver 127.0.0.1',
		owner   => 'root',
		group   => 'wheel',
		require => File['/etc/resolver'],
		notify  => Service['dev.dnsmasq'],
	}

	service { 'dev.dnsmasq':
		ensure  => running,
		require => Homebrew::Package['dnsmasq'],
	}

}