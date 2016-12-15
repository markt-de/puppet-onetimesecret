# == Class onetimesecret::params
#
# This class is meant to be called from onetimesecret.
# It sets variables according to platform.
#
class onetimesecret::params {
  # global module parameters
  $use_default_options        = true
  $manage_config              = true
  $manage_cron                = true
  $manage_package             = true
  $manage_additional_packages = true
  $manage_user                = true
  $manage_symlink             = true
  $options                    = {}
  $package_name               = "${module_name}"

  # service parameters
  $manage_service             = true
  $manage_service_file        = true
  $service_name               = "${module_name}"
  $service_enable             = true
  $service_ensure             = 'running'
  $service_provider           = 'init'

  $config_mode                = '0640'
  $config_template            = "${module_name}/config.erb"
  $log_dir                    = '/var/log/onetime'
  $log_file                   = "${log_dir}/ots.log"
  $pid_dir                    = '/var/run/onetime'
  $pid_file                   = "${pid_dir}/ots.pid"

  $redis_config_template      = "${module_name}/redis.conf.erb"
  $redis_log_file             = "${log_dir}/redis.log"
  $redis_pid_file             = "${pid_dir}/redis.pid"

  # OS configuration
  case $::kernel {
    'FreeBSD', 'OpenBSD': {
      $install_dir  = '/usr/local'
      $config_dir   = '/usr/local/etc/onetime'
      $data_dir     = '/usr/local/etc/onetime/data'
      $root_group   = 'wheel'
      # TODO
      $additional_packages = [ ]
      $bundle_exec  = '/usr/local/bin/bundle'
      $redis_exec   = '/usr/local/bin/redis-server'
    }
    'Linux': {
      $install_dir  = '/opt'
      $config_dir   = '/etc/onetime'
      $data_dir     = '/etc/onetime/data'
      $root_group   = 'root'
      $additional_packages = [ 'redis-server', 'build-essential', 'libyaml-dev',
        'libevent-dev', 'zlib1g', 'zlib1g-dev', 'openssl', 'libssl-dev',
        'libxml2', 'ruby1.9.1', 'ruby1.9.1-dev', 'bundler' ]
      $bundle_exec  = '/usr/bin/bundle'
      $redis_exec   = '/usr/bin/redis-server'
    }
    default: {
      fail("\"${module_name}\" provides no config directory default value
           for \"${::kernel}\"")
    }
  }

  # One-time Secret configuration
  $config_file        = "${config_dir}/config"
  $redis_config_file  = "${config_dir}/redis.conf"
  $download_url       = 'https://github.com/onetimesecret/onetimesecret/archive'
  $version            = '0.9.2'
  $group              = 'ots'
  $user               = 'ots'
  $symlink_name       = "${install_dir}/${module_name}"
  $http_port          = 7143

  # One-time Secret default configuration
  $default_options = {
    'site' => {
      'host' => 'localhost:7143',
      'domain' => $::domain,
      'ssl' => 'false',
      'secret' => 'CHANGEME',
    },
    'redis' => {
      'uri' => '\'redis://user:CHANGEME@127.0.0.1:7179/0?timeout=10&thread_safe=false&logging=false\'',
      'config' => $redis_config_file,
    },
    'emailer' => {
      'mode' => ':smtp',
      'from' => "ots@${::domain}",
      'host' => 'localhost',
      'port' => '25',
    },
    'incoming' => {
      'enabled' => 'false',
      'email' => 'example@onetimesecret.com',
      'passphrase' => 'CHANGEME',
      'regex' => '\A[a-zA-Z0-9]{6}\z',
    },
    'locales' => [ 'en', 'es', 'de', 'nl', 'ru' ],
    'unsupported_locales' => [ 'fr', 'pt', 'jp', 'pt' ],
    'stathat' => {
      'enabled' => 'false',
      'apikey' => 'CHANGEME',
      'default_chart' => 'CHANGEME',
    },
    'text' => {
      'nonpaid_recipient_text' => '\'You need to create an account!\'',
      'paid_recipient_text' => '\'Send the secret link via email\'',
    },
    'limits' => {
      'create_secret' => '250',
      'create_account' => '10',
      'update_account' => '10',
      'email_recipient' => '50',
      'send_feedback' => '10',
      'authenticate_session' => '5',
      'homepage' => '500',
      'dashboard' => '1000',
      'failed_passphrase' => '5',
      'show_metadata' => '1000',
      'show_secret' => '1000',
      'burn_secret' => '1000',
    },
  }
  $redis_default_options = {
    'pidfile' => $pid_file,
    'logfile' => $redis_log_file,
    'dir' => $data_dir,
    'dbfilename' => 'default.rdb',
    'appendfilename' => 'default.aof',
    'requirepass' => 'CHANGEME',
    'bind' => '127.0.0.1',
    'port' => '7179',
    'databases' => '16',
    'timeout' => '30',
    'daemonize' => 'yes',
    'loglevel' => 'notice',
    'save' => '157680000 1',
    'rdbcompression' => 'yes',
    'appendonly' => 'yes',
    'appendfsync' => 'everysec',
  }
}
