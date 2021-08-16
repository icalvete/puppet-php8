class php8 (

  $fpm                             = false,
  $amqp                            = false,
  $phalcon                         = false,
  $opcache                         = false,
  $opcache_blacklist               = [''],
  $env                             = pick($::env, $php8::params::env),
  $version                         = $php8::params::version,
  $file_uploads                    = 'Off',
  $file_uploads_size               = $php8::params::file_uploads_size,
  $max_execution_time_cli          = $php8::params::max_execution_time,
  $max_execution_time_fpm          = $php8::params::max_execution_time,
  $memory_limit_cli                = $php8::params::memory_limit,
  $memory_limit_fpm                = $php8::params::memory_limit,
  $max_requests_fpm                = $php8::params::max_requests_fpm,
  $memcached_compression_threshold = $php8::params::memcached_compression_threshold

) inherits php8::params {


  anchor {'php8::begin':
    before => Class['php8::install']
  }

  class {'php8::common':
    require => Anchor['php8::begin']
  }

  class {'php8::install':
    require => Class['php8::common']
  }

  class {'php8::config':
    require => Class['php8::install']
  }

  if $fpm {
      class {'php8::php8_fpm':
        max_requests_fpm => $max_requests_fpm,
        require          => Class['php8::config']
      }
  }

  anchor {'php8::end':
    require => Class['php8::config']
  }
}
