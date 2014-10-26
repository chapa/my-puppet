define homebrew::package(
	$ensure = 'present'
) {

	require homebrew

	$environment = [
		"HOMEBREW_ROOT=${homebrew::config::install_dir}",
		"HOMEBREW_CACHE=${homebrew::config::cache_dir}",
		"HOMEBREW_LOGS=${homebrew::config::log_dir}",
		'CFLAGS="-I$HOMEBREW_ROOT/include"',
		'LDFLAGS="-L$HOMEBREW_ROOT/lib"',
	]

	$path = [
		"${homebrew::config::install_dir}/bin",
		'/usr/local/bin',
		'/usr/bin',
		'/bin',
		'/usr/sbin',
		'/sbin',
	]

	$brew_bin = "${homebrew::config::install_dir}/bin/brew"

	if $ensure == 'present' {
		exec { "install ${name} homebrew package":
			environment => $environment,
			path        => $path,
			command => "${brew_bin} install ${name}",
			unless  => "${brew_bin} list | grep ${name}",
		}
	} else {
		exec { "uninstall ${name} homebrew package":
			environment => $environment,
			path        => $path,
			command => "${brew_bin} remove ${name}",
			onlyif  => "${brew_bin} list | grep ${name}",
		}
	}

}