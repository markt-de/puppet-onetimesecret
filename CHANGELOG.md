# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed
* Convert to PDK 1.18.1
* Convert `params.pp` to module data

### Fixed

## 1.0.2

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

[Unreleased]: https://github.com/fraenki/puppet-onetimesecret/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/fraenki/puppet-onetimesecret/compare/v1.0.0...v1.0.1
