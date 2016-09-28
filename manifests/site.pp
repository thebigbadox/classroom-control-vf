Skip to content
This repository
Search
Pull requests
Issues
Gist
 @thebigbadox
 Watch 1
  Star 0
  Fork 293 spidersddd/classroom-control-vf
forked from puppetlabs-education/classroom-control-vf
 Code  Pull requests 0  Projects 0  Wiki  Pulse  Graphs
Branch: production Find file Copy pathclassroom-control-vf/manifests/site.pp
ddab231  21 hours ago
@spidersddd spidersddd Demo lab site.pp
2 contributors @spidersddd @binford2k
RawBlameHistory     
62 lines (51 sloc)  1.96 KB
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Disable filebucket by default for all File resources:
File { backup => false }

# Randomize enforcement order to help understand relationships
ini_setting { 'random ordering':
  ensure  => present,
  path    => "${settings::confdir}/puppet.conf",
  section => 'agent',
  setting => 'ordering',
  value   => 'title-hash',
}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  notify { "Hello, my name is ${::fqdn}": }
#  file { '/etc/motd':
#    ensure  => file,
#    owner   => 'root',
#    group   => 'root',
#    content => "Puppet class is fun!\n", 
#  }
#  exec { 'motd cowsay':
#    path    => '/usr/local/bin',
#    command => "cowsay 'Welcome to ${::fqdn}!' > /etc/motd",
#    creates => '/etc/motd',
#  }
  include memcached
  include users

}
