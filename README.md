#### puppet-onetimesecret

[![Build Status](https://github.com/markt-de/puppet-onetimesecret/actions/workflows/ci.yaml/badge.svg)](https://github.com/markt-de/puppet-onetimesecret/actions/workflows/ci.yaml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/markt/onetimesecret.svg)](https://forge.puppetlabs.com/markt/onetimesecret)
[![Puppet Forge](https://img.shields.io/puppetforge/f/markt/onetimesecret.svg)](https://forge.puppetlabs.com/markt/onetimesecret)

1. [Overview](#overview)
1. [Requirements](#requirements)
1. [Usage](#usage)
    - [Basic usage](#basic-usage)
    - [Choosing a version](#choosing-a-version)
    - [Customization](#customization)
    - [Using Hiera](#using-hiera)
1. [Reference](#reference)
1. [Development](#development)
    - [Contributing](#contributing)

## Overview

A puppet module for setting up the [One-Time Secret](https://github.com/onetimesecret/onetimesecret) web application.

## Requirements

Although the One-Time Secret web application is a ready to-use web service, it is highly recommend to run it behind a webserver or reverse proxy. This is emphasized by the fact that it runs on a non-standard port by default. However, setting up a websever or reverse proxy is beyond the scope of this module.

## Usage

### Basic usage

This example will build and install One-Time Secret from source, setup Redis, create a minimal configuration and activate the service for you:

```puppet
    class { 'onetimesecret':
      version        => 'v0.9.2',
      secret         => 'SomeHardToGuessRandomCharacters',
      redis_password => 'AnotherGoodPassword',
    }
```

NOTE: Once the `secret` is set, do not change it (keep a backup offsite).

### Choosing a version

The One-Time Secret project rarely provides new releases. That's why the `$version` parameter supports different values: a release tag (v0.9.2), a branch name (master) or a commit ID (e1156b1f8ab98322a898ee4defd1c3f0adb9b5d3). Have a look at the [One-Time Secret GitHub page](https://github.com/onetimesecret/onetimesecret/) for possible values.

Keep in mind that setting `$version` to a branch name will make it difficult to update One-Time Secret. A commit ID or release tag is highly recommended:

```puppet
    class { 'onetimesecret':
      version        => 'e1156b1f8ab98322a898ee4defd1c3f0adb9b5d3',
      secret         => 'SomeHardToGuessRandomCharacters',
      redis_password => 'AnotherGoodPassword',
    }
```

### Customization

It is easy to add new options or to overwrite some default values in the configuration:

```puppet
class { 'onetimesecret':
  install_dir   => '/data',
  symlink_name  => '/data/onetimesecret',
  options       => {
    site => {
      ssl => true,
    },
    emailer => {
      host => 'smtprelay.example.com',
    },
  },
  redis_options => {
    maxmemory => '2gb',
  },
  secret => 'SomeHardToGuessRandomCharacters',
  redis_password => 'AnotherGoodPassword',
}
```

It is possible to disable certain functionality if you want to manage some aspects on your own:

```puppet
class { 'onetimesecret':
  manage_redis   => false,
  manage_user    => false,
  manage_service => false,
  secret         => 'SomeHardToGuessRandomCharacters',
  redis_password => 'AnotherGoodPassword',
}
```

You may opt to disable the default configuration and configure One-Time Secret from scratch:

```puppet
class { 'onetimesecret':
  use_default_options => false,
  options             => {...}
  secret              => 'SomeHardToGuessRandomCharacters',
  redis_password      => 'AnotherGoodPassword',
}
```

In this case the `$options` parameter must contain ALL required configuration options to run the One-Time Secret web application. Otherwise the service may fail to startup.

### Using Hiera

You're encouraged to define your configuration using Hiera, especially if you plan to disable the default configuration:

```puppet
onetimesecret::use_default_options: false
onetimesecret::options:
  site:
    host: 'localhost:7143'
    domain: %{facts.networking.domain}
    ssl: false
    secret: 'CHANGEME'
  redis:
    uri: '''redis://user:CHANGEME@127.0.0.1:7179/0?timeout=10&thread_safe=false&logging=false'''
    config: $redis_config_file
  emailer:
    mode: ':smtp'
    from: "ots@%{facts.networking.domain}"
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
```

## Reference

Classes and parameters are documented in [REFERENCE.md](REFERENCE.md).

## Development

### Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

Contributions must pass all existing tests, new features should provide additional unit/acceptance tests.
