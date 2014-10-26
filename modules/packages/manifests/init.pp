class packages() {

	require homebrew

	include [
		"${name}::homebrew::git",
		"${name}::homebrew::wget",
	]
	
}
