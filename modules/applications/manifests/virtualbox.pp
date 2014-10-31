class applications::virtualbox() {
	
	exec { 'Kill Virtual Box Processes':
		command     => 'pkill "VBoxXPCOMIPCD" || true && pkill "VBoxSVC" || true && pkill "VBoxHeadless" || true',
		refreshonly => true,
	}
	
	package { 'virtualbox':
		provider => 'pkgdmg',
		ensure   => 'installed',
		source   => 'http://download.virtualbox.org/virtualbox/4.3.18/VirtualBox-4.3.18-96516-OSX.dmg',
		require  => Exec['Kill Virtual Box Processes'],
	}
	
}
