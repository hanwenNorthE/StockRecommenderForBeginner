# STEP 2 INSERT DATA 
# insert the selected stock details into table stock_details 
INSERT INTO stock_details(code,description) 
  VALUES('aapl','description1'), 
  ('abcd','description2'), 
  ('adro','description3'), 
  ('amzn','description4'), 
  ('asml','description5'), 
  ('baa','description6'), 
  ('bc','description7'), 
  ('bcacr','description8'), 
  ('bcc','description9'), 
  ('bcd','description10'), 
  ('bce','description11'), 
  ('bcei','description12'), 
  ('bch','description13'), 
  ('bcor','description14'), 
  ('bcpc','description15'), 
  ('bcr','description16'), 
  ('bcrh','description17'), 
  ('bcrx','description18'), 
  ('bcs_d','description19'), 
  ('brk-b','description20'), 
  ('corp','description21'), 
  ('fb','description22'), 
  ('googl','description23'), 
  ('jnj','description24'), 
  ('jpm_a','description25'), 
  ('mc','description26'), 
  ('msft','description27'), 
  ('nvda','description28'), 
  ('tsla','description29'), 
  ('v','description30'); 
   
#Insert related data into stocks according to stock's price_data 
INSERT INTO stocks (code, companyName, currentPrice, priceChange, marketValue, industry) 
SELECT  
    price_data.code,  
    'Unknown CompanyName', -- You can update this with actual company names 
    price_data.close AS currentPrice, 
    (price_data.close - COALESCE((SELECT close FROM price_data WHERE code = price_data.code ORDER 
BY date DESC LIMIT 1 OFFSET 1), price_data.close)) AS priceChange, 
    price_data.close * 1000000 AS marketValue, #Assuming 1,000,000 outstanding shares (replace with real 
data) 
    'Unknown Industry' 
FROM price_data 
WHERE price_data.date = (SELECT MAX(date) FROM price_data WHERE code = price_data.code); 
 
#update company name and industry 
UPDATE stocks 
SET companyName = CASE code 
    WHEN 'aapl' THEN 'Apple Inc.' 
    WHEN 'abcd' THEN 'Company ABCD' 
    WHEN 'adro' THEN 'Adaro Energy' 
    WHEN 'amzn' THEN 'Amazon.com, Inc.' 
    WHEN 'asml' THEN 'ASML Holding N.V.' 
    WHEN 'baa' THEN 'Company BAA' 
    WHEN 'bc' THEN 'Brunswick Corporation' 
    WHEN 'bcacr' THEN 'Company BCACR' 
    WHEN 'bcc' THEN 'Boise Cascade Company' 
    WHEN 'bcd' THEN 'Company BCD' 
    WHEN 'bce' THEN 'BCE Inc.' 
    WHEN 'bcei' THEN 'Company BCEI' 
    WHEN 'bch' THEN 'Banco de Chile' 
    WHEN 'bcor' THEN 'Blucora, Inc.' 
    WHEN 'bcpc' THEN 'Balchem Corporation' 
    WHEN 'bcr' THEN 'Company BCR' 
    WHEN 'bcrh' THEN 'Blue Capital Reinsurance Holdings Ltd.' 
    WHEN 'bcrx' THEN 'BioCryst Pharmaceuticals, Inc.' 
    WHEN 'bcs_d' THEN 'Company BCS_D' 
    WHEN 'brk-b' THEN 'Berkshire Hathaway Inc. Class B' 
    WHEN 'corp' THEN 'Company CORP' 
    WHEN 'fb' THEN 'Facebook, Inc.' 
    WHEN 'googl' THEN 'Alphabet Inc. Class A' 
    WHEN 'jnj' THEN 'Johnson & Johnson' 
    WHEN 'jpm_a' THEN 'Company JPM_A' 
    WHEN 'mc' THEN 'Moelis & Company' 
    WHEN 'msft' THEN 'Microsoft Corporation' 
    WHEN 'nvda' THEN 'NVIDIA Corporation' 
    WHEN 'tsla' THEN 'Tesla, Inc.' 
    WHEN 'v' THEN 'Visa Inc.' 
    ELSE companyName 
END, 
industry = CASE code 
    WHEN 'aapl' THEN 'Technology' 
    WHEN 'abcd' THEN 'Other' 
    WHEN 'adro' THEN 'Energy' 
    WHEN 'amzn' THEN 'Consumer Goods' 
    WHEN 'asml' THEN 'Technology' 
    WHEN 'baa' THEN 'Other' 
    WHEN 'bc' THEN 'Consumer Goods' 
    WHEN 'bcacr' THEN 'Other' 
    WHEN 'bcc' THEN 'Materials' 
    WHEN 'bcd' THEN 'Other' 
    WHEN 'bce' THEN 'Communication Services' 
    WHEN 'bcei' THEN 'Other' 
    WHEN 'bch' THEN 'Financials' 
    WHEN 'bcor' THEN 'Technology' 
    WHEN 'bcpc' THEN 'Materials' 
    WHEN 'bcr' THEN 'Other' 
    WHEN 'bcrh' THEN 'Finance' 
    WHEN 'bcrx' THEN 'Healthcare' 
    WHEN 'bcs_d' THEN 'Other' 
    WHEN 'brk-b' THEN 'Finance' 
    WHEN 'corp' THEN 'Other' 
    WHEN 'fb' THEN 'Communication Services' 
    WHEN 'googl' THEN 'Communication Services' 
    WHEN 'jnj' THEN 'Healthcare' 
    WHEN 'jpm_a' THEN 'Other' 
    WHEN 'mc' THEN 'Finance' 
    WHEN 'msft' THEN 'Technology' 
    WHEN 'nvda' THEN 'Technology' 
    WHEN 'tsla' THEN 'Consumer Goods' 
    WHEN 'v' THEN 'Finance' 
    ELSE industry 
END 
WHERE code IN ('aapl', 'abcd', 'adro', 'amzn', 'asml', 'baa', 'bc', 'bcacr',  
               'bcc', 'bcd', 'bce', 'bcei', 'bch', 'bcor', 'bcpc', 'bcr',  
               'bcrh', 'bcrx', 'bcs_d', 'brk-b', 'corp', 'fb', 'googl',  
               'jnj', 'jpm_a', 'mc', 'msft', 'nvda', 'tsla', 'v'); 

SELECT * FROM users; 
-- Insert 100 users with random names, emails, and link them to preferences and portfolios 
SET @row_number = 0; 
INSERT INTO users (email, password, firstName, lastName, middleName) 
SELECT  
    CONCAT('user', (@row_number := @row_number + 1), '@example.com') AS email,  -- Ensure unique user 
emails 
    MD5(CONCAT('password', @row_number)) AS password,  -- Ensure unique passwords 
    ELT(1 + FLOOR(RAND() * 10), 'Alice', 'Bob', 'Charlie', 'David', 'Emma', 'Frank', 'Grace', 'Henry', 'Ivy', 
'Jack') AS firstName, 
    ELT(1 + FLOOR(RAND() * 10), 'Smith', 'Johnson', 'Brown', 'Williams', 'Jones', 'Garcia', 'Miller', 'Davis', 
'Rodriguez', 'Martinez') AS lastName, 
    IF(RAND() > 0.7, NULL, ELT(1 + FLOOR(RAND() * 5), 'Lee', 'Ann', 'James', 'Marie', 'Paul')) AS 
middleName 
    #user_pref.id,  -- Assign a valid preference_id 
    #(SELECT id FROM portfolios ORDER BY RAND() LIMIT 1) AS portfolio_id  -- Randomly select a 
portfolio for each user 
FROM  
  (SELECT @row_number := 0) AS init,  -- Initialize row counter 
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) a, 
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) b 
LIMIT 100; 
 
    #(SELECT id FROM user_preferences ORDER BY RAND() LIMIT 1),  -- Pick an existing preference_id 
    #(SELECT id FROM portfolios ORDER BY RAND() LIMIT 1)         -- Pick an existing portfolio_id 
#FROM (SELECT 1 AS id UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) 
AS temp  -- Assign alias 'id' 
#LIMIT 100; 
 
SELECT * FROM portfolios; 
-- Insert 100 portfolios with random cash balances 
INSERT INTO portfolios (users_id, cashBalance) 
SELECT id, ROUND(RAND() * 10000, 2) AS cashBalance 
FROM users; 
 
SELECT * FROM user_preferences 
ORDER BY user_id; 
-- Insert 100 user preferences with random risk levels for each user 
INSERT INTO user_preferences (user_id, riskLevel) 
SELECT  
    u.id AS user_id,  -- Get user_id from the users table 
    ELT(1 + FLOOR(RAND() * 3), 'LOW', 'MEDIUM', 'HIGH') AS riskLevel  -- Randomly select a risk level 
(LOW, MEDIUM, HIGH) 
FROM users u 
JOIN (SELECT 1 AS preference UNION SELECT 2 UNION SELECT 3) AS temp  -- Creates 3 entries per 
user 
ORDER BY RAND()  -- Randomize the order of user preferences 
LIMIT 300; 
 
SELECT * FROM user_industries 
ORDER BY preference_id ASC; 
-- -- Insert random industries into the user_industries table ensuring each preference_id has 3 unique industries. 
-- Set counter variables to manage row numbering 
-- SET @counter := 0; 
-- SET @prev_preference_id := NULL; 
INSERT INTO user_industries (preference_id, industry) 
SELECT new_data.preference_id, new_data.industry 
FROM ( 
    SELECT  
        up.id AS preference_id,  -- Corrected alias for user_preferences 
        ELT(1 + FLOOR(RAND() * 8),  
            'Technology', 'Healthcare', 'Finance', 'Energy',  
            'Communication Services', 'Consumer Goods', 'Materials', 'Other') AS industry 
    FROM user_preferences up  -- Use 'up' as alias for user_preferences table 
    ORDER BY RAND()  -- Randomize the order 
    LIMIT 1000 
) AS new_data 
LEFT JOIN user_industries ui  
    ON new_data.preference_id = ui.preference_id  
    AND new_data.industry = ui.industry 
WHERE ui.preference_id IS NULL;  -- Ensure no duplicates are inserted 
 
-- INSERT INTO user_industries (preference_id, industry)  
-- SELECT user_pref.id AS preference_id, industry 
-- FROM ( 
--     SELECT  
--         user_pref.id AS preference_id,  
--         ELT(1 + FLOOR(RAND() * 8),  
--             'Technology', 'Healthcare', 'Finance', 'Energy',  
--             'Communication Services', 'Consumer Goods', 'Materials', 'Other') AS industry 
--     FROM user_preferences user_pref  
--     ORDER BY RAND()  
--     LIMIT 100 
-- ) AS new_data 
-- LEFT JOIN user_industries ui  
-- ON new_data.preference_id = ui.preference_id AND new_data.industry = ui.industry 
-- WHERE ui.preference_id IS NULL; 
 
-- Inserting data into user_favorites with stock codes and company names 
INSERT INTO user_favorites (user_id, stock_code)  
VALUES  
    (1, 'aapl'), 
    (1, 'amzn'), 
    (1, 'msft'), 
    (2, 'googl'), 
    (2, 'tsla'), 
    (2, 'v'), 
    (3, 'nvda'), 
    (3, 'fb'), 
    (3, 'jnj'), 
    (4, 'brk-b'), 
    (4, 'bce'), 
    (4, 'bch'), 
    (5, 'bc'), 
    (5, 'adro'), 
    (5, 'asml'), 
    (6, 'aapl'), 
    (6, 'nvda'), 
    (6, 'fb'), 
    (7, 'msft'), 
    (7, 'tsla'), 
    (7, 'googl'), 
    (8, 'bcacr'), 
    (8, 'bcor'), 
    (8, 'bcc'), 
    (9, 'bce'), 
    (9, 'bcei'), 
    (9, 'bch'), 
    (10, 'bcrx'), 
    (10, 'bcpc'), 
    (10, 'bcr'), 
    (11, 'bcrh'), 
    (11, 'bcs_d'), 
    (11, 'brk-b'), 
    (12, 'corp'), 
    (12, 'jnj'), 
    (12, 'v'), 
    (13, 'tsla'), 
    (13, 'msft'), 
    (13, 'googl'), 
    (14, 'aapl'), 
    (14, 'nvda'), 
    (14, 'adro'), 
    (15, 'asml'), 
    (15, 'fb'), 
    (15, 'brk-b'), 
    (16, 'bce'), 
    (16, 'bcor'), 
    (16, 'msft'), 
    (17, 'bcacr'), 
    (17, 'bcrx'), 
    (17, 'bcei'), 
    (18, 'v'), 
    (18, 'jnj'), 
    (18, 'googl'), 
    (19, 'nvda'), 
    (19, 'aapl'), 
    (19, 'tsla'), 
    (20, 'bcpc'), 
    (20, 'bcr'), 
    (20, 'bch'), 
    (21, 'adro'), 
    (21, 'msft'), 
    (21, 'fb'), 
    (22, 'googl'), 
    (22, 'nvda'), 
    (22, 'brk-b'), 
    (23, 'jnj'), 
    (23, 'bce'), 
    (23, 'v'), 
    (24, 'corp'), 
    (24, 'bc'), 
    (24, 'bcei'), 
    (25, 'msft'), 
    (25, 'aapl'), 
    (25, 'fb'), 
    (26, 'tsla'), 
    (26, 'googl'), 
    (26, 'brk-b'), 
    (27, 'adro'), 
    (27, 'bcor'), 
    (27, 'nvda'), 
    (28, 'msft'), 
    (28, 'jnj'), 
    (28, 'v'), 
    (29, 'bce'), 
    (29, 'corp'), 
    (29, 'tsla'), 
    (30, 'googl'), 
    (30, 'brk-b'), 
    (30, 'nvda'), 
    (31, 'bcrx'), 
    (31, 'fb'), 
    (31, 'msft'), 
    (32, 'bcei'), 
    (32, 'jnj'), 
    (32, 'tsla'), 
    (33, 'aapl'), 
    (33, 'nvda'), 
    (33, 'bcor'), 
    (34, 'bcacr'), 
    (34, 'v'), 
    (34, 'bch'), 
    (35, 'adro'), 
    (35, 'msft'), 
    (35, 'googl'), 
    (36, 'fb'), 
    (36, 'brk-b'), 
    (36, 'jnj'), 
    (37, 'nvda'), 
    (37, 'corp'), 
    (37, 'tsla'), 
    (38, 'v'), 
    (38, 'aapl'), 
    (38, 'msft'), 
    (39, 'bc'), 
    (39, 'bcei'), 
    (39, 'brk-b'), 
    (40, 'adro'), 
    (40, 'googl'), 
    (40, 'nvda'), 
    (41, 'bcrx'), 
    (41, 'fb'), 
    (41, 'v'), 
    (42, 'msft'), 
    (42, 'aapl'), 
    (42, 'corp'), 
    (43, 'bce'), 
    (43, 'tsla'), 
    (43, 'bcor'), 
    (44, 'googl'), 
    (44, 'nvda'), 
    (44, 'brk-b'), 
    (45, 'fb'), 
    (45, 'jnj'), 
    (45, 'bch'), 
    (46, 'bce'), 
    (46, 'v'), 
    (46, 'corp'), 
    (47, 'nvda'), 
    (47, 'bcei'), 
    (47, 'adro'), 
    (48, 'tsla'), 
    (48, 'aapl'), 
    (48, 'msft'), 
    (49, 'bcacr'), 
    (49, 'bcrx'), 
    (49, 'googl'), 
    (50, 'v'), 
    (50, 'fb'), 
    (50, 'jnj'), 
    (51, 'msft'), 
    (51, 'aapl'), 
    (51, 'tsla'), 
    (52, 'adro'), 
    (52, 'nvda'), 
    (52, 'bcor'), 
    (53, 'googl'), 
    (53, 'bce'), 
    (53, 'brk-b'), 
    (54, 'aapl'), 
    (54, 'fb'), 
    (54, 'msft'), 
    (55, 'nvda'), 
    (55, 'v'), 
    (55, 'jnj'), 
    (56, 'bcacr'), 
    (56, 'bcei'), 
    (56, 'bch'), 
    (57, 'googl'), 
    (57, 'tsla'), 
    (57, 'adro'), 
    (58, 'fb'), 
    (58, 'nvda'), 
    (58, 'brk-b'), 
    (59, 'aapl'), 
    (59, 'msft'), 
    (59, 'googl'), 
    (60, 'jnj'), 
    (60, 'tsla'), 
    (60, 'bcei'); 

#Load data into stock's price data 
 
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/aapl.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'aapl',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/abcd.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'abcd',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/adro.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'adro',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
#Load all selected stock txt data into price data 
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/amzn.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'amzn',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/asml.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'asml',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
 
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/baa.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'baa',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bc.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bc',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcacr.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcacr',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcc.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcc',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcd.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcd',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bce.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bce',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcei.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcei',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
 
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bch.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bch',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
 
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcor.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcor',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcpc.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcpc',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcr.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcr',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcrh.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcrh',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcrx.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcrx',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/bcs_d.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'bcs_d',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/brk-b.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'brk-b',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/corp.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'corp',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/fb.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'fb',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/googl.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'googl',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/jnj.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'jnj',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/jpm_a.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'jpm_a',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/mc.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'mc',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/msft.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'msft',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/nvda.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'nvda',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/tsla.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'tsla',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
     
LOAD DATA LOCAL INFILE '/Users/anne/Desktop/data/v.us.txt' 
INTO TABLE price_data 
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS -- Skip the header row 
(@date, @open, @high, @low, @close, @volume, @openInt) 
SET  
    code = 'v',  -- Manually setting the stock code from the filename 
    date = STR_TO_DATE(@date, '%Y-%m-%d'), 
    open = @open, 
    high = @high, 
    low = @low, 
    close = @close, 
    volume = @volume, 
    openInt = @openInt; 
 
 