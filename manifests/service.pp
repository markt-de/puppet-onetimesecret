# @summary Setup the One-Time Secret system service
# @api private
class onetimesecret::service {
  if $onetimesecret::manage_service == true {
    # Install service file.
    file { $onetimesecret::service_file:
      ensure  => file,
      owner   => 'root',
      group   => 0,
      mode    => '0644',
      content => epp($onetimesecret::service_template),
    }

    # Enable service.
    service { $onetimesecret::service_name:
      ensure    => $onetimesecret::service_ensure,
      enable    => $onetimesecret::service_enable,
      subscribe => [
        Class['onetimesecret::install'],
      ],
      require   => [
        File[$onetimesecret::service_file],
      ],
    }
  }
}
