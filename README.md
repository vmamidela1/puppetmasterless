# puppetmasterless
####Table of Contents

1. [Overview](#overview)
2. [Prerequisite - Which needs to be done before](#prerequisite)
3. [Steps to install and configure masterless puppet](#install-and-configure)
4. [Usage](#usage)

##Overview

This is personal repo created to test masterless puppet install procedure.

This document will help to install and configure puppet and hiera using the script puppetmasterless.sh.

##Prerequisite
1) Centos 6.6 64 bit Operating system.
2) Ensure git client is installed.

##Install and Configure
```
 Cloning the git repo 
 - mkdir /tmp/download && cd /tmp/download
 - git clone https://github.com/vmamidela1/puppetmasterless.git
 - cd puppetmasterless 
 - sh puppetmasterless.sh
```
 The puppetmasterless.sh will install and configure puppet and hiera and will also clone https://github.com/vmamidela1/puppetmasterless.git the repo to /etc/puppet folder and does  the final bit of configuration.

NOTE:- This process has been tested to my requirements and not fully tested any of the other scenarios.

##Usage

The puppetmasterless.sh script automatically adds bash alias 'papply' try running it, if doesnt work close the session and open new session for first time and try papply.

OR

puppet apply /etc/puppet/manifests/site.pp

* Puppet folder structure.
- /etc/puppet -> Puppet configuration directory.
- /etc/puppet/manifests -> Puppet main manifest directory.
- /etc/puppet/modules -> puppet modules placed here.
- /etc/puppet/hiera.yaml -> This is hiera hieracy configuration file.
- /etc/puppet/puppet.conf -> puppet configuration file
