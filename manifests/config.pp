class postgresqlbdr::config {

        file {
                "/var/lib/pgsql/9.4-bdr/data/postgresql.conf":
                        ensure  => present,
			notify  => Service["postgresql-9.4"],
                        content => template("postgresqlbdr/server/postgresql.conf.erb");
                "/var/lib/pgsql/9.4-bdr/data/pg_hba.conf":
                        ensure  => present,
			notify  => Service["postgresql-9.4"],
                        content => template("postgresqlbdr/server/pg_hba.conf.erb");
        }


}
