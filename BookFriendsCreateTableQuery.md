```sql
CREATE TABLE IF NOT EXISTS `bookfriends`.`user` (
  `userID` VARCHAR(20) NOT NULL,
  `userPassword` VARCHAR(64) NULL DEFAULT NULL,
  `userEmail` VARCHAR(50) NULL DEFAULT NULL,
  `userEmailHash` VARCHAR(2048) NULL DEFAULT NULL,
  `userEmailChecked` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`userID`));

CREATE TABLE IF NOT EXISTS `bookfriends`.`board` (
  `postID` INT NOT NULL AUTO_INCREMENT,
  `userID` VARCHAR(20) NULL DEFAULT NULL,
  `postCategory` VARCHAR(20) NULL DEFAULT NULL,
  `postTitle` VARCHAR(50) NULL DEFAULT NULL,
  `postContent` VARCHAR(2048) NULL DEFAULT NULL,
  `viewCount` INT NULL DEFAULT NULL,
  `likeCount` INT NULL DEFAULT NULL,
  `postDate` TIMESTAMP NULL DEFAULT now(),
  PRIMARY KEY (`postID`),
  INDEX `fk_board_userID` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_board_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`review` (
  `reviewID` INT NOT NULL AUTO_INCREMENT,
  `userID` VARCHAR(20) NULL DEFAULT NULL,
  `bookName` VARCHAR(500) NULL DEFAULT NULL,
  `authorName` VARCHAR(100) NULL DEFAULT NULL,
  `publisher` VARCHAR(20) NULL DEFAULT NULL,
  `category` VARCHAR(20) NULL DEFAULT NULL,
  `reviewTitle` VARCHAR(500) NULL DEFAULT NULL,
  `reviewContent` VARCHAR(2048) NULL DEFAULT NULL,
  `reviewScore` INT NULL DEFAULT NULL,
  `registDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `likeCount` INT NULL DEFAULT NULL,
  `viewCount` INT NULL DEFAULT NULL,
  PRIMARY KEY (`reviewID`),
  INDEX `fk_review_userID` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_review_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    

CREATE TABLE IF NOT EXISTS `bookfriends`.`recruit` (
  `recruitID` INT NOT NULL AUTO_INCREMENT,
  `userID` VARCHAR(20) NULL DEFAULT NULL,
  `recruitStatus` VARCHAR(20) NULL DEFAULT '모집중',
  `recruitTitle` VARCHAR(500) NULL DEFAULT NULL,
  `recruitContent` VARCHAR(2048) NULL DEFAULT NULL,
  `registDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `viewCount` INT NULL DEFAULT NULL,
  PRIMARY KEY (`recruitID`),
  INDEX `fk_recruit_userID` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_recruit_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`chat` (
  `chatID` INT NOT NULL AUTO_INCREMENT,
  `senderID` VARCHAR(20) NULL DEFAULT NULL,
  `receiverID` VARCHAR(20) NULL DEFAULT NULL,
  `message` TEXT NULL DEFAULT NULL,
  `chatTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `chatRead` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`chatID`),
  INDEX `fk_chat_senderID` (`senderID` ASC) VISIBLE,
  INDEX `fk_chat_receiverID` (`receiverID` ASC) VISIBLE,
  CONSTRAINT `chat_ibfk_1`
    FOREIGN KEY (`senderID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE,
  CONSTRAINT `chat_ibfk_2`
    FOREIGN KEY (`receiverID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_chat_receiverID`
    FOREIGN KEY (`receiverID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_chat_senderID`
    FOREIGN KEY (`senderID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`reply` (
  `replyID` INT NOT NULL AUTO_INCREMENT,
  `userID` VARCHAR(20) NULL DEFAULT NULL,
  `postID` INT NULL DEFAULT NULL,
  `replyContent` VARCHAR(2048) NULL DEFAULT NULL,
  `likeCount` INT NULL DEFAULT NULL,
  `replyDate` TIMESTAMP NULL DEFAULT now(),
  `recruitID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`replyID`),
  INDEX `fk_reply_recruitID` (`recruitID` ASC) VISIBLE,
  INDEX `fk_reply_postID` (`postID` ASC) VISIBLE,
  INDEX `fk_reply_userID` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_reply_postID`
    FOREIGN KEY (`postID`)
    REFERENCES `bookfriends`.`board` (`postID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_reply_recruitID`
    FOREIGN KEY (`recruitID`)
    REFERENCES `bookfriends`.`recruit` (`recruitID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_reply_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`file` (
  `fileID` INT NOT NULL AUTO_INCREMENT,
  `fileName` VARCHAR(255) NOT NULL,
  `fileOriginName` VARCHAR(255) NOT NULL,
  `filePath` VARCHAR(255) NOT NULL,
  `recruitID` INT NULL DEFAULT NULL,
  `postID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`fileID`),
  INDEX `fk_file_postID` (`postID` ASC) VISIBLE,
  INDEX `fk_file_recruitID` (`recruitID` ASC) VISIBLE,
  CONSTRAINT `fk_file_postID`
    FOREIGN KEY (`postID`)
    REFERENCES `bookfriends`.`board` (`postID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_file_recruitID`
    FOREIGN KEY (`recruitID`)
    REFERENCES `bookfriends`.`recruit` (`recruitID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_postID`
    FOREIGN KEY (`postID`)
    REFERENCES `bookfriends`.`board` (`postID`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_recruitID`
    FOREIGN KEY (`recruitID`)
    REFERENCES `bookfriends`.`recruit` (`recruitID`)
    ON DELETE CASCADE);
    
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`likeypost` (
  `userID` VARCHAR(20) NOT NULL,
  `postID` VARCHAR(20) NOT NULL,
  `userIP` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`userID`, `postID`),
  CONSTRAINT `fk_likeyPost_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`likeyreview` (
  `userID` VARCHAR(20) NOT NULL,
  `reviewID` VARCHAR(20) NOT NULL,
  `userIP` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`userID`, `reviewID`),
  CONSTRAINT `fk_likeyReview_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);
    
CREATE TABLE IF NOT EXISTS `bookfriends`.`likeyreply` (
  `userID` VARCHAR(20) NOT NULL,
  `replyID` VARCHAR(20) NOT NULL,
  `userIP` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`userID`, `replyID`),
  CONSTRAINT `fk_likeyReply_userID`
    FOREIGN KEY (`userID`)
    REFERENCES `bookfriends`.`user` (`userID`)
    ON DELETE CASCADE);


```
