class postgresqlbdr::initdb {

  $pgsql_ver = "9.4" 

  info("ls /var/lib/pgsql/{$pgsql_ver}-bdr/data/base 2>/dev/null")

  exec {
      'initdb':
        command   => "sudo -u postgres /usr/pgsql-${pgsql_ver}/bin/initdb -D /var/lib/pgsql/${pgsql_ver}-bdr/data/ -A trust -U postgres",
        cwd	  => "/tmp",
        path      => "/bin/:/usr/bin/:/sbin/:/usr/sbin",
        unless    => "ls /var/lib/pgsql/$pgsql_ver-bdr/data/base 2>/dev/null",
   }
}
