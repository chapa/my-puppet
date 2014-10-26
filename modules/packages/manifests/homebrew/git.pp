class packages::homebrew::git() {

	include my_puppet
	require homebrew

	homebrew::package{ 'git':
		ensure => 'present',
	}

	file { "${my_puppet::config::install_dir}/env.d/git.sh":
		ensure  => 'present',
		mode    => '0644',
		content => template('packages/homebrew/git/env.sh.erb'),
		require => File['env.d folder'],
		notify  => Exec['need to source env.sh'],
	}

}