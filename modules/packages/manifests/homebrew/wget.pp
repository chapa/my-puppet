class packages::homebrew::wget() {
	
	require homebrew

	homebrew::package{ 'wget':
		ensure => 'present',
	}

}