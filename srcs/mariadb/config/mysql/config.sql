-- create database WPDB;
-- create database phpmyadmin;
-- create USER nlecaill@localhost;
-- grant all privileges on WPDB.* to nlecaill@localhost IDENTIFIED BY 'PASSS';
CREATE DATABASE wordpress;
GRANT all privileges on phpmyadmin.* to admin@'%';
GRANT all privileges on wordpress.* to admin@'%';
FLUSH privileges;
