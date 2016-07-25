# == Class: midonet::mem::vhost
#
# This class installs apache2/httpd server and configures a custom virtualhost
# for midonet-manager.
#
# === Parameters
#
# [*apache_port*]
#  The TCP port where apache2/httpd server is listening on.
#  Note: this value has been defaulted to '80'
#
# [*docroot*]
#   The value for the virtualhost DocumentRoot directive.
#   Note: this value has been defaulted to '/var/www/html'
#
# [*servername*]
#   The value for the virtualhost ServerName directive.
#   Note: this value has been defaulted to "http://$::ipaddress"
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2016 Midokura SARL, All Rights Reserved.

class midonet::mem::vhost (
  $apache_port = $midonet::mem::params::apache_port,
  $docroot     = $midonet::mem::params::docroot,
  $servername  = $midonet::mem::params::servername,
  $proxy_pass = [
    { 'path' => "/$midonet::mem::params::api_namespace",
      'url'  => "$midonet::mem::params::api_host",
    },
  ],
  $directories = [
    { 'path'  => $docroot,
      'allow' => 'from all',
    },
  ],
) inherits midonet::mem::params {

  validate_string($apache_port)
  validate_string($docroot)
  validate_string($servername)
  validate_array($proxy_pass)
  validate_array($directories)

  include ::apache
  include ::apache::mod::headers

  apache::vhost { 'midonet-mem':
    port            => $apache_port,
    servername      => $servername,
    docroot         => $docroot,
    proxy_pass      => $proxy_pass,
    directories     => $directories,
    require         => Package["$midonet::mem::params::mem_package"],
  }
}

