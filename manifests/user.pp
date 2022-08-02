# @summary Create a user and group for One-Time Secret
# @api private
class onetimesecret::user {
  if $onetimesecret::manage_user {
    group { $onetimesecret::group:
      ensure => present,
      system => true,
      gid    => $onetimesecret::gid,
    }

    user { $onetimesecret::user:
      ensure     => present,
      comment    => 'One-time secret',
      gid        => $onetimesecret::gid,
      home       => $onetimesecret::symlink_name,
      managehome => false,
      shell      => '/bin/false',
      system     => true,
      uid        => $onetimesecret::uid,
    }
  }
}
