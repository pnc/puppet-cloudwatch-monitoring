define cloudwatch::monitored($ensure = present) {
  file { 'monitoring-script':
    ensure => $ensure,
    path => "/usr/local/bin/aws-mon",
    mode => 0755,
    source => "puppet:///modules/cloudwatch/aws-mon-linux/aws-mon.sh",
    require => File['/root/.aws/credentials'],
  }

  cron { 'report-metric':
    ensure  => $ensure,
    command => "/usr/local/bin/aws-mon --namespace Detail --dimensions server=${hostname} --region us-east-1 --disk-space-util --disk-path /",
    environment => ['HOME=/root', 'PATH=/usr/local/bin:/usr/bin:/bin'],
    user    => 'root',
    hour    => '*',
    minute  => '*/5',
    require => [File['monitoring-script'],
                Class['awscli']],
  }
}
