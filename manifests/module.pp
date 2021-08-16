define php8::module (

  $ensure = 'present',

) {

  package {$name:
    ensure  => $ensure,
    require => Class['apt::update']
  }
}
