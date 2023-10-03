# Puppet manifest for configuring Nginx with custom HTTP response header

# Ensure Nginx package is installed
package { 'nginx':
  ensure => 'installed',
}

# Create a directory for HTML files
file { '/etc/nginx/html':
  ensure => 'directory',
}

# Create the index.html file
file { '/etc/nginx/html/index.html':
  ensure  => 'file',
  content => 'Hello World!',
}

# Create the 404.html file
file { '/etc/nginx/html/404.html':
  ensure  => 'file',
  content => "Ceci n'est pas une page",
}

# Create a custom Nginx configuration file
file { '/etc/nginx/sites-available/default':
  ensure  => 'file',
  content => template('nginx_config/nginx_config.erb'),
  notify  => Service['nginx'],
}

# Enable the default site by creating a symlink
file { '/etc/nginx/sites-enabled/default':
  ensure  => 'link',
  target  => '/etc/nginx/sites-available/default',
  require => File['/etc/nginx/sites-available/default'],
}

# Define an Nginx service
service { 'nginx':
  ensure => 'running',
  enable => 'true',
}

# Define a custom HTTP response header in the Nginx configuration
exec { 'configure_custom_header':
  command  => 'echo "add_header X-Served-By $hostname;" >> /etc/nginx/sites-available/default',
  creates  => '/etc/nginx/sites-available/default',
  require  => File['/etc/nginx/sites-available/default'],
  notify   => Service['nginx'],
  provider => 'shell',
}
