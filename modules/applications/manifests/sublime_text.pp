class applications::sublime_text() {
	
	package { 'Sublime Text':
		provider => 'appdmg',
		source   => 'http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203065.dmg',
	}
	
}
