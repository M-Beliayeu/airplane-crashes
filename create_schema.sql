-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema airplane_crashes
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema airplane_crashes
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `airplane_crashes` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `airplane_crashes` ;

-- -----------------------------------------------------
-- Table `airplane_crashes`.`Crashes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `airplane_crashes`.`Crashes` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `airplane_crashes`.`Crashes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` VARCHAR(45) NULL DEFAULT NULL,
  `time` VARCHAR(45) NULL DEFAULT NULL,
  `location` VARCHAR(45) NULL DEFAULT NULL,
  `operator` VARCHAR(45) NULL DEFAULT NULL,
  `flight_no` VARCHAR(45) NULL DEFAULT NULL,
  `route` VARCHAR(45) NULL DEFAULT NULL,
  `ac_type` VARCHAR(45) NULL DEFAULT NULL,
  `registration` VARCHAR(45) NULL DEFAULT NULL,
  `cn/ln` VARCHAR(45) NULL DEFAULT NULL,
  `aboard` VARCHAR(45) NULL DEFAULT NULL,
  `fatalities` VARCHAR(45) NULL DEFAULT NULL,
  `ground` INT NULL DEFAULT NULL,
  `summary` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
