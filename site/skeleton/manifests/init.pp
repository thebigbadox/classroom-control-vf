class skeleton{
  file{ '/etc/skel':
    ensure => directory,
   }
  file{ '/etc/skel/.bashrc':
    ensurt => file,
    source => 'puppet:///modules/skeleton/dot_bashrc',
  }
}
