class postgresqlbdr::server ($seed=undef, $db='demo') {

  include postgresqlbdr::repository
  include postgresqlbdr::packages
  include postgresqlbdr::initdb
  include postgresqlbdr::config
  include postgresqlbdr::service
  include postgresqlbdr::setupbdr

  
  Class["postgresqlbdr::repository"] -> Class["postgresqlbdr::packages"] -> Class["postgresqlbdr::initdb"] -> Class["postgresqlbdr::config"] -> Class["postgresqlbdr::service"] -> Class["postgresqlbdr::setupbdr"]

}
