# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2020-11-05
This release introduces several breaking changes. Redis is no longer
maintained by this module, as a result, the Redis configuration is not
compatible with older releases. You should migrate your Redis instance
manually to voxpupuli/puppet-redis (dump+restore is recommended).
Afterwards change `$redis_options` to be compatible with your new Redis instance.

### Added
* Use systemd to manage the service on Linux
* Add new parameter `$manage_redis`

### Changed
* Do not set a default value for `$version`
* Use module voxpupuli/puppet-redis to manage Redis
* Redis no longer runs under the same user as One-Time Secret
* Re-add module voxpupuli/puppet-archive to download/extract the distribution archive
* Repurpose `$redis_options` to work with voxpupuli/puppet-redis, add backwards-incompatible options
* Update default values for `$additional_packages`
* Change merge strategy for `$additional_packages` (now set to 'first')
* Convert to PDK 1.18.1
* Convert `params.pp` to module data
* Migrate ERB templates to EPP
* Require Puppet 6
* Update OS support

### Removed
* Remove support for obsolete Linux init script
* Remove parameter `$manage_service_file` (superseded by `$manage_service`)
* Remove parameters `$redis_config_file`, `$redis_config_template`, `$redis_default_options`, `$redis_exec`, `$redis_pid_file`
* Remove parameters `$manage_package` and `$package_name` (no packages available)
* Remove parameter `$root_group` (using GID 0 is sufficient)

## 1.0.2 (unreleased)

### Changed
* Remove undocumented dependency on voxpupuli/puppet-archive (replace with 'unzip' package). Make changes to install.pp to support installation of zip file.
* Change 'ruby1.9.1' and 'ruby1.9.1-dev' for the metapackages that also have installation candidates for Ubuntu 16 & 18. This adds support for Ubuntu 16 & 18.
* Change method of class ordering in init.pp
* Change download URL and version to onetimesecret fork. This was necessary because the Gemfile/Gemfile.lock in the official versions referenced a broken version of the gem 'yajl-ruby'. See https://github.com/onetimesecret/onetimesecret/issues/81
* Manifests linted in various places

### Fixed
* Github download filename no longer gets prefixed with a 'v', so remove associated block from install.pp
* Fix issue with /etc/init.d/onetimesecret startup script, where PIDFILE dir ownership was not set (move lines, correct variable names)
* Fix issue with /etc/init.d/onetimesecret startup script, where variable reference was incorrectly set to $HTTP_PORT (changed to $ONETIME_HTTP_PORT)

## [1.0.1] - 2016-12-19

### Fixed
* Use custom value for  `$data_dir` in redis server.

## 1.0.0 - 2016-12-18
* Initial release

[Unreleased]: https://github.com/fraenki/puppet-onetimesecret/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/fraenki/puppet-onetimesecret/compare/v1.0.1...v2.0.0
[1.0.1]: https://github.com/fraenki/puppet-onetimesecret/compare/v1.0.0...v1.0.1
