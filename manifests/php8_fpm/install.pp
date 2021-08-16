class  php8::php8_fpm::install {

  package {"libapache2-mod-php8.${php8::version}":
    ensure => purged,
    before => Package[$php8::common::php8_fpm_package]
  }

  package { $php8::common::php8_fpm_package :
    ensure => present
  }

  file {'fpm_syslog_config':
    ensure  => present,
    path    => "${php8::common::php8_includepath}/fpm_log.php",
    content => template("${module_name}/fpm_log.php.erb"),
    mode    => '0664',
  }
}
