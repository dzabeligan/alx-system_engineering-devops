# Install Nginx package
package { 'nginx':
  ensure => 'installed',
}

# Define the Nginx configuration file for the default site
file { '/etc/nginx/sites-available/default':
  ensure => 'file',
  content => "# Nginx configuration for default site
  server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /usr/share/nginx/html;
    index index.html index.htm;

    location /redirect_me {
      return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }

    error_page 404 /404.html;
    location = /404.html {
      root /usr/share/nginx/html;
    }

    location / {
      try_files \$uri \$uri/ =404;
    }
  }",
  notify => Service['nginx'],
}

# Define the Nginx HTML file
file { '/usr/share/nginx/html/index.html':
  ensure  => 'file',
  content => 'Hello World!',
}

# Notify Nginx service to restart when the configuration or HTML file changes
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => File['/etc/nginx/sites-available/default', '/usr/share/nginx/html/index.html'],
}
