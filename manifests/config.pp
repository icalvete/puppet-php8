class php8::config {

  augeas{'memcached_compression_threshold':
    context => "/files/${php8::php8_memcachedini}/PHP",
    changes => [
      "set memcached.compression_threshold ${php8::memcached_compression_threshold}",
    ],
    require =>  [Class['php8::modules'], Package['php-memcached']]
  }

  include  php8::php8_cli::config
}
