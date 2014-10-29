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
		command => "git clone git@github.com:chapa/dotfiles.git ${repo}",
		cwd     => $repo_dir,
		unless  => "ls ${repo}",
		require => File[$repo_dir],
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