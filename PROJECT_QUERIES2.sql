CREATE database Trial;
USE trial;

-- Tables in this database were created from csv files using the import wizard
SHOW tables;

SELECT * FROM playstore_review;
SELECT * FROM project_data;
DESCRIBE project_data;

-- Changing Last Updated Column from text data type to date
SELECT `Last Updated`, STR_TO_DATE(`Last Updated`, '%d-%m-%Y') AS Last_Updated FROM project_data;

-- Adding a New Column to extract date from the Last Updated date column
ALTER TABLE project_data 
ADD COLUMN	Last_Updated date;

-- Syntax to convert text to date format
UPDATE project_data 
SET Last_Updated = STR_TO_DATE(`Last Updated`, '%d-%m-%Y');

-- Disabling sql safe updates mode
SHOW VARIABLES LIKE "sql_safe_updates";
SET SQL_SAFE_UPDATES = 0; -- Disable safe update mode
SET SQL_SAFE_UPDATES = 1; -- Enable safe update mode

SELECT `Last Updated`, Last_Updated FROM project_data;

-- Deleting Last Updated Column
ALTER TABLE project_data 
DROP COLUMN	`Last Updated`;

SELECT * FROM project_data;

-- Changing Column names by replacing spaces with underscores
ALTER TABLE project_data 
RENAME COLUMN `Content Rating` TO Content_Rating;

ALTER TABLE project_data 
RENAME COLUMN `Current Ver` TO Current_Ver;

ALTER TABLE project_data 
RENAME COLUMN `Android Ver` TO Android_Ver;

-- SOLUTION TO QUESTIONS
-- 1. APPS WITH HIGHEST RATING
SELECT App, Rating FROM playstore_apps 
WHERE Rating = (SELECT MAX(Rating) FROM playstore_apps);

-- 2. NUMBER OF INSTALLS AND REVIEWS ORDER BY REVIEWS OF THE ABOVE APPS
SELECT App, Installs, Reviews FROM playstore_apps 
WHERE Rating = (SELECT MAX(Rating) FROM playstore_apps) 
ORDER BY Reviews DESC;

-- 3. APP WITH THE HIGHEST NUMBER OF REVIEWS
SELECT App, Category, Reviews FROM playstore_apps 
WHERE Reviews = (SELECT MAX(Reviews) FROM playstore_apps);

-- 4. TOTAL REVENUE GENERATED BY GOOGLE PLAYSTORE
SELECT SUM(Price * Installs) AS Total_Revenue FROM playstore_apps;

-- 5. CATEGORY WITH THE HIGHEST NUMBER OF INSTALLS
SELECT Category, SUM(Installs) AS Total_Installs from playstore_apps 
GROUP BY Category 
ORDER BY Total_Installs DESC 
LIMIT 1;

-- 6. GENRE WITH THE MOST NUMBER OF PUBLISHED APPS
SELECT Genres, COUNT(App) AS Total_Apps from playstore_apps 
GROUP BY Genres 
ORDER BY Total_Apps DESC 
LIMIT 1;

-- 7. LIST OF ALL GAMES ORDER BY NUMBER OF INSTALLS IN DESCENDING ORDER
SELECT DISTINCT App, Installs FROM playstore_apps 
WHERE Category = 'GAME' 
ORDER BY Installs DESC;

-- 8. LIST OF APPS THAT CAN WORK ON ANDROID VERSION 4.0.3 AND UP
SELECT App, Android_Ver from playstore_apps 
WHERE Android_Ver LIKE '%4.0.3 and up%';

-- 9. TOTAL NUMBER OF FREE AND PAID APPS
SELECT Type, COUNT(App) AS Total_Apps FROM playstore_apps 
GROUP BY type;

-- 10. BEST DATING APP
SELECT App, Reviews FROM playstore_apps 
WHERE Category = 'DATING' 
ORDER BY Reviews DESC 
LIMIT 1;

-- 11. NUMBER OF REVIEWS WITH POSITIVE SENTIMENT FOR 10 BEST FOODS FOR YOU
SELECT Sentiment, COUNT(Translated_Review) AS Total_Reviews FROM playstore_reviews 
WHERE Sentiment IN ('Positive', 'Negative') AND App LIKE '%10 Best Foods for You%' 
GROUP BY Sentiment;

-- 12. COMMENTS OF ASUS SUPERNOTE WITH BOTH SENTIENT POLARITY AND SUBJECTIVITY OF 1
SELECT App, Translated_Review, Sentiment_Polarity, Sentiment_Subjectivity FROM playstore_reviews 
WHERE App LIKE '%ASUS SuperNote%' AND Sentiment_Polarity = 1 AND Sentiment_Subjectivity = 1;

-- 13. NEUTRAL SENTIMENT REVIEWS FOR ABS TRAINING-BURN BELLY FAT
SELECT App, Sentiment FROM playstore_reviews 
WHERE App LIKE '%Abs Training-Burn belly fat%' AND Sentiment LIKE '%NEUTRAL%';

-- 14 NEGATIVE SENTIMENT REVIEWS FOR ADOBE ACROBAT READER
SELECT App, Sentiment, Sentiment_Polarity, Sentiment_Subjectivity FROM playstore_reviews 
WHERE App LIKE '%Adobe Acrobat Reader%' AND Sentiment LIKE '%Negative%';