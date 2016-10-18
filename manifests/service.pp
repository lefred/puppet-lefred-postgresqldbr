class postgresqlbdr::service {

        service {
                "postgresql-9.4":
                        enable  => true,
            		ensure  => running,
        }
}
