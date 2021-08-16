class php8::modules inherits php8::params {

  if $php8::common::php8_modules {
    php8::module { $php8::common::php8_modules:}
  }

  if $php8::env == 'DEV' {

    package { 'php-xdebug':
      ensure  => present,
      require => Class['apt::update']
    }
  }
}
