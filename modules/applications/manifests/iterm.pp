class applications::iterm() {
	
	package { 'iTerm':
		source   => 'https://iterm2.com/downloads/beta/iTerm2-2_0_0_20141022.zip',
		provider => 'compressed_app',
	}
	
}
