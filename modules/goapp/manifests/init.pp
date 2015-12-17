class goapp {

  $goappversion=hiera(goappversion,false)
  $gobinarydl=hiera(gobinarydl,false)
  $goinstallpath=hiera(goinstallpath,false)
  $gobinaryfile=hiera(gobinaryfile,false)
  $goapprepo=hiera(goapprepo,false)

  anchor{ 'goapp::begin': }~>
    class { 'goapp::install': }~>
    class { 'goapp::config': }~>
    class { 'goapp::services': }~>
  anchor{ 'goapp::end': }


#  exec {'downloadandinstallgoapp':
#    command => "/usr/bin/wget ${gobinarydl} ; /bin/tar -C /usr/local/bin/ -xzf ${gobinaryfile}",
#    cwd => "${goinstallpath}",
#    unless => "/usr/bin/test -f ${gobinaryfile}",
#  }
#  file {'settingpath':
#    path	=> '/root/.bash_profile',
#    ensure	=> present,
#    content	=> template('goapp/bash_profile.erb'),
#  }
#  vcsrepo { '/tmp/goapp':
#    ensure => present,
#    provider => git,
#    source => "${goapprepo}",
#    revision => "${goappversion}",
#    notify => Exec['installgoapp'],
#  }
# exec {'installgoapp':
#    command => "/bin/sh install.sh ",
#    cwd => "/tmp/goapp",
#    refreshonly => true,
#    notify => Service['goapp'],
# } 
# service {'goapp':
#  ensure => running,
#  enable => true,
#  restart => '/etc/init.d/goapp restart',
#  require => Exec['installgoapp'],
# }
}
