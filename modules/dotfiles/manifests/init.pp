define dotfile($repo, $home) {

	file { "${home}/.${name}":
		ensure  => link,
		mode    => '0644',
		target  => "${repo}/${name}",
		require => Exec['clone chapa/dotfiles repository'],
	}

}

class dotfiles() {

	$repo_dir = '/Users/chapa/Documents/Provisioning'
	$repo = "${repo_dir}/dotfiles"
	$home = '/Users/chapa'

	file { $repo_dir:
		ensure => 'directory',
	}

	exec { 'clone chapa/dotfiles repository':
		command => "git clone https://github.com/chapa/dotfiles.git ${repo}",
		unless  => "ls ${repo}",
		require => File[$repo_dir],
	}

	exec { "cat ${repo}/.git/config | sed -E 's/url = https?:\\/\\/([a-zA-Z.]+)\\//url = git@\\1:/' > ${repo}/.git/config":
		unless => "cat ${repo}/.git/config | grep 'url = git@'",
		require => Exec['clone chapa/dotfiles repository'],
	}

	dotfile { [
		'profile',
		'bashrc',
		'bash_aliases',
		'gitconfig',
	]:
		repo => $repo,
		home => $home,
	}

}