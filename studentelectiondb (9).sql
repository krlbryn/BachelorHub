-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2026 at 05:11 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `studentelectiondb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_ID` int(11) NOT NULL,
  `admin_username` varchar(50) NOT NULL,
  `admin_Name` varchar(100) NOT NULL,
  `admin_Email` varchar(100) NOT NULL,
  `admin_Password` varchar(255) NOT NULL,
  `admin_Phone` varchar(20) DEFAULT 'Not Set',
  `admin_Address` text DEFAULT NULL,
  `admin_Image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_ID`, `admin_username`, `admin_Name`, `admin_Email`, `admin_Password`, `admin_Phone`, `admin_Address`, `admin_Image`) VALUES
(1, 'Admin1', 'Najib', 'najib@gmail.com', '123', '0138519619', 'Universiti Teknologi  MARA(UiTM) Cawangan Sarawak,\r\nKampus Samarahan 2,\r\n94300 Kota Samarahan,\r\nSarawak, Malaysia.', 'Admin1.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `candidate`
--

CREATE TABLE `candidate` (
  `cand_ID` int(11) NOT NULL,
  `cand_ManifestoDesc` text DEFAULT NULL,
  `cand_PhotoPath` varchar(255) DEFAULT NULL,
  `stud_ID` int(11) DEFAULT NULL,
  `candidate_Position` varchar(100) DEFAULT NULL,
  `election_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `candidate`
--

INSERT INTO `candidate` (`cand_ID`, `cand_ManifestoDesc`, `cand_PhotoPath`, `stud_ID`, `candidate_Position`, `election_ID`) VALUES
(320, 'I will change UiTM into a fashionable free rule', 'Candidate1.png', 2026000012, 'President', 28),
(321, 'I will make UiTM give free ice cream everyday', 'Candidate2.jpg', 2026000011, 'Club President', 28),
(325, 'I will change UiTM into jail', 'Candidate4.jpg', 2026000001, 'President', 28),
(327, 'I will make Uitm a happy place for students', 'Candidate1.png', 2026000001, 'President', 31);

-- --------------------------------------------------------

--
-- Table structure for table `election`
--

CREATE TABLE `election` (
  `election_ID` int(11) NOT NULL,
  `election_Title` varchar(255) NOT NULL,
  `election_Desc` text DEFAULT NULL,
  `election_StartDate` datetime NOT NULL,
  `election_EndDate` datetime NOT NULL,
  `election_Status` varchar(50) DEFAULT NULL,
  `admin_ID` int(11) DEFAULT NULL,
  `election_Positions` varchar(255) DEFAULT NULL,
  `election_Image` varchar(255) DEFAULT 'default_election.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `election`
--

INSERT INTO `election` (`election_ID`, `election_Title`, `election_Desc`, `election_StartDate`, `election_EndDate`, `election_Status`, `admin_ID`, `election_Positions`, `election_Image`) VALUES
(25, 'Student Council 2026', 'Voting for the new Student Council representative.', '2026-02-09 08:00:00', '2026-02-10 17:00:00', 'Active', 1, 'Club President,President,Secretary,Treasurer', 'Poster5.jpg'),
(26, 'Computer Club Committee', 'Selecting the new committee members for the CS Club.', '2026-02-03 08:00:00', '2026-02-07 17:00:00', 'Upcoming', 1, 'Club President,President', 'Poster3.jpg'),
(28, 'MPP Selection 2026', 'The selection of MPP UiTM in 2026 official starts.', '2026-02-06 08:00:00', '2026-02-10 17:00:00', 'Closed', 1, 'Club President,President,Secretary,Treasurer', 'Poster1.png'),
(31, 'Example 1', 'This section use to describe what is the election alll about.', '2026-02-09 19:16:00', '2026-02-10 19:16:00', 'Active', 1, 'Club President,President,Secretary,Treasurer', 'Poster4.png');

-- --------------------------------------------------------

--
-- Table structure for table `electionresult`
--

CREATE TABLE `electionresult` (
  `elecResult_ID` int(11) NOT NULL,
  `election_ID` int(11) DEFAULT NULL,
  `position_ID` int(11) DEFAULT NULL,
  `cand_ID` int(11) DEFAULT NULL,
  `totalVotes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `position_ID` int(11) NOT NULL,
  `position_Name` varchar(100) NOT NULL,
  `position_Desc` text DEFAULT NULL,
  `election_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`position_ID`, `position_Name`, `position_Desc`, `election_ID`) VALUES
(1, 'President', 'The main leader of the student body.', 1),
(2, 'Treasurer', 'Responsible for managing student funds.', 1),
(3, 'Club President', 'Leads the club activities.', 2),
(4, 'Secretary', 'Handles documentation and meetings.', 2),
(95, 'Club President', 'Role for Computer Club Committee', 26),
(96, 'President', 'Role for Computer Club Committee', 26),
(119, 'Club President', 'Role for Student Council 2026', 25),
(120, 'President', 'Role for Student Council 2026', 25),
(121, 'Secretary', 'Role for Student Council 2026', 25),
(122, 'Treasurer', 'Role for Student Council 2026', 25),
(123, 'Club President', 'Role for MPP Selection 2026', 28),
(124, 'President', 'Role for MPP Selection 2026', 28),
(125, 'Secretary', 'Role for MPP Selection 2026', 28),
(126, 'Treasurer', 'Role for MPP Selection 2026', 28),
(127, 'Club President', 'Role for Example 1', 31),
(128, 'President', 'Role for Example 1', 31),
(129, 'Secretary', 'Role for Example 1', 31),
(130, 'Treasurer', 'Role for Example 1', 31);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `stud_ID` int(11) NOT NULL,
  `stu_Username` varchar(50) NOT NULL,
  `stu_Name` varchar(100) NOT NULL,
  `stu_Email` varchar(100) NOT NULL,
  `stu_Password` varchar(255) NOT NULL,
  `stu_Program` varchar(100) DEFAULT NULL,
  `stu_Year` int(4) DEFAULT NULL,
  `stu_Image` varchar(255) DEFAULT 'default.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`stud_ID`, `stu_Username`, `stu_Name`, `stu_Email`, `stu_Password`, `stu_Program`, `stu_Year`, `stu_Image`) VALUES
(2026000001, 'abu123', 'Abu', 'abu@gmail.com', '1234', 'CS110', 1, 'stu_2026000001_1770611811753_Student4.png'),
(2026000002, 'siti2026', 'Siti Sarah', 'siti@gmail.com', '1234', 'CS110', 1, 'Student5.jpg'),
(2026000003, 'chong2026', 'Chong Wei', 'chong@gmail.com', '1234', 'CS110', 2, 'Student7.jpg'),
(2026000004, 'ali123', 'Ali', 'ali@gmail.com', '1234', 'CDCS110', 2, 'Student2.jpg'),
(2026000010, 'farid123', 'Farid Kamil', 'farid@gmail.com', '1234', 'AS120', 2, 'Student4.jpg'),
(2026000011, 'gita123', 'Gita Savitri', 'gita@gmail.com', '1234', 'CEEC211', 3, 'Student6.jpg'),
(2026000012, 'harry123', 'Harry Potter', 'harry@gmail.com', '1234', 'CEEC211', 1, 'Student8.jpg'),
(2026000013, 'rogayah1', 'Rogayah Binti Ali', 'roga@gamil.com', '1234', 'IM120', 3, 'Student3.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `vote`
--

CREATE TABLE `vote` (
  `vote_ID` int(11) NOT NULL,
  `vote_Time` datetime DEFAULT current_timestamp(),
  `cand_ID` int(11) DEFAULT NULL,
  `stud_ID` int(11) DEFAULT NULL,
  `election_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vote`
--

INSERT INTO `vote` (`vote_ID`, `vote_Time`, `cand_ID`, `stud_ID`, `election_ID`) VALUES
(24, '2026-02-06 20:02:43', 321, 2026000004, 28),
(25, '2026-02-06 20:02:46', 320, 2026000004, 28),
(29, '2026-02-09 12:49:37', 320, 2026000001, 28);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_ID`);

--
-- Indexes for table `candidate`
--
ALTER TABLE `candidate`
  ADD PRIMARY KEY (`cand_ID`),
  ADD KEY `stud_ID` (`stud_ID`),
  ADD KEY `position_ID` (`candidate_Position`);

--
-- Indexes for table `election`
--
ALTER TABLE `election`
  ADD PRIMARY KEY (`election_ID`),
  ADD KEY `admin_ID` (`admin_ID`);

--
-- Indexes for table `electionresult`
--
ALTER TABLE `electionresult`
  ADD PRIMARY KEY (`elecResult_ID`),
  ADD KEY `election_ID` (`election_ID`),
  ADD KEY `position_ID` (`position_ID`),
  ADD KEY `cand_ID` (`cand_ID`);

--
-- Indexes for table `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`position_ID`),
  ADD KEY `election_ID` (`election_ID`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`stud_ID`);

--
-- Indexes for table `vote`
--
ALTER TABLE `vote`
  ADD PRIMARY KEY (`vote_ID`),
  ADD KEY `cand_ID` (`cand_ID`),
  ADD KEY `stud_ID` (`stud_ID`),
  ADD KEY `election_ID` (`election_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `candidate`
--
ALTER TABLE `candidate`
  MODIFY `cand_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=328;

--
-- AUTO_INCREMENT for table `election`
--
ALTER TABLE `election`
  MODIFY `election_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `electionresult`
--
ALTER TABLE `electionresult`
  MODIFY `elecResult_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `position_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `stud_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2026000014;

--
-- AUTO_INCREMENT for table `vote`
--
ALTER TABLE `vote`
  MODIFY `vote_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `election`
--
ALTER TABLE `election`
  ADD CONSTRAINT `election_ibfk_2` FOREIGN KEY (`admin_ID`) REFERENCES `admin` (`admin_ID`);

--
-- Constraints for table `electionresult`
--
ALTER TABLE `electionresult`
  ADD CONSTRAINT `electionresult_ibfk_1` FOREIGN KEY (`election_ID`) REFERENCES `election` (`election_ID`),
  ADD CONSTRAINT `electionresult_ibfk_2` FOREIGN KEY (`position_ID`) REFERENCES `position` (`position_ID`),
  ADD CONSTRAINT `electionresult_ibfk_3` FOREIGN KEY (`cand_ID`) REFERENCES `candidate` (`cand_ID`);

--
-- Constraints for table `vote`
--
ALTER TABLE `vote`
  ADD CONSTRAINT `vote_ibfk_2` FOREIGN KEY (`stud_ID`) REFERENCES `student` (`stud_ID`),
  ADD CONSTRAINT `vote_ibfk_3` FOREIGN KEY (`election_ID`) REFERENCES `election` (`election_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
