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
    notify 	=> Exec['installgoapp'],
  }

 exec {'installgoapp':
    command 	=> "/bin/sh install.sh ",
    cwd 	=> "/tmp/goapp",
    refreshonly => true,
    unless	=> "/usr/bin/test -f ${goapp::goinstallpath}/go/bin/goapp",
    notify 	=> Service['goapp'],
 } 

}
