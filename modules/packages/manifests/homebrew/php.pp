class packages::homebrew::php(
	$config_dir      = undef,
	$config_file     = undef,
	$fpm_config_file = undef,
	$data_dir        = undef,
	$executable      = undef,
	$fpm_executable  = undef,
	$log_dir         = undef,
	$log_file        = undef,
	$fpm_log_file    = undef,
	$fpm_pid_file    = undef,
) {

	require homebrew

	$taps = [
		'homebrew/dupes',
		'homebrew/php',
	]
	homebrew::tap { $taps:
		ensure => 'present',
	}

	homebrew::package { 'php55':
		ensure  => 'present',
		options => '--without-apache --with-fpm',
		require => Homebrew::Tap[$taps],
		notify  => Service['dev.php-fpm'],
	}

	file { [$config_dir, $data_dir, $log_dir]:
		ensure => directory,
		notify => Service['dev.php-fpm'],
	}

	file { $config_file:
		content => template('packages/homebrew/php/php.ini.erb'),
		require => File[$config_dir],
		notify  => Service['dev.php-fpm'],
	}

	file { "${homebrew::config::install_dir}/etc/php/5.5/php.ini":
		ensure  => 'link',
		mode    => '0644',
		target  => $config_file,
		require => [File[$config_file], Homebrew::Package['php55']],
	}

	file { $fpm_config_file:
		content => template('packages/homebrew/php/php-fpm.conf.erb'),
		require => File[$config_dir],
		notify  => Service['dev.php-fpm'],
	}

	file { '/Library/LaunchDaemons/dev.php-fpm.plist':
		content => template('packages/homebrew/php/dev.php-fpm.plist.erb'),
		owner   => 'root',
		group   => 'wheel',
		notify  => Service['dev.php-fpm'],
	}

	service { 'dev.php-fpm':
		ensure  => running,
		require => Homebrew::Package['php55'],
	}

}
