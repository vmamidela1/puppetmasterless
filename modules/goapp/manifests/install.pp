class goapp::install {

  exec {'downloadandinstallgoapp':
    command 	=> "/usr/bin/wget ${goapp::gobinarydl} ; /bin/tar -C /usr/local/bin/ -xzf ${goapp::gobinaryfile}",
    cwd 	=> "${goapp::goinstallpath}",
    unless 	=> "/usr/bin/test -f ${goapp::gobinaryfile}",
  }

  file {'settingpath':
    path	=> '/root/.bash_profile',
    ensure	=> present,
    content	=> template('goapp/bash_profile.erb'),
  }

  vcsrepo { '/tmp/goapp':
    ensure 	=> present,
    provider 	=> git,
    source 	=> "${goapp::goapprepo}",
    revision 	=> "${goapp::goappversion}",
    notify 	=> [Exec['deleteoldbinary'],Exec['installgoapp']]
  }

  exec { 'deleteoldbinary':
    command 	=> "/bin/rm -rf ${goapp::goinstallpath}/go/bin/goapp",
    refreshonly => true,
    onlyif	=> "/usr/bin/test -f ${goapp::goinstallpath}/go/bin/goapp",
    notify 	=> Exec['installgoapp'],
  }

  exec {'installgoapp':
    command 	=> "/bin/sh install.sh ",
    cwd 	=> "/tmp/goapp",
    environment	=> ["GOROOT=${goapp::goinstallpath}/go", "GOBIN=${goapp::goinstallpath}/go/bin"],
    refreshonly => true,
    unless	=> "/usr/bin/test -f ${goapp::goinstallpath}/go/bin/goapp",
    notify 	=> Service['goapp'],
    require	=> Exec['deleteoldbinary'],
  } 

}
