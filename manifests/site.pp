# Globally disabling virtual package
Package {  allow_virtual => false, }

node /linux1.com/ {
  include nginx
  include nginx::goappweb
  include goapp
}

node /web1.com/ {
  include nginx
  include nginx::goappweb
}

node /app1.com/ {
  include goapp
}

node /app2.com/ {
  include goapp
}
