# == Class: onetimesecret::install
#
# Installation
#
class onetimesecret::install {

  Exec {
    path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd       => '/',
    tries     => 3,
    try_sleep => 10,
  }

  # Should we manage the package/archive installation?
  if ( $onetimesecret::manage_package == true ) {

    $package_name = $onetimesecret::package_name
    $version      = $onetimesecret::version
    $filename     = "${version}.zip"

    # Stop puppet from sending an http HEAD request on every run
    if find_file("${onetimesecret::install_dir}/${filename}") == undef {
      $fulldownloadurl = "${onetimesecret::download_url}/${filename}"
    }
    else { $fulldownloadurl = undef }

    file { "${onetimesecret::install_dir}/${filename}":
      ensure  => file,
      owner   => 'root',
      mode    => '0644',
      group   => $onetimesecret::root_group,
      source  => $fulldownloadurl,
      notify  => Exec['unzip'],
      require => Package[$onetimesecret::additional_packages],
    }

    exec { 'unzip':
      command     => "unzip ${onetimesecret::install_dir}/${filename}",
      cwd         => $onetimesecret::install_dir,
      creates     => "${onetimesecret::install_dir}/onetimesecret-${version}",
      user        => 'root',
      require     => Package[$onetimesecret::additional_packages],
      refreshonly => true,
    }

    file {
      [ $onetimesecret::config_dir, $onetimesecret::data_dir,
      $onetimesecret::log_dir, $onetimesecret::pid_dir ]:
        ensure => directory,
        owner  => $onetimesecret::user,
        group  => $onetimesecret::group,
    }

    # We won't be able to build the app without these packages.
    if ( $onetimesecret::manage_additional_packages == true ) {

      # Install dependencies required to build OTS
      package { $onetimesecret::additional_packages:
        ensure  => 'installed',
      }
      # Use foreman as process manager
      package {'installforeman':
        ensure   => 'installed',
        name     => 'foreman',
        provider => 'gem',
        require  => Package[$onetimesecret::additional_packages],
      }
    }

    # Build from source
    exec { "build ${module_name} version ${version} from source package":
      cwd         => "${onetimesecret::install_dir}/onetimesecret-${version}",
      command     => "${onetimesecret::bundle_exec} install --deployment --frozen --without=dev",
      user        => 'root',
      refreshonly => true,
      require     => [File["${onetimesecret::install_dir}/${filename}"], Package[$onetimesecret::additional_packages]],
      subscribe   => File["${onetimesecret::install_dir}/${filename}"],
    }

    # Change file owner
    exec { 'chown onetimesecret source directory':
      command     => "chown -R ${onetimesecret::user}:${onetimesecret::group} ${onetimesecret::install_dir}/onetimesecret-${version}",
      path        => ['/bin','/sbin'],
      refreshonly => true,
      subscribe   => Exec["build ${module_name} version ${version} from source package"],
      require     => Exec["build ${module_name} version ${version} from source package"],
    }

    # Copy required static files to config directory
    exec { "copy ${module_name} static files for version ${version} to ${onetimesecret::config_dir}":
      cwd         => "${onetimesecret::install_dir}/onetimesecret-${version}",
      command     => "cp -Rp etc/locale etc/fortunes ${onetimesecret::config_dir}/",
      path        => ['/bin','/sbin'],
      refreshonly => true,
      subscribe   => Exec['chown onetimesecret source directory'],
      require     => Exec['chown onetimesecret source directory'],
    }

    # Set symlink to current version
    if $onetimesecret::manage_symlink {
      file { $onetimesecret::symlink_name:
        ensure  => link,
        target  => "${onetimesecret::install_dir}/onetimesecret-${version}",
        owner   => $onetimesecret::user,
        group   => $onetimesecret::group,
        require => Exec['chown onetimesecret source directory'],
      }
    }

  }
}
