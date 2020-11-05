# @summary Setup the One-Time Secret web application
#
# @param config_dir
#   Path to the directory containing the One-Time Secret configuration files.
#
# @param config_file
#   The main One-Time Secret configuration file (absolute path required).
#
# @param data_dir
#   Path to the directory containing the persistent One-Time Secret data.
#
# @param domain
#   The domain name that is used by One-Time Secret.
#
# @param group
#   Specifies the group under which the One-Time Secret service will run.
#
# @param http_port
#   The HTTP port of the One-Time Secrets web server. Note that this defaults
#   to a non-standard port because you are expected to use a reverse proxy in
#   front of the One-Time Secret web application.
#
# @param host
#   The hostname that is used when One-Time Secret generates URLs (web/mail).
#   Usually the FQDN which is served by a reverse proxy.
#
# @param install_dir
#   Base directory for the installation. A sub-directory for every version will
#   automatically be created. Old versions will not be removed.
#
# @param log_dir
#   Directory for One-Time Secret log files.
#
# @param log_file
#   The main One-Time Secret log file (absolute path required).
#
# @param manage_additional_packages
#   Set to `false` to disable the installation of dependencies which are
#   required to build and run One-Time Secret.
#
# @param manage_config
#   Set to `false` to disable managing of the One-Time Secret configuration
#   files.
#
# @param manage_service
#   Set to `false` to disable service management.
#
# @param manage_symlink
#   Set to `false` to disable the creation/update of a symlink to the current
#   version. Note that the symlink is required when using the default
#   configuration.
#
# @param manage_user
#   Set to `false` to disable the creation of a user and group for One-Time Secret.
#
# @param options
#   Specifies a hash containing options to either overwrite some default values
#   or to configure One-Time Secret from scratch. Will be merged with the
#   `$default_options` hash (as long as `$use_default_options` is set to `true`).
#
# @param pid_dir
#   Specifies the directory for the One-Time Secret PID file.
#
# @param pid_file
#   The PID file for the main One-Time Secret web service (absolute path required).
#
# @param redis_password
#   A password for connections to the Redis server. It will also be used when
#   setting up a new Redis instance for One-Time Secret.
#
# @param redis_options
#   Specifies a hash containing options to overwrite some default values
#   for the Redis service (as long as `$manage_redis` is set to `true`).
#
# @param secret
#   A global secret is included in the encryption key so it needs to be
#   long and secure. NOTE: Once the `secret` is set, do not change it
#   (keep a backup offsite).
#
# @param service_enable
#   Specifies whether the service should be enabled.
#
# @param service_ensure
#   Specifies the desired state for the service.
#
# @param service_provider
#   Specifies the service provider. Must be compatible with the operating system.
#
# @param symlink_name
#   Controls the name of a version-independent symlink. It will always point
#   to the release specified by `$version`.
#
# @param use_default_options
#   Set to `false` to completely disable loading of the default configuration.
#   In this case you are required to provide a fully working configuration.
#
# @param user
#   Specifies the user under which the One-Time Secret service will run.
#
# @param version
#   The version of One-Time Secret thats should be installed. Supports
#   several different values: a release tag (v0.9.2), a branch name (master)
#   or a commit ID. Have a look at the One-Time Secret GitHub page for
#   possible values.
#
class onetimesecret (
  Array $additional_packages,
  String $bundle_exec,
  String $config_dir,
  String $config_file,
  String $config_mode,
  String $config_template,
  String $data_dir,
  Hash $default_options,
  String $domain,
  String $download_url,
  String $group,
  String $host,
  Integer $http_port,
  String $install_dir,
  String $log_dir,
  String $log_file,
  Boolean $manage_additional_packages,
  Boolean $manage_config,
  Boolean $manage_redis,
  Boolean $manage_service,
  Boolean $manage_symlink,
  Boolean $manage_user,
  Hash $options,
  String $path,
  String $pid_dir,
  String $pid_file,
  Hash $redis_options,
  String $redis_password,
  String $secret,
  Boolean $service_enable,
  String $service_ensure,
  Stdlib::Compat::Absolute_path $service_file,
  String $service_name,
  String $service_provider,
  String $service_template,
  String $symlink_name,
  Boolean $use_default_options,
  String $user,
  String $version,
  Optional[Integer] $gid = undef,
  Optional[Integer] $uid = undef,
) {
  include stdlib

  contain onetimesecret::user
  contain onetimesecret::install
  contain onetimesecret::config
  contain onetimesecret::redis
  contain onetimesecret::service

  Class['onetimesecret::user']
  -> Class['onetimesecret::install']
  -> Class['onetimesecret::config']
  -> Class['onetimesecret::redis']
  ~> Class['onetimesecret::service']
}
