define php8::php8_fpm::config_forcetype (
  $forcetypes = undef
) {

  include php8::php8_fpm

  validate_array($forcetypes)

  $forcetypes_4_shell = shell_join($forcetypes)

  exec{ 'config_www_pool_forcetype':
    command => "/bin/sed -i -e \"s/.*security.limit_extensions = .php.*/security.limit_extensions = .php ${forcetypes_4_shell}/\" ${php8::common::php8_fpm_www_pool}",
    unless  => "/bin/grep '\"security.limit_extensions = .php ${forcetypes_4_shell}\"' ${php8::common::php8_fpm_www_pool}"
  }
}
