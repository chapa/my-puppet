class packages::homebrew::git() {

	include my_puppet
	require homebrew

	homebrew::package{ 'git':
		ensure => 'present',
	}

	my_puppet::env_script{ 'git':
		content => template('packages/homebrew/git/env.sh.erb'),
	}

}