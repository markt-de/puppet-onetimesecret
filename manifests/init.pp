# == Class onetimesecret
#
# Install, configure and run One-Time Secret
#
class onetimesecret (
  # service options
  Boolean $manage_service             = $::onetimesecret::params::manage_service,
  Boolean $manage_service_file        = $::onetimesecret::params::manage_service_file,
  String $pid_dir                     = $::onetimesecret::params::pid_dir,
  String $pid_file                    = $::onetimesecret::params::pid_file,
  String $redis_pid_file              = $::onetimesecret::params::redis_pid_file,
  String $service_ensure              = $::onetimesecret::params::service_ensure,
  String $service_name                = $::onetimesecret::params::service_name,
  String $service_provider            = $::onetimesecret::params::service_provider,
  # installation options
  Boolean $manage_package             = $::onetimesecret::params::manage_package,
  Boolean $manage_additional_packages = $::onetimesecret::params::manage_additional_packages,
  String $package_name                = $::onetimesecret::params::package_name,
  Array $additional_packages          = $::onetimesecret::params::additional_packages,
  String $version                     = $::onetimesecret::params::version,
  String $download_url                = $::onetimesecret::params::download_url,
  String $install_dir                 = $::onetimesecret::params::install_dir,
  String $symlink_name                = $::onetimesecret::params::symlink_name,
  Boolean $manage_symlink             = $::onetimesecret::params::manage_symlink,
  # user options
  Boolean $manage_user                = $::onetimesecret::params::manage_user,
  String $root_group                  = $::onetimesecret::params::root_group,
  $gid                                = undef,
  String $group                       = $::onetimesecret::params::group,
  $uid                                = undef,
  String $user                        = $::onetimesecret::params::user,
  String $bundle_exec                 = $::onetimesecret::params::bundle_exec,
  String $redis_exec                  = $::onetimesecret::params::redis_exec,
  # OTS configuration
  String $host                        = $::fqdn,
  String $domain                      = $::domain,
  Boolean $manage_config              = $::onetimesecret::params::manage_config,
  String $config_dir                  = $::onetimesecret::params::config_dir,
  String $config_file                 = $::onetimesecret::params::config_file,
  String $redis_config_file           = $::onetimesecret::params::redis_config_file,
  Boolean $use_default_options        = $::onetimesecret::params::use_default_options,
  Hash $default_options               = $::onetimesecret::params::default_options,
  Hash $redis_default_options         = $::onetimesecret::params::redis_default_options,
  Hash $options                       = {},
  Hash $redis_options                 = {},
  Integer $http_port                  = $::onetimesecret::params::http_port,
  String $data_dir                    = $::onetimesecret::params::data_dir,
  String $log_dir                     = $::onetimesecret::params::log_dir,
  String $log_file                    = $::onetimesecret::params::log_file,
  String $secret                      = 'UNSET',
  String $redis_password              = 'UNSET',
) inherits onetimesecret::params {

  include ::stdlib

  # Do not permit insecure installations.
  if $secret == 'UNSET' {
    fail("${::hostname}: Module \"${module_name}\" requires that you change the default value of \"\$secret\"")
  }
  if $redis_password == 'UNSET' {
    fail("${::hostname}: Module \"${module_name}\" requires that you change the default value of \"\$redis_password\"")
  }

  contain ::onetimesecret::user
  contain ::onetimesecret::install
  contain ::onetimesecret::config
  contain ::onetimesecret::service
  Class['::onetimesecret::user'] -> Class['::onetimesecret::install'] -> Class['::onetimesecret::config']
  ~> Class['::onetimesecret::service']

}
