USE mysql;
GRANT ALL ON *.* TO 'XrootX'@'%' identified by 'XrootpassX' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'XrootX'@'localhost' identified by 'XrootpassX' WITH GRANT OPTION ;
SET PASSWORD FOR 'XrootX'@'localhost'=PASSWORD('XrootpassX') ;
DROP DATABASE IF EXISTS test ;
CREATE USER 'XadminX'@`%` IDENTIFIED BY 'XadminpassX';
FLUSH PRIVILEGES ;
