String create_coordinator="CREATE TABLE if not exists coordinator(mobNumber NUMBER,pass TEXT,address TEXT,status TEXT,name TEXT, city TEXT,country TEXT,state TEXT)";
String create_pending_users="create table if not exists pending_users(name TEXT,mobNumber TEXT,address TEXT,city TEXT,country TEXT,user_type TEXT,status TEXT,image TEXT)";
String create_cities="create table if not exists cities(name TEXT)";
//update is date in format dd/mm/yyyy
String create_table_updated="create table if not exists table_updated(name TEXT,updated TEXT)";

String delete_coordinator="";
String delete_pending_farmers="";
String delete_pending_coordinators="";
String delete_updated_tables="";

String insert_coordinator="";
String insert_pending_farmers="";
String insert_pending_coordinators="";
String insert_updated_tables="";

String delete_coordinator_record="";
String delete_pending_farmers_record="";
String delete_pending_coordinators_record="";
String delete_updated_tables_record="";