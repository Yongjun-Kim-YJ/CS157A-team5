DROP TABLE IF EXISTS `progressTracking`;
CREATE TABLE `progressTracking` (
  `studentID` INT NOT NULL,
  `earnedCredits` INT DEFAULT 0,
  `remainingCredits` INT DEFAULT 0,
  PRIMARY KEY (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `progressTracking` (`studentID`, `earnedCredits`, `remainingCredits`) 
VALUES (12, 38, 82);