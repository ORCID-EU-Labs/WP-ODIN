#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt"


execute "apt-get update" do
  command "apt-get update"
end


file 'mariadb_init_db_lock' do
  action :create_if_missing
  notifies :run, 'execute[mariadb_init_db]', :immediately
end

execute 'mariadb_init_db' do
  command '
   export DEBIAN_FRONTEND="noninteractive";
   apt-get -q -y install mysql-server;
   mysqladmin -u root create wordpress_odin;
   mysql -uroot -e "CREATE USER \'odin\'@\'localhost\' IDENTIFIED BY \'JeQa4wew\';";
   mysql -uroot -e "GRANT ALL PRIVILEGES ON wordpress_odin.* TO \'odin\'@\'localhost\' ";
   mysqladmin -u root password drEpA5he;
  '
  action :nothing
end

package 'lamp-server^' do
  action :install
end

package 'wordpress' do
  action :install
end


file 'wp_mysql_init_lockfile' do
  action :create_if_missing
  notifies :run, 'execute[wp_mysql_init]', :immediately
end


execute 'wp_mysql_init' do
  command '
   sudo ln -s /usr/share/wordpress /var/www/html
   sudo hown -R www-data /var/www
   sudo chown -R www-data /usr/share/wordpress
   sudo /etc/init.d/apache2 restart;
  '
  action :nothing
end
