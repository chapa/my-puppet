Exec {
	user      => 'chapa',
	group     => 'staff',
	logoutput => on_failure,
	timeout   => 0,

	path => [
		'/usr/local/bin',
		'/usr/bin',
		'/bin',
		'/usr/sbin',
		'/sbin',
	],
}

File {
	owner   => 'chapa',
	group   => 'staff',
	ensure  => present,
	mode    => '0644',
}

Service {
	ensure => 'running',
	enable => true,
}

node default {

	include dotfiles
	include packages

}
