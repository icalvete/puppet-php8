class php8::php8_cli::config {

  Augeas {
    require => Package[$php8::common::common_package]
  }

  augeas{'include_path_cli' :
    context => "/files${php8::common::php8_cli_phpini}/PHP",
    changes => "set include_path .:${php8::common::php8_includepath}:${php8::common::php8_includepath}/8.${php8::common::version}/cli",
  }

  augeas{'cli_security' :
    context => "/files/${php8::common::common_phpini}/PHP",
    changes => [
      'set expose_php Off',
      'set file_uploads Off',
    ]
  }

  augeas{'cli_performance' :
    context => "/files/${php8::common::php8_cli_phpini}/PHP",
    changes => [
      "set max_execution_time ${php8::php8_cli::max_execution_time_cli}",
      'set max_input_time 15',
      "set date.timezone ${php8::params::timezone}",
    ]
  }

  augeas{'cli_memory_limit' :
    context => "/files/${php8::common::php8_cli_phpini}/PHP",
    changes => [
      "set memory_limit ${php8::php8_cli::memory_limit_cli}",
    ]
  }

  augeas{'cli_debug' :
    context => "/files/${php8::common::php8_cli_phpini}/PHP",
    changes => [
      'set error_log syslog',
      'set auto_prepend_file cli_log.php',
    ]
  }

  if $php8::common::env == 'DEV' {
    augeas{'display_errors_cli':
      context => "/files/${php8::common::php8_cli_phpini}/PHP",
      changes => 'set display_errors On',
    }
  }
}
