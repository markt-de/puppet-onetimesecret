# @summary Manage the One-Time Secret configuration
# @api private
class onetimesecret::config {
  # Should we manage the configuration at all?
  if ( $onetimesecret::manage_config == true ) {

    # Replace password in redis URI
    $redis_uri = regsubst($onetimesecret::default_options['redis']['uri'],
      'CHANGEME', $onetimesecret::redis_password)

    # Update web app defaults with real data
    $default_options_override = {
      'site' => {
        'host' => $onetimesecret::host,
        'domain' => $onetimesecret::domain,
        'secret' => $onetimesecret::secret,
      },
      'redis' => {
        'dir' => $onetimesecret::data_dir,
        'uri' => $redis_uri,
      },
    }
    $default_options = deep_merge($onetimesecret::default_options, $default_options_override)

    # Check if defaults should be included
    if ( $onetimesecret::use_default_options == true ) {
      $real_options       = deep_merge($default_options, $onetimesecret::options)
    }
    # do not include defaults
    else {
      $real_options       = $onetimesecret::options
    }

    file { $onetimesecret::config_file:
      ensure  => file,
      mode    => $onetimesecret::config_mode,
      content => epp($onetimesecret::config_template,{
        real_options => $real_options,
      }),
      owner   => $onetimesecret::user,
      group   => $onetimesecret::group,
      notify  => Class['onetimesecret::service'],
      require => Class['onetimesecret::install'],
    }
  }
}
