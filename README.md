#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Usage](#usage)
    * [Beginning with onetimesecret](#beginning-with-onetimesecret)
    * [Using Hiera](#using-hiera)
4. [Reference](#reference)
    * [Syntax](#syntax)
    * [Parameters](#parameters)
5. [Limitations](#limitations)
    * [OS Compatibility](#os-compatibility)
    * [Template Issues](#template-issues)
6. [Development](#development)
7. [Contributors](#contributors)

## Overview

This is a puppet module for setting up the One-Time Secret web application.
It allows for very flexible configuration and is hiera-friendly.

## Requirements

* Puppet 4.x
* [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
* A Reverse-Proxy configuration (as frontend for One-Time Secret)

## Usage

### Beginning with onetimesecret

This example will install packages, setup a minimal configuration and activate the service for you:

    class { 'onetimesecret':
      secret         => 'SomeHardToGuessRandomCharacters',
      redis_password => 'AnotherGoodPassword',
    }

NOTE: Once the `secret` is set, do not change it (keep a backup offsite).

Specifying a different version and install directory is easy:

    class { 'onetimesecret':
      version        => '0.9.2',
      install_dir    => '/data',
      symlink_name   => '/data/onetimesecret',
      secret         => 'SomeHardToGuessRandomCharacters',
      redis_password => 'AnotherGoodPassword',
    }

It is easy to add new options or overwrite some default values in the configuration:

    class { 'onetimesecret':
      options => {
        'site' => {
          'ssl' => true,
        },
        'emailer' => {
          'host' => 'smtprelay.example.com',
        },
      },
      redis_options => {
        'bind' => '10.11.12.13',
      },
      secret => 'SomeHardToGuessRandomCharacters',
      redis_password => 'AnotherGoodPassword',
    }

NOTE: The module will automatically convert the hashes to the proper configuration file formats.

The module allows you to disable certain functionality if you want to manage some aspects on your own:

    class { 'onetimesecret':
      manage_user         => false,
      manage_service_file => false,
      secret              => 'SomeHardToGuessRandomCharacters',
      redis_password      => 'AnotherGoodPassword',
    }

You may opt to disable the default configuration and do everything from scratch:

    class { 'onetimesecret':
      use_default_options => false,
      options             => {...}
      redis_options       => {...}
      secret              => 'SomeHardToGuessRandomCharacters',
      redis_password      => 'AnotherGoodPassword',
    }

The hashes must contain all options required to run the One-Time Secret web application and the redis server. Otherwise setup may fail or the service will fail to startup.

### Using Hiera

You're encouraged to define your configuration using Hiera, especially if you plan to disable the default configuration:

    onetimesecret::use_default_options: false
    onetimesecret::options:
      site:
        host: 'localhost:7143'
        domain: %{::domain}
        ssl: false
        secret: 'CHANGEME'
      redis:
        uri: '''redis://user:CHANGEME@127.0.0.1:7179/0?timeout=10&thread_safe=false&logging=false'''
        config: $redis_config_file
      emailer:
        mode: ':smtp'
        from: "ots@%{::domain}"
        host: 'localhost'
        port: 25
      incoming:
        enabled: false
        email: 'example@onetimesecret.com'
        passphrase: 'CHANGEME'
        regex: '\A[a-zA-Z0-9]{6}\z'
      locales:
        - 'en'
        - 'es'
        - 'de'
        - 'nl'
        - 'ru'
      unsupported_locales:
        - 'fr'
        - 'pt'
        - 'jp'
        - 'pt'
      stathat:
        enabled: false
        apikey: 'CHANGEME'
        default_chart: 'CHANGEME'
      text:
        nonpaid_recipient_text: '''You need to create an account!'''
        paid_recipient_text: '''Send the secret link via email'''
      limits:
        create_secret: 250
        create_account: 10
        update_account: 10
        email_recipient: 50
        send_feedback: 10
        authenticate_session: 5
        homepage: 500
        dashboard: 1000
        failed_passphrase: 5
        show_metadata: 1000
        show_secret: 1000
        burn_secret: 1000
    onetimesecret::redis_options:
      pidfile: '/var/run/onetime/redis.pid'
      logfile: '/var/log/onetime/redis.log'
      dir: '/etc/onetime/data'
      dbfilename: 'default.rdb'
      appendfilename: 'default.aof'
      requirepass: 'CHANGEME'
      bind: '127.0.0.1'
      port: 7179
      databases: 16
      timeout: 30
      daemonize: 'yes'
      loglevel: 'notice'
      save: '157680000 1'
      rdbcompression: 'yes'
      appendonly: 'yes'
      appendfsync: 'everysec'


## Reference

### Parameters

* `secret`: A global secret is included in the encryption key so it needs to be long and secure. NOTE: Once the `secret` is set, do not change it (keep a backup offsite).
* `redis_password`: A password for connections to the internal redis server.
* `version`: Allows you to specify any version which is available from One-Time Secret's GitHub page. Use 'master' to download the current repository state (will not be updated automatically). Defaults to the most recent version which is known to work with this module.
* `host`: Hostname to be used when One-Time Secret generates URLs (web/mail). Usually the FQDN which is served by the Reverse-Proxy.
* `domain`: Domain to be used by One-Time Secret.
* `http_port`: The HTTP port to be used by One-Time Secrets web server. Note that this defaults to a non-standard port because you are expected to use a Reverse-Proxy in front of the One-Time Secret web app.
* `manage_config`: Set to 'false' to disable managing of the One-Time Secret configuration files.
* `manage_package`: Set to 'false' to disable package management. Defaults to 'true'.
* `manage_additional_packages`: Set to 'false' to disable the installation of dependencies which are required to build and run One-Time Secret. Defaults to 'true'.
* `manage_service`: Set to 'false' to disable service management. Defaults to 'true'.
* `manage_service_file`: Set to 'false' to disable the installation of a (Init) service description. Defaults to 'true'.
* `manage_symlink`: Set to 'false' to disable the creation/update of a symlink to the current version. Note that the symlink is required when using the default configuration. Defaults to 'true'.
* `manage_user`: Seti to 'false' to disable the creation of a user and group for One-Time Secret. Defaults to 'ots'.
* `use_default_options`: Set to 'false' to disable loading of the default configuration. Defaults to 'true'.
* `options`: Specify a hash containing options to either overwrite some default values or to configure One-Time Secret from scratch. Will be merged with `$default_options` hash (as long as `$use_default_options` is not set to 'false').
* `redis_options`: Specify a hash containing options to either overwrite some default values or to configure the required redis server from scratch. Will be merged with `$redis_default_options` hash (as long as `$use_default_options` is not set to 'false').
* `config_dir`: Path to the directory containing the One-Time Secret configuration files.
* `config_file`: The main One-Time Secret configuration file (absolute path required).
* `redis_config_file`: The redis server configuration file (absolute path required).
* `data_dir`: Path to the directory containing the persistent One-Time Secret data.
* `log_dir`: Directory for log files.
* `log_file`: The main One-Time Secret log file (absolute path required).
* `install_dir`: Base directory for the installation. A sub-directory for every version will automatically be created.
* `pid_dir`: Directory for PID files.
* `pid_file`: The PID file for the main One-Time Secret service (absolute path required).
* `redis_pid_file`: The PID file for the redis server (absolute path required).
* `user`: Set the user under which the services will run.
* `group`: Set the group under which the services will run.
* `service_ensure`: Whether a service should be running.
* `service_provider`: The specific backend to use for this service. Useful if you set `$manage_service_file` to 'false' and want to use your own service description.
* `symlink_name`: The name of the symlink which will be used in config files and service description.

## Limitations

### OS Compatibility

This module was tested on Ubuntu/Debian. Please open a new issue if your operating system is not supported yet, and provide information about problems or missing features.

## Development

Please use the github issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.
