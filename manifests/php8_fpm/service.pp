class php8::php8_fpm::service {

  service { $php8::common::php8_fpm_service:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
