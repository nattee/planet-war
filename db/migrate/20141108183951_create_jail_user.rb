class CreateJailUser < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TABLE `jail_users` (
        `jail_user_id` int(11) NOT NULL AUTO_INCREMENT,
        `in_use` tinyint(4) DEFAULT '0',
        `username` varchar(45) DEFAULT NULL,
        PRIMARY KEY (`jail_user_id`)
      ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
    SQL

    execute <<-SQL
      INSERT INTO jail_users (username) VALUES ('jail');
    SQL
  end

  def down
    drop_table "jail_users"
  end
end
