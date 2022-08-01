# @summary Setup a Redis instance for use with One-Time Secret
# @api private
class onetimesecret::redis {
  if $onetimesecret::manage_redis == true {
    # Add password to redis options.
    $redis_params = deep_merge($onetimesecret::redis_options,{
        requirepass => $onetimesecret::redis_password
    })

    # Install and configure Redis.
    class { 'redis':
      * => $redis_params,
    }
  }
}
