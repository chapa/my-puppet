class docker(
) inherits docker::config {

	require homebrew

	homebrew::package{ [
		'boot2docker',
		'docker',
	]:
		ensure => 'present',
	}

	my_puppet::env_script { 'docker':
		content => template('docker/env.sh.erb'),
		require => Homebrew::Package['docker'],
	}

	exec { "${boot2docker_executable} init":
		unless => "${boot2docker_executable} status",
		environment => [
			"HOME=/Users/chapa",
		],
	}

	exec { "${boot2docker_executable} start":
		environment => [
			"HOME=/Users/chapa",
		],
		require => Exec["${boot2docker_executable} init"],
		unless  => "${boot2docker_executable} status | grep running",
	}

	$get_exports_cmd = "${boot2docker_executable} shellinit | grep export | sort"
	exec { "${get_exports_cmd} > ${my_puppet::config::install_dir}/env.d/boot2docker.sh":
		environment => [
			"HOME=/Users/chapa",
		],
		unless  => "${get_exports_cmd} | diff -w env.d/boot2docker.sh -",
		require => Exec["${boot2docker_executable} start"],
		notify  => Exec['need to source env.sh'],
	}

}
