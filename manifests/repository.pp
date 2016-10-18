class postgresqlbdr::repository {

  yumrepo {
                "postgresql-bdr94-2ndquadrant-redhat":
                        descr       => "PostgreSQL 9.4 with BDR for RHEL $releasever - $basearch",
                        enabled     => 1,
                        baseurl     => 'http://packages.2ndquadrant.com/postgresql-bdr94-2ndquadrant/yum/redhat-$releasever-$basearch',
			gpgcheck    => 0; 
  }
}
