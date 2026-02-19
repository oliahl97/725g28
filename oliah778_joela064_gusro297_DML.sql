-- Redovisar deluppgift 4. I denna fil visar ni funktionaliteten hos er struktur i användning genom att köra era formulerade frågor mot databasen. 
-- Queries
/*
1. Simpel query:
   Listar alla anställda i databasen, sorterade alfabetiskt efter efternamn
*/
SELECT
    staff_no AS 'Staff number',
    last_name AS 'Last name',
    first_name AS 'First name',
    phone_no AS 'Phone',
    email as 'Email'
FROM
    staff
ORDER BY                         
	last_name;
 
/*
2. Query med WHERE-villkor:
   Visar alla artefakter som hittats på platsen 'BIRKA',
   sorterade efter datum de hittades (nyast först)
*/
SELECT
    a.item_no AS 'Item number',
    a.description AS 'Description',
    d.location AS 'Dig location',
    a.date_found AS 'Date found',
    a.grid AS 'Grid',
    a.depth AS 'Depth (m)'
FROM
    artifact as a
INNER JOIN
    dig d ON a.dig_no = d.dig_no
WHERE
    d.location = 'BIRKA'
ORDER BY
    a.date_found DESC;

/*
3. Query med WHERE-villkor:
   Söker efter artefakter kopplade till ett specifikt nyckelord,
   t.ex. 'VIKING AXE'
*/
SELECT
    a.item_no AS 'Item number',
    a.description AS 'Description',
    a.current_location AS 'Current location',
    k.term AS 'Keywords'
FROM
    artifact as a
INNER JOIN
    keywords k ON a.term = k.term
WHERE
    a.term = 'VIKING AXE'
ORDER BY
    a.current_location;

   

/*
4. Query med aggregatfunktion:
   Räknar antalet anställda kopplade till varje utgrävning
   och sorterar resultaten från flest till minst
*/
SELECT
    d.location AS 'Dig location',
    COUNT(sd.staff_no) AS 'Number of staff'
FROM
    dig as d
INNER JOIN
    staff_dig sd ON d.dig_no = sd.dig_no
GROUP BY
    d.location
ORDER BY
    COUNT(sd.staff_no) DESC;