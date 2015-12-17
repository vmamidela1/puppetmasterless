class nginx::goappweb {

  $appservers=hiera(appservers)

  file { '/etc/nginx/conf.d/backends.conf':
    ensure	=> present,
    content 	=> template('nginx/backends.conf.erb'),
    require	=> Package['nginx'],
    notify	=> Service['nginx'];
  '/etc/nginx/conf.d/goapp-web.conf':
    ensure	=> present,
    content 	=> template('nginx/goapp-web.conf.erb'),
    require	=> Package['nginx'],
    notify	=> Service['nginx'],
  }
  
}
