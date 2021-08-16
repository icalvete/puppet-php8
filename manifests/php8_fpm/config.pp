class php8::php8_fpm::config {

  Augeas {
    require => Package[$php8::common::php8_fpm_package]
  }

  augeas{'include_path_fpm' :
    context => "/files/${php8::common::php8_fpm_phpini}/PHP",
    changes => "set include_path .:${php8::common::php8_includepath}:${php8::common::php8_includepath}/8.${php8::common::version}/fpm",
  }

  augeas{'fpm_security' :
    context => "/files/${php8::common::php8_fpm_phpini}/PHP",
    changes => [
      'set expose_php Off',
    ]
  }

  augeas{'fpm_performance' :
    context => "/files/${php8::common::php8_fpm_phpini}/PHP",
    changes => [
      "set max_execution_time ${php8::max_execution_time_fpm}",
      'set max_input_time 15',
      "set date.timezone ${php8::params::timezone}",
    ]
  }

  augeas{'fpm_memory_limit' :
    context => "/files/${php8::common::php8_fpm_phpini}/PHP",
    changes => [
      "set memory_limit ${php8::memory_limit_fpm}",
    ]
  }

  augeas{'fpm_debug' :
    context => "/files/${php8::common::php8_fpm_phpini}/PHP",
    changes => [
      'set error_log syslog',
      'set auto_prepend_file fpm_log.php',
    ]
  }

  augeas{'file_uploads_fpm':
    context => "/files/${php8::common::php8_fpm_phpini}/PHP",
    changes => [
      "set file_uploads ${php8::file_uploads}",
      "set upload_max_filesize ${php8::file_uploads_size}",
      "set post_max_size ${php8::file_uploads_size}",
    ]
  }

  exec{ 'config_www_pool_listen':
    command => "/bin/sed -i -e \"s/listen = .*/listen = 0.0.0.0:9000/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep 'listen = 0.0.0.0:9000' ${php8::common::php8_fpm_www_pool}"
  }

  exec{ 'config_www_pool_listen_allowed_clients':
    command => "/bin/sed -i -e \"s/listen.allowed_clients = .*/listen.allowed_clients = 0.0.0.0:9000/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep 'listen.allowed_clients = 0.0.0.0:9000' ${php8::common::php8_fpm_www_pool}"
  }

  exec{ 'config_www_pool_max_children':
    command => "/bin/sed -i -e \"s/pm.max_children = .*/pm.max_children = 128/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep 'pm.max_children = 128' ${php8::common::php8_fpm_www_pool}"
  }

  exec{ 'config_www_pool_start_servers':
    command => "/bin/sed -i -e \"s/pm.start_servers = .*/;pm.start_servers = 5/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep ';pm.start_servers = 5' ${php8::common::php8_fpm_www_pool}"
  }

  exec{ 'config_www_pool_min_spare_servers':
    command => "/bin/sed -i -e \"s/pm.min_spare_servers = .*/pm.min_spare_servers = 32/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep 'pm.min_spare_servers = 32' ${php8::common::php8_fpm_www_pool}"
  }

  exec{ 'config_www_pool_max_spare_servers':
    command => "/bin/sed -i -e \"s/pm.max_spare_servers = .*/pm.max_spare_servers = 64/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep 'pm.max_spare_servers = 64' ${php8::common::php8_fpm_www_pool}"
  }

  exec{ 'config_fpm_syslog_error_log':
    command => "/bin/sed -i -e \"s/error_log = .*/error_log = syslog/\" ${php8::common::php8_fpm_conf}",
    unless  => "/bin/grep 'error_log = syslog' ${php8::common::php8_fpm_conf}"
  }

  exec{ 'config_fpm_syslog_ident':
    command => "/bin/sed -i -e \"s/;\?syslog.ident = .*/syslog.ident = ::php-fpm::${php8::common::env}::/\" ${php8::common::php8_fpm_conf}",
    unless  => "/bin/grep 'syslog.ident = ::php-fpm::${php8::common::env}::' ${php8::common::php8_fpm_conf}"
  }

  exec{ 'config_fpm_syslog_facility':
    command => "/bin/sed -i -e \"s/;\?syslog.facility = .*/syslog.facility = ${php8::params::syslog_facility}/\" ${php8::common::php8_fpm_conf}",
    unless  => "/bin/grep 'syslog.facility = ${php8::params::syslog_facility}'"
  }

  exec{ 'config_fpm_log_level':
    command => "/bin/sed -i -e \"s/;\?log_level = .*/log_level = ${php8::params::log_level}/\" ${php8::common::php8_fpm_conf}",
    unless  => "/bin/grep 'log_level = ${php8::params::log_level}'"
  }

  exec{ 'config_fpm_max_requests':
    command => "/bin/sed -i -e \"s/;\?pm.max_requests = .*/pm.max_requests = ${php8::php8_fpm::max_requests_fpm}/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep 'pm.max_requests = ${php8::php8_fpm::max_requests_fpm}' ${php8::common::php8_fpm_www_pool}"
  }

    exec{ 'config_fpm_process_idle_timeout':
      command => "/bin/sed -i -e \"s/;\?pm.process_idle_timeout = .*/pm.process_idle_timeout = 16s;/\" ${php8::common::php8_fpm_www_pool}",
      unless  => "/bin/grep 'pm.process_idle_timeout = 16s;' ${php8::common::php8_fpm_www_pool}"
    }

  if $php8::opcache {
    augeas{'opcache_config_fpm':
      context => "/files/${php8::common::php8_fpm_phpini}/PHP",
      changes => [
        "set opcache.enable 1",
        "set opcache.validate_timestamps 0",
        "set opcache.blacklist_filename /etc/php/opcache.blacklist",
      ]
    }

    file {'opcache_config_fpm_blacklist"':
      ensure  => file,
      path    => '/etc/php/opcache.blacklist',
      content => template("${module_name}/opcache.blacklist.erb"),
      mode    => '0644',
    }
  }

  if $php8::common::env == 'DEV' {
    augeas{'display_errors_fpm':
      context => "/files/${php8::common::php8_fpm_phpini}/PHP",
      changes => 'set display_errors On',
    }
  }

  if $php8::common::env == 'DEV' {

    file {'xdebug_config':
      ensure  => file,
      path    => "${php8::common::php8_fpm_phpconf}/20-xdebug.ini",
      content => template("${module_name}/xdebug.ini.erb"),
      mode    => '0644',
    }
  }
}
