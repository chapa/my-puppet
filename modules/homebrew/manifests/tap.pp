define homebrew::tap(
	$ensure = 'present',
) {

	require homebrew

	$environment = [
		"HOME=/Users/chapa",
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

	$splited_name = split($name, '/')
	$user = $splited_name[0]
	$repo = $splited_name[1]

	$brew_bin = "${homebrew::config::install_dir}/bin/brew"

	if $ensure == 'present' {
		exec { "tap ${name} homebrew repository":
			environment => $environment,
			path        => $path,
			command => "${brew_bin} tap ${name}",
			unless  => "ls ${homebrew::config::install_dir}/Library/Taps/${user}/${user}-${repo}",
		}
	} else {
		exec { "untap ${name} homebrew repository":
			environment => $environment,
			path        => $path,
			command => "${brew_bin} remove ${option} ${name}",
			onlyif  => "ls ${homebrew::config::install_dir}/Library/Taps/${user}/${user}-${repo}",
		}
	}

}
