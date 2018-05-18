Replication setup on a windows server :
Server1 Settings ================ 1. Put the option file my.ini(C:\ProgramData\MySQL\MySQL Server 5.7) to Server1 with these settings: [mysqld] log-bin=mysql-bin server-id = 1 auto_increment_increment = 10 auto_increment_offset = 1
2. Configure the server: # create a user for replication process: create user replicant@'%' identified by 'password';
Grant access rights: GRANT SELECT, PROCESS, FILE, SUPER, REPLICATION CLIENT, REPLICATION SLAVE, RELOAD ON . TO replicant@'%'; Flush Privileges;
Specify the info for the serve2: CHANGE MASTER TO MASTER_HOST='ip_of_server2', MASTER_USER='replication_user_name_on_server2', MASTER_PASSWORD='replication_password_on_server2';
Start the listerner: Start slave;
Verify whether the replication is working: show slave status\G

Server2 Settings ================ 1. Put the option file my.ini on to Server2 with these settings: [mysqld] log-bin=mysql-bin server-id= 2 auto_increment_increment = 10 auto_increment_offset = 2
2. Configure the server: # create a user for replication process: cd /usr/local/mysql/bin ./mysql -p -u root
create user replicant@'%' identified by 'password';
Grant access rights: GRANT SELECT, PROCESS, FILE, SUPER, REPLICATION CLIENT, REPLICATION SLAVE, RELOAD ON . TO replicant@'%'; Flush Privileges;
Specify the info for the serve1: CHANGE MASTER TO MASTER_HOST='ip_of_server1', MASTER_USER='replication_user_name_on_server1', MASTER_PASSWORD='replication_password_on_server1';
Example: # # CHANGE MASTER TO MASTER_HOST='125.564.12.1', # MASTER_USER='replicant', MASTER_PASSWORD='password';
Start the listerner: Start slave; When using ​mysqldump​, you should stop replication on the slave before starting the dump process to ensure that the dump contains a consistent set of data:

STOP SLAVE;
mysqldump --user=root --password=your_password --all-databases >"a:\mysql\all_databases.sql" Mysql -u username -p < all_databases.sql
$ mysql -u [uname] -p[pass] [db_to_restore] < [all_databases.sql] Issues: 1. If error like “Got fatal error 1236 from master when reading data from binary log: 'Binary log is not open'“ occurs that means binary logging is not enable.We can check this using SHOW BINARY LOGS; command. 2. Verify log-bin=mysql-bin is properly mentioned in my.ini file or not . If error like “ The slave I/O thread stops because master and slave have equal MySQL server ids” occurs make sure server id is different for master and slave. Check server id with SHOW VARIABLES LIKE ‘server_id’ command. User can set server id with SET GLOBAL server_id=x command or Can set server-id in my.ini file and restart mysql sever . 3. To remove slave “RESET SLAVE ALL;” command can be used.
