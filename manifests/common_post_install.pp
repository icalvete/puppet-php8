class php8::common_post_install inherits php8::params {

  if defined('php8::php8_cli') {
    $version = $php8::php8_cli::version
  } else {
    $version = $php8::version
  }

  $update_alternatives = '/usr/bin/update-alternatives'

  exec { "update-alternatives_php8_${version}":
    command => "${update_alternatives} --set php /usr/bin/php8.${version}",
    user    => 'root',
    require => [Class['php8::php8_cli::install'], Package[$php8_cli_package]]
  }

  exec { "update-alternatives_phar8_${version}":
    command => "${update_alternatives} --set phar /usr/bin/phar8.${version}",
    user    => 'root',
    require => [Class['php8::php8_cli::install'], Package[$php8_cli_package]]
  }

  exec { "update-alternatives_phar.phar8_${version}":
    command => "${update_alternatives} --set phar.phar /usr/bin/phar.phar8.${version}",
    user    => 'root',
    require => [Class['php8::php8_cli::install'], Package[$php8_cli_package]]
  }
}
