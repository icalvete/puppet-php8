class php8::php8_fpm (

  $max_requests_fpm = 512

)inherits php8::params {

  anchor {'php8::php8_fpm::begin':
    before => Class['php8::php8_fpm::install']
  }

  class {'php8::php8_fpm::install':
    require => Anchor['php8::php8_fpm::begin']
  }

  class {'php8::php8_fpm::config':
    require => Class['php8::php8_fpm::install'],
  }

  class {'php8::php8_fpm::common_post_install':
    require => Class['php8::php8_fpm::config']
  }

  class {'php8::php8_fpm::service':
    subscribe => Class['php8::php8_fpm::common_post_install']
  }

  anchor {'php8::php8_fpm::end':
    require => Class['php8::php8_fpm::service']
  }
}
