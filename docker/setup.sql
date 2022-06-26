-- Adminer 4.7.8 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `cs4783_tyw061` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `cs4783_tyw061`;

CREATE TABLE `property` (
  `property_id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(1024) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` char(2) NOT NULL,
  `zip` char(10) NOT NULL,
  PRIMARY KEY (`property_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

CREATE USER 'tyw061'@'%' IDENTIFIED BY 'secret'; -- maybe this will fix access issues?!
GRANT SELECT,UPDATE,DELETE,INSERT on cs4783_tyw061.* to 'tyw061'@'%';
-- GRANT SELECT,UPDATE,DELETE,INSERT on cs4783_tyw061.* to `tyw061`@`%` identified by 'p@ssw0rd';

INSERT INTO `property` (`property_id`, `address`, `city`, `state`, `zip`) VALUES
(1,	'567 Rongrong Way',	'UTSA City',	'TX',	'78250'),
(2,	'999 Rongrong Way',	'San Antonio',	'TX',	'78249'),
(3,	'123 UTSA Way',	'San Antonio',	'TX',	'78249'),
(4,	'111 HELLP',	'AAAGH',	'TX',	'77777'),
(5,	'321 Safe Rd.',	'Rongrong City',	'TX',	'72222'),
(6,	'Test Place',	'Test City',	'TX',	'78249'),
(7,	'Test Place',	'Test City',	'TX',	'78249'),
(8,	'Test Place',	'Test City',	'TX',	'78249'),
(9,	'UTSA',	'San Antonio',	'TX',	'78249'),
(10,	'Test Place',	'Flavortown',	'TX',	'78249');
