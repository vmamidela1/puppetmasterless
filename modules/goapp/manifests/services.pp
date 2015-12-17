class goapp::services {

 service {'goapp':
   ensure	=> running,
   enable 	=> true,
   restart 	=> '/etc/init.d/goapp restart',
   require 	=> Exec['installgoapp'],
 }

}
