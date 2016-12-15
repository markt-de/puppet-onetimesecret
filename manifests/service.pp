# == Class: onetimesecret::service
#
# Service
#
class onetimesecret::service {
  if $::onetimesecret::manage_service_file == true {
    if $::onetimesecret::service_provider == 'init'  {
      file {"/etc/init.d/${::onetimesecret::service_name}":
        ensure  => present,
        content => template("${module_name}/init.${::osfamily}.erb"),
        mode    => '0755',
        before  => Service[$::onetimesecret::service_name],
        notify  => Service[$::onetimesecret::service_name]
      }
    }
  }

  service { $::onetimesecret::service_name:
    ensure     => $::onetimesecret::service_ensure,
    hasstatus  => true,
    hasrestart => true,
#   provider   => $::onetimesecret::service_provider,
    enable     => true,
#   TODO
#   subscribe  => [
#     File["${::onetimesecret::cfg_dir}/myid"], File["${::onetimesecret::cfg_dir}/zoo.cfg"],
#   ]
  }
}
