class php8::common inherits php8::params {

    if $php8::version {
      $version = $php8::version
    } else {
      $version = $php8::php8_cli::version
    }

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
      $php8_package     = "php8.${version}"
      $php8_cli_package = "php8.${version}-cli"
      $php8_fpm_service = "php8.${version}-fpm"
      $php8_fpm_package = ["php8.${version}-fpm", "php8.${version}-cgi"]

      $php8_cli_phpini   = "/etc/php/8.${version}/cli/php.ini"
      $php8_cli_phpconf  = "/etc/php/8.${version}/cli/conf.d"
      $php8_includepath  = '/usr/share/php'
      $php8_fpm_phpini   = "/etc/php/8.${version}/fpm/php.ini"
      $php8_memcachedini = "/etc/php/8.${version}/mods-available/memcached.ini"
      $php8_fpm_phpconf  = "/etc/php/8.${version}/fpm/conf.d"
      $php8_fpm_conf     = "/etc/php/8.${version}/fpm/php-fpm.conf"
      $php8_fpm_www_pool = "/etc/php/8.${version}/fpm/pool.d/www.conf"

      case $version {
        0: {
          $extension_dir     = '/usr/lib/php/20200930'
          $php8_modules = ["php8.${version}-curl","php8.${version}-mysql", "php8.${version}-mcrypt", "php8.${version}-gd", "php8.${version}-mbstring", "php8.${version}-bcmath", "php8.${version}-xml", "php8.${version}-sqlite3", "php8.${version}-zip", "php8.${version}-gmp", "php8.${version}-bz2",  'php-mongodb', "php8.${version}-memcached", 'php-imagick', 'php-redis']
        }
      }
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }

  include apt
  apt::ppa { 'ppa:ondrej/php': }

  realize Package['augeas-lenses']

  file {'augeas_php8_len':
    ensure  => present,
    path    => '/usr/share/augeas/lenses/dist/php.aug',
    content => template("${module_name}/php.aug.erb"),
    mode    => '0664',
    require => Package['augeas-lenses']
  }

  file {'php8_include_path_dir':
    ensure => directory,
    path   => $php8_includepath,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }
}
