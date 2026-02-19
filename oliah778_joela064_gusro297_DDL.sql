DROP VIEW IF EXISTS artifact_report;
DROP VIEW IF EXISTS slide_catalogue;
DROP VIEW IF EXISTS slide_loan_report;

DROP TABLE IF EXISTS slide_loan, book_loan, staff_journal, staff_dig, staff_artifact, staff_grant_proposal, artifact, slide;
DROP TABLE IF EXISTS dig;
DROP TABLE IF EXISTS book, journal, staff, keywords, grant_proposal;

-- Tabell för att lagra information om böcker
CREATE TABLE book(
book_no INT PRIMARY KEY IDENTITY(1,1),
title VARCHAR(255),
author VARCHAR(255),
[year] INT NOT NULL CHECK ([year] > 0)
);

-- Tabell för att lagra information om journals
CREATE TABLE journal(
journal_no INT PRIMARY KEY IDENTITY(1,1),
date DATE NOT NULL,
title VARCHAR(255) NOT NULL
);

-- Tabell för att lagra information om personal
CREATE TABLE staff(
staff_no INT PRIMARY KEY IDENTITY(1,1),
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
phone_no VARCHAR(15) UNIQUE NOT NULL,
email VARCHAR(255) UNIQUE NOT NULL
);

-- Tabell för att lagra nyckelord kopplade till artefakter eller slides
CREATE TABLE keywords(
term VARCHAR(255) PRIMARY KEY,
description VARCHAR(255) NOT NULL
);

-- Tabell för att lagra information om bidragsansökningar
CREATE TABLE grant_proposal(
grant_proposal_no INT PRIMARY KEY IDENTITY(1,1),
title VARCHAR(255) NOT NULL,
description VARCHAR(255) NOT NULL,
amount DECIMAL(10,2) NOT NULL,
date DATE NOT NULL,
status VARCHAR(255) NOT NULL CHECK (status IN ('ACCEPTED', 'REJECTED', 'PENDING'))
);

-- Tabell för att lagra information om digs
CREATE TABLE dig(
dig_no INT PRIMARY KEY IDENTITY(1,1),
location VARCHAR(50) NOT NULL,   
start_date DATE NOT NULL,
end_date DATE,
grant_proposal_no INT NOT NULL,
FOREIGN KEY (grant_proposal_no) REFERENCES grant_proposal(grant_proposal_no)
);


-- Tabell för att lagra information om artefakter och deras nuvarande plats
CREATE TABLE artifact(
item_no INT PRIMARY KEY IDENTITY(1,1),
description VARCHAR(255) NOT NULL,
grid VARCHAR(255) NOT NULL,
depth FLOAT NOT NULL,
date_Found DATE NOT NULL,
current_location VARCHAR(255) CHECK (current_location IN ('WAREHOUSE', 'LAB', 'DISPLAYED')) NOT NULL,
shelf_no VARCHAR(255) NOT NULL,
dig_no INT NOT NULL,
term VARCHAR(255) NOT NULL,
FOREIGN KEY (dig_no) REFERENCES dig (dig_no),
FOREIGN KEY (term) REFERENCES keywords (term)
);

-- Tabell för att lagra information om slides
CREATE TABLE slide(
slide_no INT PRIMARY KEY IDENTITY(1,1),
description VARCHAR(255) NOT NULL,
dig_no INT NOT NULL,
term VARCHAR(255) NOT NULL,
FOREIGN KEY (dig_no) REFERENCES dig (dig_no),
FOREIGN KEY (term) REFERENCES keywords (term)
);

-- Tabell för att spåra lån av slides till personal
CREATE TABLE slide_loan(
date_out DATE NOT NULL,
due_date DATE NOT NULL,
date_back DATE,
staff_no INT NOT NULL,
slide_no INT NOT NULL,
FOREIGN KEY (staff_no) REFERENCES staff (staff_no),
FOREIGN KEY (slide_no) REFERENCES slide (slide_no),
PRIMARY KEY (date_out, staff_no, slide_no)
);

 

-- Tabell för att spåra lån av böcker till personal
CREATE TABLE book_loan(
date_out DATE NOT NULL,
due_date DATE NOT NULL,
date_back DATE,
staff_no INT NOT NULL,
book_no INT NOT NULL,
FOREIGN KEY (staff_No) REFERENCES staff (staff_no),
FOREIGN KEY (book_no) REFERENCES book (book_no),
PRIMARY KEY (date_out, staff_no, book_no)
);

 

-- Tabell för att koppla personal till journals som de använder
CREATE TABLE staff_journal(
date DATE NOT NULL,
staff_no INT NOT NULL,
journal_no INT NOT NULL,
FOREIGN KEY (staff_no) REFERENCES staff (staff_no),
FOREIGN KEY (journal_no) REFERENCES journal (journal_no),
PRIMARY KEY (date, staff_no, journal_no)

);


-- Tabell för att koppla personal till digs som de är involverade i
CREATE TABLE staff_dig(
staff_no INT NOT NULL,
dig_no INT NOT NULL,
FOREIGN KEY (staff_no) REFERENCES staff (staff_no),
FOREIGN KEY (dig_no) REFERENCES dig (dig_no),
PRIMARY KEY (staff_no, dig_no)
);

 

-- Tabell för att koppla personal till artefakter de har hanterat
CREATE TABLE staff_artifact (
date DATE NOT NULL,
staff_no INT NOT NULL,
item_no INT NOT NULL,
FOREIGN KEY (staff_no) REFERENCES staff (staff_no),
FOREIGN KEY (item_no) REFERENCES artifact (item_no),
PRIMARY KEY (date, staff_no, item_no)
);

 

-- Tabell för att koppla personal till bidragsansökningar de är associerade med
CREATE TABLE staff_grant_proposal (
staff_no INT NOT NULL,
grant_proposal_no INT NOT NULL,
FOREIGN KEY (staff_no) REFERENCES staff (staff_no),
FOREIGN KEY (grant_proposal_no) REFERENCES grant_proposal (grant_proposal_no),
PRIMARY KEY (staff_no, grant_proposal_no)
);


INSERT INTO book (title, author, year)
VALUES               
	('SNABBA CASH', 'JENS LAPIDUS', 2007),
	('DJUNGELBOKEN', 'ASTRID LINDGREN', 1888),
	('BOOKEN', 'MIG', 1999),
	('BOOKEN 2', 'DU', 2005),
	('BOOKEN 3', 'HEN', 1999),
	('BOOK 4', 'DEN', 2005),
	('BOOK 5', 'DEM', 1998);

 
INSERT INTO journal (date, title)
VALUES
    ('1999-08-28', 'Journal of joela'),
    ('2001-05-08', 'life of joela'),
    ('2005-12-15', 'Adventures in Coding'),
    ('2010-03-22', 'A Year in Travel'),
    ('2015-07-09', 'Reflections on Nature'),
    ('2018-11-11', 'The Art of Mindfulness'),
    ('2023-01-30', 'My Journey to Learning SQL');

 
INSERT INTO staff (first_name, last_name, phone_no, email)
VALUES
    ('Joel', 'Lantz', '0734759633', 'joela064@student.liu.se'),
    ('Oliwer', 'Ahlstrand', '0708973521', 'oliah778@student.liu.se'),
    ('Emma', 'Bergstrom', '0735872345', 'emmab234@student.liu.se'),
    ('Karl', 'Nordstrand', '0709238764', 'karln876@student.liu.se'),
    ('Mia', 'Svensson', '0734932789', 'miasv741@student.liu.se'),
    ('Adam', 'Johansson', '0708124537', 'adamj112@student.liu.se'),
    ('Lisa', 'Andersson', '0733649278', 'lisaan592@student.liu.se'),
    ('Peter', 'Olsson', '0705564871', 'petero935@student.liu.se');

 

INSERT INTO keywords (term, description) 
VALUES
    ('VIKING AXE', 'Axe used by Vikings during battles'),
    ('MEDIEVAL SWORD', 'Sword used by knights in medieval times'),
    ('FOSSILE', 'Remains of ancient plants or animals'),
    ('SHIELD', 'Defensive tool used in combat'),
    ('NORDIC RUNES', 'Ancient alphabet used by Vikings'),
    ('IRON HELMET', 'Protective gear worn in battles'),
    ('CERAMIC', 'Pottery and ceramic artifacts'),
    ('GOLD OBJECT', 'Valuable items made of gold'),
    ('BRONZE OBJECT', 'Artifacts made of bronze'),
    ('SILVER OBJECT', 'Artifacts made of silver'),
    ('ARCHERY', 'Tools or weapons related to bows and arrows'),
    ('RELIGIOUS ARTIFACT', 'Objects used for religious purposes'),
    ('TRADE GOODS', 'Items used in historical trade'),
    ('TOOLS', 'Various tools used in ancient times'),
    ('HUMAN REMAINS', 'Bones or skeletal remains from ancient humans');

 

 

INSERT INTO grant_proposal(title, description, amount, date, status)
VALUES
    ('Grant For Viking Settlement Research', 'Funding To Investigate Viking Settlements In Scandinavia', 125000.00, '2005-12-23', 'PENDING'),
    ('Birka Dig', 'Grant For Excavations On The Island Of Birka In Lake Mälaren', 850000.00, '2015-05-13', 'ACCEPTED'),
    ('Archaeological Survey', 'Grant For Underwater Archaeological Research And Surveying', 500000.00, '2020-08-01', 'PENDING'),
    ('Nordic Language Preservation', 'Funding To Support The Study And Preservation Of Ancient Nordic Languages', 150000.00, '2017-03-19', 'REJECTED'),
    ('Museum Exhibition', 'Funding For A Large-Scale Exhibition Of Ancient Viking Artifacts', 2000000.00, '2022-11-30', 'ACCEPTED'),
    ('Viking Research Center', 'Establishing A Research Facility Dedicated To Viking Era Studies', 3500000.00, '2021-06-15', 'PENDING'),
    ('Fossil Discovery Expedition', 'Grant To Support A Fossil Digging Expedition In Northern Sweden', 900000.00, '2019-02-10', 'ACCEPTED'),
    ('Historical Document Preservation', 'Funding To Preserve And Digitize Ancient Scandinavian Manuscripts', 600000.00, '2018-07-20', 'PENDING'),
    ('Viking Ship Restoration', 'Grant For The Restoration And Display Of An Ancient Viking Ship', 1200000.00, '2023-01-05', 'ACCEPTED'),
    ('Viking Tools Research', 'Funding To Reconstruct And Study Viking-Era Tools And Technologies', 400000.00, '2024-04-12', 'REJECTED');

 

INSERT INTO dig (location, start_date, end_date, grant_proposal_no)
VALUES
    ('BIRKA', '2017-09-15', '2019-12-12', 5),
    ('LAPPLAND', '2020-03-10', '2021-07-25', 2),
    ('GOTLAND', '2018-05-05', '2019-08-20', 4),
    ('ÖLAND', '2022-04-11', '2023-06-30', 1),
    ('UPPSALA', '2016-06-01', '2017-08-18', 9),
    ('DALARNA', '2021-09-15', '2022-12-01', 7);


INSERT INTO artifact (description, grid, depth, date_found, current_location, shelf_no, dig_no, term)
VALUES
    ('Bronze Spearhead with markings', 'A/12', 2.50, '2023-02-15', 'WAREHOUSE', '1A', 1, 'BRONZE OBJECT'),
    ('Stone Tablet with ancient runes', 'B/73', 3.20, '2023-03-10', 'WAREHOUSE', '77B', 1, 'NORDIC RUNES'),
    ('Medieval Sword Fragment', 'C/45', 1.75, '2023-03-20', 'LAB', '28C', 2, 'MEDIEVAL SWORD'),
    ('Viking Shield Boss with ornate patterns', 'D/18', 2.10, '2023-03-25', 'DISPLAYED', '124A', 2, 'SHIELD'),
    ('Iron Nail from Roman ruins', 'E/29', 4.00, '2023-04-05', 'LAB', '2B', 3, 'IRON HELMET'),
    ('Ceramic Vase Shard with decorative symbols', 'F/33', 2.25, '2023-04-12', 'WAREHOUSE', '18A', 3, 'CERAMIC'),
    ('Gold-plated Bracelet from burial site', 'G/40', 3.10, '2023-05-01', 'DISPLAYED', '5C', 4, 'GOLD OBJECT'),
    ('Bone Comb with Viking carvings', 'H/3', 2.40, '2023-05-15', 'WAREHOUSE', '33B', 4, 'RELIGIOUS ARTIFACT'),
    ('Silver Coin with Roman emblem', 'I/25', 3.30, '2023-06-01', 'LAB', '8A', 5, 'SILVER OBJECT'),
    ('Clay Tablet with early Sumerian inscriptions', 'J/17', 2.00, '2023-06-12', 'DISPLAYED', '12B', 5, 'TRADE GOODS'),
    ('Bronze Helmet with intricate etchings', 'K/5', 3.10, '2023-06-20', 'LAB', '3C', 6, 'BRONZE OBJECT'),
    ('Iron Shield Fragment from Viking era', 'L/13', 2.80, '2023-06-25', 'DISPLAYED', '21A', 5, 'SHIELD'),
    ('Wooden Comb with Nordic symbols', 'M/42', 1.90, '2023-07-01', 'WAREHOUSE', '15B', 3, 'NORDIC RUNES'),
    ('Gold Earring from burial mound', 'N/8', 2.40, '2023-07-15', 'DISPLAYED', '7C', 4, 'GOLD OBJECT'),
    ('Clay Pot Shard with ancient markings', 'O/17', 1.50, '2023-07-25', 'WAREHOUSE', '13A', 2, 'CERAMIC'),
    ('Stone Knife from prehistoric times', 'P/34', 3.30, '2023-08-05', 'LAB', '28A', 1, 'TOOLS'),
    ('Carved Bone Fragment', 'Q/19', 2.60, '2023-08-10', 'WAREHOUSE', '5B', 6, 'HUMAN REMAINS'),
    ('Silver Ring with Roman numerals', 'R/11', 1.80, '2023-08-20', 'DISPLAYED', '34C', 4, 'SILVER OBJECT'),
    ('Bronze Dagger with worn blade', 'S/22', 3.00, '2023-08-30', 'WAREHOUSE', '17A', 3, 'BRONZE OBJECT'),
    ('Iron Arrowhead from Viking site', 'T/4', 2.90, '2023-09-10', 'LAB', '25B', 2, 'VIKING AXE'),
    ('Roman Amphora Fragment', 'U/29', 3.50, '2023-09-15', 'DISPLAYED', '41C', 1, 'BRONZE OBJECT'),
    ('Prehistoric Flint Axe', 'V/18', 2.20, '2023-09-25', 'WAREHOUSE', '10A', 5, 'VIKING AXE'),
    ('Gold Brooch with detailed patterns', 'W/33', 3.40, '2023-10-01', 'LAB', '12B', 6, 'GOLD OBJECT'),
    ('Bone Needle from ancient times', 'X/21', 2.10, '2023-10-15', 'DISPLAYED', '22A', 3, 'HUMAN REMAINS'),
    ('Wooden Tool with carved symbols', 'Y/14', 1.70, '2023-10-20', 'WAREHOUSE', '11B', 4, 'TOOLS'),
    ('Silver Goblet with engraved imagery', 'Z/9', 4.00, '2023-10-25', 'LAB', '27C', 2, 'SILVER OBJECT'),
    ('Ceramic Plate Fragment', 'AA/7', 2.50, '2023-11-01', 'WAREHOUSE', '33A', 5, 'CERAMIC'),
    ('Stone Bowl with etched designs', 'BB/12', 3.10, '2023-11-10', 'DISPLAYED', '6C', 4, 'CERAMIC'),
    ('Iron Axe Head with rust patterns', 'CC/25', 2.80, '2023-11-20', 'WAREHOUSE', '19B', 1, 'VIKING AXE'),
    ('Gold Coin from Roman Empire', 'DD/3', 1.60, '2023-11-30', 'LAB', '8A', 6, 'GOLD OBJECT');


INSERT INTO slide (description, dig_no, term)
VALUES
    ('Introduktion till Arkeologi: Vad är Arkeologi?', 1, 'TOOLS'),
    ('De första civilisationerna och deras arkeologiska spår', 2, 'TRADE GOODS'),
    ('Gravfynd och deras betydelse inom arkeologi', 3, 'HUMAN REMAINS'),
    ('Metoder för datering: Kol-14 och dendrokronologi', 4, 'TOOLS'),
    ('Förhistorisk arkeologi: Människans tidiga utveckling', 5, 'HUMAN REMAINS'),
    ('Arkeologi och dess relation till andra vetenskaper', 6, 'RELIGIOUS ARTIFACT'),
    ('Fältarbete och utgrävningar: Arkeologens dagliga arbete', 3, 'TOOLS'),
    ('Stenåldern: Verktyg, bosättningar och livsstil', 2, 'TOOLS'),
    ('Bronzeålderns kulturarv och material', 1, 'BRONZE OBJECT'),
    ('Romerska imperiet och de arkeologiska resterna', 6, 'SILVER OBJECT'),
    ('Middelalderns arkeologi: Städer, slott och kloster', 6, 'MEDIEVAL SWORD'),
    ('Historiska utgrävningar: Pompeji och Herculaneum', 5, 'TRADE GOODS'),
    ('Arkeologiska metoder: Geofysiska undersökningar och kartläggning', 4, 'TOOLS'),
    ('Arkeologiska fynd: Från keramik till skelettrester', 1, 'CERAMIC'),
    ('Arkeologi och bevarandet av kulturarv: Etik och ansvar', 2, 'GOLD OBJECT');

 

INSERT INTO slide_loan (date_out, due_date, date_back, staff_no, slide_no)
VALUES
    ('2024-12-10', '2024-12-20', NULL, 2, 3),
    ('2024-12-06', '2024-12-16', '2024-12-15', 6, 6),
    ('2024-12-01', '2024-12-10', '2024-12-09', 1, 1),
    ('2024-12-18', '2024-12-28', NULL, 5, 7),
    ('2024-12-07', '2024-12-17', '2024-12-16', 8, 8),
    ('2024-12-12', '2024-12-22', NULL, 6, 12),
    ('2024-12-13', '2024-12-23', NULL, 3, 13),
    ('2024-12-08', '2024-12-18', '2024-12-17', 4, 9),
    ('2024-12-03', '2024-12-13', '2024-12-12', 3, 2),
    ('2024-12-05', '2024-12-15', '2024-12-14', 5, 5),
    ('2024-12-15', '2024-12-25', NULL, 8, 15),
    ('2024-12-11', '2024-12-21', NULL, 5, 11),
    ('2024-12-05', '2024-12-15', '2024-12-18', 3, 12),
    ('2024-12-14', '2024-12-24', NULL, 1, 14),
    ('2024-12-04', '2024-12-14', '2024-12-13', 4, 4),
    ('2024-12-01', '2024-12-10', '2024-12-12', 1, 13),
    ('2024-12-16', '2024-12-26', NULL, 7, 9),
    ('2024-12-09', '2024-12-19', '2024-12-18', 7, 10),
    ('2024-12-17', '2024-12-27', NULL, 4, 5);

   

INSERT INTO book_loan (date_out, due_date, date_back, staff_no, book_no)
VALUES
    ('2024-12-01', '2024-12-10', '2024-12-09', 8, 5),
    ('2024-12-03', '2024-12-13', NULL, 4, 7),        
    ('2024-12-05', '2024-12-15', '2024-12-14', 3, 4), 
    ('2024-12-07', '2024-12-17', NULL, 2, 2),        
    ('2024-12-09', '2024-12-19', '2024-12-18', 1, 6); 


INSERT INTO staff_grant_proposal (staff_no, grant_proposal_no)
VALUES
    (1, 1),
    (2, 3),
    (3, 5),
    (4, 2),
    (5, 4),
    (6, 6),
    (7, 8),
    (8, 10);

   
INSERT INTO staff_artifact (date, staff_no, item_no)
VALUES
	('2024-01-10', 1, 3),
    ('2024-02-14', 2, 5),
    ('2024-03-12', 3, 8),
    ('2024-04-20', 4, 12),
    ('2024-05-01', 5, 15);

   

INSERT INTO staff_dig (staff_no, dig_no)
VALUES
    (4, 3),
    (7, 4),
    (1, 1),
    (5, 1),
    (2, 6),
    (6, 1),
    (2, 1),
    (8, 3),
    (3, 1),
    (4, 5),
    (1, 2),
    (6, 4),
    (5, 3),
    (2, 2),
    (7, 2),
    (3, 2),
    (4, 1),
    (1, 5),
    (8, 4);

   
INSERT INTO staff_journal (date, staff_no, journal_no)
VALUES
    ('2024-01-15', 1, 1),
    ('2024-02-18', 2, 3),
    ('2024-03-20', 3, 4),
    ('2024-04-25', 4, 5),
    ('2024-05-10', 5, 7);

-- Vyer
/*
1. Artifact Report:
   Rapport som visar detaljer om alla artefakter
*/

GO
CREATE VIEW artifact_report AS
SELECT
    a.item_no AS 'Item number',
    a.description AS 'Description',
    a.grid AS 'Grid',
    a.depth AS 'Depth (m)',
    a.date_found AS 'Date Found',
    a.current_location AS 'Current location',
    a.shelf_no AS 'Shelf number',
    d.location AS 'Dig location',
	k.term AS 'Keyword'
FROM
    artifact as a
INNER JOIN
    dig d ON a.dig_no = d.dig_no
INNER JOIN
    keywords k ON a.term = k.term;
GO

/*
2. Slide Catalogue:
   En katalog över alla slides i databasen.
   Visar även vilken dig och vilket/vilka nyckelord varje slide är kopplad till
*/

GO
CREATE VIEW slide_catalogue AS
SELECT
    sl.slide_no AS 'Slide number',
    sl.description AS 'Description',
    d.location AS 'Dig location',
    k.term AS 'Keywords'
FROM
    slide as sl
INNER JOIN
    dig d ON sl.dig_no = d.dig_no
INNER JOIN
   keywords k ON sl.term = k.term
--GROUP BY
    --sl.slide_no, sl.description, d.location;
GO
/*
3. Slide Loan Report:
   Rapport som visar aktuella lån av slides.
   Sorterad efter förfallodatum stigande ordning
*/

GO
CREATE VIEW slide_loan_report AS
SELECT
    sl.slide_no AS 'Slide Number',
    CONCAT(st.first_name, ' ', st.last_name) AS 'Loanee',
    sl.date_out AS 'Date Out',
    sl.due_date AS 'Due Date'
FROM
    slide_loan AS sl
INNER JOIN
    slide AS s ON sl.slide_no = s.slide_no
INNER JOIN
    staff AS st ON sl.staff_no = st.staff_no
WHERE
    sl.date_back IS NULL
GO

-- Visar innehållet i de tre vyerna
SELECT * FROM artifact_report;
SELECT * FROM slide_catalogue;
SELECT * FROM slide_loan_report ORDER BY 'Due Date';