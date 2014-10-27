class packages() {

	require homebrew

	include [
		"${name}::homebrew::dnsmasq",
		"${name}::homebrew::git",
		"${name}::homebrew::nginx",
		"${name}::homebrew::wget",
	]
	
}
