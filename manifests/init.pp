class monitored($ensure = present) {
  class { 'awscli': }

  file { 'monitoring-script':
    ensure => $ensure,
    path => "/usr/local/bin/aws-mon",
    mode => 0755,
    content => template("cloudwatch-monitoring/aws-mon-linux/aws-mon.sh"),
    require => File['/root/.aws/credentials'],
  }

  cron { 'report-metric':
    ensure  => $ensure,
    command => "/usr/local/bin/aws-mon --dimensions server=lol --disk-space-util",
    user    => 'root',
    hour    => '*',
    minute  => '*/5',
    require => [File['monitoring-script'],
                Class['awscli']],
  }
}
