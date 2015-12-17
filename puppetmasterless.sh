#!/bin/bash
#PuppetMasterless with hiera very light version
# vmamidela@gmail.com

#set -x 
buildlog="mybuild.log"

############ START:  Initialise  Global Variables
variables() {
puppetversion='3.6.2-1'
puppetdbversion='2.1.0-1'
passengerversion='4.0.45'
rackversion='1.5.2'
puppetdbterminusversion='2.1.0-1.el6'
pryversion='0.9.12.4'
ENVIRONMENT='production'
}
############ END:  Initialise  Global Variables
########## START : Configuring Repos
repos() {
# Below yum will install 1.5 foreman repo
  curl --silent  http://yum.theforeman.org/RPM-GPG-KEY-foreman -o /etc/pki/rpm-gpg/RPM-GPG-KEY-foreman
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-foreman
  yum -y localinstall http://yum.theforeman.org/releases/1.5/el6/x86_64/foreman-release.rpm
  curl --silent http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs -o /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
# Below rpm install puppet labs repo
  rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm
  rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
  rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
  yum -y install centos-release-SCL
  yum -y remove rpmforge-release
  yum clean all
#  yum -y --exclude=puppet* --exclude=facter* --exclude=foreman* update
}
########## END: Configuring Repos ############################################

########## START: Prerequistes Installing
prerequisites_packages() {

# Below packages are needed
  yum -y install gcc-c++ curl-devel openssl-devel zlib-devel apr-devel apr-util-devel libffi-devel patch readline-devel libtool bison httpd mod_ssl httpd-devel libyaml-devel augeas git createrepo.noarch

# Below are needed for rpmbuild environment
  yum -y install rpm-build rpmdevtools readline-devel ncurses-devel gdbm-devel tcl-devel openssl-devel db4-devel byacc libyaml-devel libffi-devel make mailcap
}


puppet_package_install() {
# Below packages installs puppet server and puppetdb 
  yum -y install puppet-server-${puppetversion}.el6 puppetdb-${puppetdbversion}.el6
}


puppet_required_gems() {

  count=`gem content pry | grep "/pry-\$pryversion/" |wc -l`
  echo Count : $count 
  [ $count -eq 0 ] && gem install pry --version $pryversion

  count=`gem list msgpack | awk '{print \$1}' | grep '^msgpack$'|wc -l`
  echo Count : $count 
  [ $count -eq 0 ] &&  gem install msgpack
}

########## END: Prerequistes Installing #######################






########## START: Puppet Configuration #################


puppet_config() {
rm -rf /etc/puppet && cd /etc && git clone https://github.com/vmamidela1/puppetmasterless.git puppet
echo "alias papply='cd /etc/puppet && git pull origin master ; puppet apply /etc/puppet/manifests/site.pp'" >> ~/.bashrc 


cat > /etc/puppet/autosign.conf << END
*.private.com
$(echo `hostname` | sed 's/\([^.]*\)\.\(.*\)/*.\2/')
END

cat > /etc/puppet/puppet.conf << END
[main]
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = \$vardir/ssl
    certname=`hostname`
    server=`hostname`
    pluginsync=true
    environment = $ENVIRONMENT
[agent]
    classfile = \$vardir/classes.txt
    localconfig = \$vardir/localconfig
    configtimeout=240
    filetimeout=60
END

cat > /etc/hiera.yaml << END
---
:backends:
 - yaml
:hierarchy:
 - %{module_name}/manifests/%{module_name}
 - %{module_name}/manifests/%{module_name}-%{environment}
:yaml:
 :datadir: /etc/puppet/modules
END

}
########## END: Puppet Configuration #################



###### START : Sequence Of PuppetMaster Build Exection
variables 
repos 
prerequisites_packages 
puppet_package_install
puppet_config  
###### END: Sequence Of PuppetMaster Build Exection

FINISH=true
