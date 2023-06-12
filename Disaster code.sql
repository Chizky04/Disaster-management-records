--CREATING ISO TABLE
CREATE TABLE Iso_table(
			Iso_code integer PRIMARY KEY,		
			ISO Text,
			country Text
)

--CREATING DISASTERS TABLE
CREATE TABLE Disasters_table(
			Start_year integer, 
			End_year integer,
			Disaster_group Text, 
			Disaster_subgroup Text, 
			Disaster_type Text, 
			Disaster_subtype Text, 
			Origin Text,
			Associated_disaster Text,
			OFDA_response_code Text,
			Disaster_magnitude_value integer,
			Iso_code integer,
			Location_id integer,
			FOREIGN KEY(Iso_code) REFERENCES Iso_table(Iso_code),
			FOREIGN KEY(Location_id) REFERENCES Location_table(Location_id)
)

--CREATING GEOLOCATION TABLE
CREATE TABLE Location_table(
			Location_id integer PRIMARY KEY, 		
			Locations Text, 
			Region Text, 
			Continent Text, 
			Latitude VARCHAR(50), 
			Longitude VARCHAR(50),
			Iso_code integer,
			FOREIGN KEY(Iso_code) REFERENCES Iso_table(Iso_code)
);


--CREATING DEATH RECORDS TABLE
CREATE TABLE Deaths_table(
			Years integer,
			Total_death integer, 
			No_injured integer,
			No_Affected integer, 
			No_homeless integer,
			Total_Affected integer,
			Total_damages integer,
			Total_damages_Adjusted integer,
			Location_id integer,
			FOREIGN KEY(Location_id) REFERENCES Location_table(Location_id)
			
);

SELECT * FROM deaths_table
SELECT * FROM disasters_table
SELECT * FROM iso_table
SELECT * FROM location_table

--Insights
--1.	The top 5 disaster type in the climate disasters database with the highest number of casualties
--2.	The average number of casualties per climate disaster
--3.	The total number of affected cases caused by climate disasters in all years
--4.	The climate disasters along with location information that occurred within the year 2000 and 2022
--5.	The year that recorded the highest death casualties,along with the location and country


----1.	Count the total number of climate disasters in the database
SELECT COUNT(*) AS total_disasters
FROM disasters_table;

----2.	Find the top 5 disaster type in the climate disasters database with the highest number of casualties
SELECT disaster_type, SUM(Total_death) AS Casualties 
FROM deaths_table det
JOIN location_table l
ON l.location_id = det.location_id
JOIN disasters_table dit
ON l.location_id = dit.location_id
GROUP BY disaster_type
ORDER BY Casualties DESC 
LIMIT 5; 


--3.	Calculate the average number of casualties per climate disaster
SELECT disaster_type, ROUND(AVG(Total_death)) AS Casualties 
FROM deaths_table det
JOIN location_table l
ON l.location_id = det.location_id
JOIN disasters_table dit
ON l.location_id = dit.location_id
GROUP BY disaster_type
ORDER BY Casualties DESC 


--4.	Get the total number of affected cases caused by climate disasters in all years
SELECT years, SUM(total_affected) AS Total_Affected 
FROM deaths_table
WHERE total_affected IS NOT NULL
GROUP BY years
ORDER BY Total_Affected DESC
--LIMIT 10


--5.	Retrieve the climate disasters along with location information that occurred within the year 2000 and 2022
SELECT disaster_type,locations,region, country,start_year, end_year
FROM Iso_table iso
JOIN location_table lo
ON iso.iso_code = lo.iso_code
JOIN disasters_table dit
ON lo.location_id = dit.location_id
WHERE start_year >= 2000 AND end_year <= 2022

---6.	Retrieve the year that recorded the highest death casualties,along with the location and country
SELECT country,locations,years,total_death AS Total_casualties
FROM Iso_table iso
JOIN location_table lo
ON iso.iso_code = lo.iso_code
JOIN deaths_table det
ON lo.location_id = det.location_id
WHERE total_death IS NOT NULL
ORDER BY total_casualties DESC
--LIMIT 1;


--7.	Find the country that recorded the highest occurences of casualties in the climate disasters Database including information about the disaster type
SELECT country, disaster_type, Disaster_subtype, Disaster_group, Disaster_subgroup, COUNT(*) AS Total_casualties
FROM iso_table
JOIN disasters_table
USING(iso_code)
GROUP BY country,disaster_type,Disaster_subtype,Disaster_group,Disaster_subgroup
ORDER BY Total_casualties DESC 
LIMIT 1; 

--8.	Retrieve the top 5 disaster subtypes that recorded the highest occurences of casualties
SELECT  Disaster_subtype, COUNT(*) AS Occurence_count
FROM disasters_table
WHERE Disaster_subtype IS NOT NULL
GROUP BY Disaster_subtype
ORDER BY Occurence_count DESC 
LIMIT 5; 


--9.	Retrieve the climate disasters that occurred in Western Asia
SELECT region, disaster_type, start_year, end_year 
FROM location_table
JOIN disasters_table
using(location_id)
WHERE region ILIKE '%Western Asia%' OR region ILIKE '%Western_Asia%'; 

--10.	Determine the most common type of climate disaster in the database
SELECT disaster_type, COUNT(*) AS Occurrence_count 
FROM disasters_table 
GROUP BY disaster_type 
ORDER BY Occurrence_count DESC 
LIMIT 1; 







