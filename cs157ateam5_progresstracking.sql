DROP TABLE IF EXISTS `progressTracking`;
CREATE TABLE `progressTracking` (
  `studentID` INT NOT NULL,
  `earnedCredits` INT DEFAULT 0,
  `remainingCredits` INT DEFAULT 0,
  PRIMARY KEY (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `progressTracking` (`studentID`, `earnedCredits`, `remainingCredits`) VALUES
(12, 38, 82),
(20, 12, 108),
(444, 6, 114),
(777, 33, 87),
(909, 6, 114),
(999, 23, 97),
(1122, 18, 102),
(1209, 3, 117),
(2101, 9, 111),
(2211, 6, 114),
(2222, 18, 102),
(3490, 6, 114),
(5555, 6, 114),
(5982, 15, 105),
(6666, 11, 109);
