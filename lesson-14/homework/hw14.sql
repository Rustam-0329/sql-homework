



-- Medium tasks

--(1) Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)
SELECT 
    SUBSTRING('rtcfvty34redt', PATINDEX('%[0-9]%', 'rtcfvty34redt'), 
              PATINDEX('%[^0-9]%', SUBSTRING('rtcfvty34redt', PATINDEX('%[0-9]%', 'rtcfvty34redt'), LEN('rtcfvty34redt'))) - 1) AS Digits,
    REPLACE(TRANSLATE('rtcfvty34redt', '0123456789', REPLICATE(' ', 10)), ' ', '') AS Chars


--(2) Write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
SELECT 
    w1.RecordDate,
    w1.Temperature,
    w2.Temperature AS PreviousTemperature
FROM weather w1
INNER JOIN weather w2
    ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature
ORDER BY w1.RecordDate;

--(3) Write an SQL query that reports the first login date for each player.(Activity)
SELECT 
    player_id,
    MIN(event_date) AS FirstLoginDate
FROM Activity
GROUP BY player_id
ORDER BY player_id;

--(4) Your task is to return the third item from that list.(fruits)
SELECT 
    CASE 
        WHEN CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) > 0  --CHARINDEX(',', fruit_list) finds the position of the first comma	
        THEN LTRIM(RTRIM(													 --CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) finds the position of the second comma, starting after the first.
            SUBSTRING(														 --LTRIM(RTRIM(...)): Removes leading/trailing spaces (e.g., for 'apple, banana, orange').
                fruit_list, 
                CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1,   --CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1 is the position after the second comma (start of the third item)
                CHARINDEX(',', fruit_list + ',',           --CHARINDEX(',', fruit_list + ',', ...) finds the position of the next comma (or the appended comma at the end), ensuring we capture the end of the third item.
                    CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1) - 
                    CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) - 1
            )
        ))
        ELSE NULL
    END AS ThirdFruit
FROM fruits;

--(5) 
