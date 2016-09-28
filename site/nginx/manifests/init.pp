class nginx {
  case $::osfamily {
  'redhat','debian' : {
    $package = 'nginx'
    $owner = 'root'
    $group = 'root'
    $docroot = '/var/www'
    $confdir = '/etc/nginx'
    $logdir = '/var/log/nginx'
  }
  'windows' : {
    $package = 'nginx-service'
    $owner = 'Administrator'
    $group = 'Administrators'
    $docroot = 'C:/ProgramData/nginx/html'
    $confdir = 'C:/ProgramData/nginx'
    $logdir = 'C:/ProgramData/nginx/logs'
  }
  default : {
    fail("Module ${module_name} is not supported on ${::osfamily}")
  }
  }
  # user the service will run as. Used in the nginx.conf.epp template
  $user = $::osfamily ? {
    'redhat' => 'nginx',
    'debian' => 'www-data',
    'windows' => 'nobody',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  package { 'nginx':
    ensure => present,
  }

  file { '/var/www':
    ensure  => directory,
    require => Package['nginx'],
  }

  file { '/var/www/index.html':
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
  }

  file { '/etc/nginx/conf.d/default.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    subscribe => File['/etc/nginx/conf.d/default.conf', '/etc/nginx/nginx.conf'],
  }
}
