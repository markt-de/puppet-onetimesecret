# Changelog

## 1.0.2
* Remove undocumented dependency on voxpupuli/puppet-archive (replace with 'unzip' package). Make changes to install.pp to support installation of zip file.
* Github download filename no longer gets prefixed with a 'v', so remove associated block from install.pp
* Fix issue with /etc/init.d/onetimesecret startup script, where PIDFILE dir ownership was not set (move lines, correct variable names)
* Fix issue with /etc/init.d/onetimesecret startup script, where variable reference was incorrectly set to $HTTP_PORT (changed to $ONETIME_HTTP_PORT)
* Change 'ruby1.9.1' and 'ruby1.9.1-dev' for the metapackages that also have installation candidates for Ubuntu 16 & 18. This adds support for Ubuntu 16 & 18.
* Change method of class ordering in init.pp
* Change download URL and version to onetimesecret fork. This was necessary because the Gemfile/Gemfile.lock in the official versions referenced a broken version of the gem (yajl-ruby). See https://github.com/onetimesecret/onetimesecret/issues/81
* Manifests linted in various places.

## 1.0.1
* Bugfix: Use custom value for  `$data_dir` in redis server.

## 1.0.0
* Initial release

# TODO

* Replace init.d scripts with systemd unit files. https://github.com/onetimesecret/onetimesecret/issues/69 would be a good starting point.
