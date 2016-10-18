class postgresqlbdr::setupbdr {

   $seed  = $postgresqlbdr::server::seed
   $bdrdb = $postgresqlbdr::server::db 

   info("seed host is $seed")
   
   exec {
	"createdb":
	 	command => "createdb -U postgres $bdrdb",
		path    => "/bin/:/usr/bin/:/sbin/:/usr/sbin",
                unless  => "psql -U postgres $bdrdb -c 'select 1'";
        "add_btree_gist_extension":
	 	command => "psql -U postgres $bdrdb -c 'CREATE EXTENSION btree_gist'",
		path    => "/bin/:/usr/bin/:/sbin/:/usr/sbin",
		require => Exec["createdb"],
		unless  => "psql -U postgres $bdrdb -c \"select * from pg_available_extensions where name = 'btree_gist'\" | grep btree_gist | cut -d'|' -f3 | grep '\\.' >/dev/null";
        "add_bdr_extension":
	 	command => "psql -U postgres $bdrdb -c 'CREATE EXTENSION bdr'",
		path    => "/bin/:/usr/bin/:/sbin/:/usr/sbin",
		require => Exec["add_btree_gist_extension"],
		unless  => "psql -U postgres $bdrdb -c \"select * from pg_available_extensions where name = 'bdr'\" | grep bdr | cut -d'|' -f3 | grep '\\.' >/dev/null";
        "bdr_join_ready":
	 	command => "psql -U postgres $bdrdb -c 'SELECT bdr.bdr_node_join_wait_for_ready();'",
		path    => "/bin/:/usr/bin/:/sbin/:/usr/sbin",
		require => Exec["create_group"],
   }	

   if $seed == $hostname {
	info("we are on the seed")
        $command_sql = "psql -U postgres $bdrdb -c \"select bdr.bdr_group_create( local_node_name := '$hostname', node_external_dsn := 'port=5432 dbname=$bdrdb host=$hostname');\""
   }
   else {
	info("we are not on the seed")
        $command_sql = "psql -U postgres $bdrdb -c \"select bdr.bdr_group_join( local_node_name := '$hostname', node_external_dsn := 'port=5432 dbname=$bdrdb host=$hostname', join_using_dsn := 'port=5432 dbname=$bdrdb host=$seed');\""
   }

   exec {
        "create_group":
	 	command => $command_sql,
		path    => "/bin/:/usr/bin/:/sbin/:/usr/sbin",
		require => Exec["add_bdr_extension"],
		unless  => "psql -U postgres $bdrdb -c \"SELECT node_name FROM bdr.bdr_nodes;\" | grep $hostname  >/dev/null";
   }

}
