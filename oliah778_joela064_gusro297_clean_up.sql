-- Redovisar deluppgift 5 i en skript-fil för att tömma era tabeller på innehåll och ta bort allt ni skapat i er DDL-fil från databasen.

DELETE FROM slide_loan;
DELETE FROM book_loan;
DELETE FROM staff_journal;
DELETE FROM staff_dig;
DELETE FROM staff_artifact;
DELETE FROM staff_grant_proposal;
DELETE FROM artifact;
DELETE FROM slide;

DELETE FROM dig;

DELETE FROM book;
DELETE FROM journal;
DELETE FROM staff;
DELETE FROM keywords;
DELETE FROM grant_proposal;

DROP VIEW IF EXISTS artifact_report;
DROP VIEW IF EXISTS slide_catalogue;
DROP VIEW IF EXISTS slide_loan_report;

DROP TABLE IF EXISTS slide_loan, book_loan, staff_journal, staff_dig, staff_artifact, staff_grant_proposal, artifact, slide;
DROP TABLE IF EXISTS dig;
DROP TABLE IF EXISTS book, journal, staff, keywords, grant_proposal;
