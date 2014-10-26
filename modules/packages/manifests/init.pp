class packages() {

	require homebrew

	include [
		"${name}::homebrew::wget",
	]
	
}
