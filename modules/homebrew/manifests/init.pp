class homebrew() inherits homebrew::config {

	include my_puppet
	
	exec { 'clone homebrew repository':
		command => 'git clone https://github.com/Homebrew/homebrew.git homebrew',
		cwd     => $my_puppet::config::install_dir,
		unless  => "ls ${homebrew::config::install_dir}",
	}

	file { '/usr/share/man/man1/brew.1':
		owner   => 'root',
		group   => 'wheel',
		ensure  => link,
		mode    => '0644',
		target  => "${homebrew::config::install_dir}/share/man/man1/brew.1",
		require => Exec['clone homebrew repository'],
	}

	file { "${my_puppet::config::install_dir}/env.d/homebrew.sh":
		ensure  => 'present',
		mode    => '0644',
		content => template('homebrew/env.sh.erb'),
		require => File['env.d folder'],
		notify  => Exec['need to source env.sh'],
	}

}
