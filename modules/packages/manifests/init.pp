class packages() {

	require homebrew

	include [
		"${name}::homebrew::dnsmasq",
		"${name}::homebrew::git",
		"${name}::homebrew::wget",
	]
	
}
