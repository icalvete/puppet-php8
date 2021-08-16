class php8::install inherits php8::params {

  package { 'libmaxminddb0':
    ensure => present,
    before => Package[$php8::common::php8_package]
  }

  package {$php8::common::php8_package:
    ensure  => present,
    require =>  [
      Apt::Ppa['ppa:ondrej/php'],
      Class['apt::update']]
  }

  class {'php8::php8_cli':
    max_execution_time_cli => $php8::max_execution_time_cli,
    memory_limit_cli       => $php8::memory_limit_cli,
    version                => $php8::version
  }
}
