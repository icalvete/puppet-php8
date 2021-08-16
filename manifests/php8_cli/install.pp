class php8::php8_cli::install {

  package {$php8::php8_cli::php8_cli_package:
    ensure  => present,
    require => Class['apt::update'],
    before  => Class['php8::modules']
  }

  include php8::modules

  file {'cli_syslog_config':
    ensure  => present,
    path    => "${php8::common::php8_includepath}/cli_log.php",
    content => template("${module_name}/cli_log.php.erb"),
    mode    => '0664',
  }
}
