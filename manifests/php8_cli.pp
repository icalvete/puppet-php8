class php8::php8_cli (

  $env                    = $php8::params::env,
  $max_execution_time_cli = $php8::params::max_execution_time,
  $memory_limit_cli       = $php8::params::memory_limit,
  $version                = $php8::params::version

) inherits php8::params {

  $php8_cli_package = "php8.${version}-cli"

  $php8_cli_phpini   = "/etc/php/8.${version}/cli/php.ini"
  $php8_cli_phpconf  = "/etc/php/8.${version}/cli/conf.d"
  $php8_includepath  = '/usr/share/php'
  $php8_memcachedini = "/etc/php/8.${version}/mods-available/memcached.ini"

  case $version {
    0: {
      $extension_dir     = '/usr/lib/php/20151012'
    }
    1: {
      $extension_dir     = '/usr/lib/php/20160303'
    }
      2: {
      $extension_dir     = '/usr/lib/php/20180818'
    }
    default: {
    }
  }

  anchor {'php8::php8_cli::begin':
    before => Class['php8::php8_cli::install']
  }

  class {'php8::php8_cli::common':
    require => Anchor['php8::php8_cli::begin']
  }

  class {'php8::php8_cli::install':
    require => [
      Class['php8::php8_cli::common'],
      Class['apt::update']
    ]
  }

  class {'php8::php8_cli::common_post_install':
    require => Class['php8::php8_cli::install']
  }

  class {'php8::php8_cli::config':
    require => Class['php8::php8_cli::common_post_install']
  }

  anchor {'php8::php8_cli::end':
    require => Class['php8::php8_cli::config']
  }
}
