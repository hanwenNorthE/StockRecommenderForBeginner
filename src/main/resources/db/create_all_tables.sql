CREATE SCHEMA IF NOT EXISTS StockRecommender; 
 
DROP TABLE IF EXISTS ai_chat_messages; 
DROP TABLE IF EXISTS ai_chat_sessions; 
DROP TABLE IF EXISTS holdings; 
DROP TABLE IF EXISTS user_favorites; 
DROP TABLE IF EXISTS stock_news; 
DROP TABLE IF EXISTS price_data; 
DROP TABLE IF EXISTS stock_details; 
DROP TABLE IF EXISTS user_industries; 
DROP TABLE IF EXISTS user_preferences; 
DROP TABLE IF EXISTS portfolios; 
DROP TABLE IF EXISTS users; 
DROP TABLE IF EXISTS stocks; 
 
-- SELECT * FROM holdings; 
-- SELECT * FROM stock_news; 
-- SELECT * FROM ai_chat_sessions; 
-- SELECT * FROM ai_chat_messages; 
 
CREATE TABLE stocks ( 
  code VARCHAR(50) NOT NULL, 
  companyName VARCHAR(255), 
  currentPrice DOUBLE, 
  priceChange DOUBLE, 
  marketValue DOUBLE, 
  industry VARCHAR(50), 
  CONSTRAINT pk_stocks_code PRIMARY KEY (code) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE users ( 
  id BIGINT NOT NULL AUTO_INCREMENT, 
  email VARCHAR(255), 
  password VARCHAR(255), 
  firstName VARCHAR(100), 
  lastName VARCHAR(100), 
  middleName VARCHAR(100), 
  PRIMARY KEY (id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE portfolios ( 
  id BIGINT NOT NULL AUTO_INCREMENT, 
  users_id BIGINT NOT NULL, 
  cashBalance DOUBLE, 
  PRIMARY KEY (id), 
  FOREIGN KEY (users_id) REFERENCES users(id) on DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE user_preferences ( 
  id BIGINT NOT NULL AUTO_INCREMENT, 
  user_id BIGINT NOT NULL, 
  riskLevel ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL, 
  #marketSector VARCHAR(100) NOT NULL, 
  PRIMARY KEY (id), 
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE user_industries ( 
  preference_id BIGINT NOT NULL, 
  industry VARCHAR(100) NOT NULL, 
  PRIMARY KEY (preference_id, industry), 
  FOREIGN KEY (preference_id) REFERENCES user_preferences(id) ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE user_favorites ( 
  user_id BIGINT NOT NULL, 
  stock_code VARCHAR(50) NOT NULL, 
  PRIMARY KEY (user_id, stock_code), 
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, 
  FOREIGN KEY (stock_code) REFERENCES stocks(code) ON DELETE CASCADE 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE stock_details (  
  #stockDetailsId BIGINT NOT NULL AUTO_INCREMENT, 
  code VARCHAR(50) NOT NULL,  
  description TEXT, 
  CONSTRAINT pk_stock_details_code PRIMARY KEY (code) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE price_data ( 
  priceDataId BIGINT NOT NULL AUTO_INCREMENT, 
  code VARCHAR(50), #codestock_detail_id BIGINT, #To store the filename as the stock code 
  date DATETIME, 
  open DOUBLE, 
  high DOUBLE, 
  low DOUBLE, 
  close DOUBLE, 
  volume BIGINT, 
  OpenInt INT, 
  CONSTRAINT pk_price_data_priceDataId PRIMARY KEY (priceDataId), 
  CONSTRAINT fk_price_data_code FOREIGN KEY(code) REFERENCES stock_details(code) 
  ON UPDATE CASCADE ON DELETE SET NULL 
  #FOREIGN KEY (stock_detail_id) REFERENCES stock_details(id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE stock_news ( 
  id BIGINT NOT NULL AUTO_INCREMENT, 
  code VARCHAR(50), #stock_detail_id BIGINT, 
  title VARCHAR(255), 
  summary TEXT, 
  url VARCHAR(255), 
  publishDate DATETIME, 
  PRIMARY KEY (id), 
  FOREIGN KEY (code) REFERENCES stock_details(code) #id—>code 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE holdings ( 
  id BIGINT NOT NULL AUTO_INCREMENT, 
  portfolio_id BIGINT, 
  stock_code VARCHAR(50), 
  quantity INT, 
  PRIMARY KEY (id), 
  FOREIGN KEY (portfolio_id) REFERENCES portfolios(id), 
  FOREIGN KEY (stock_code) REFERENCES stocks(code) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE ai_chat_sessions ( 
  sessionId VARCHAR(255) NOT NULL, 
  PRIMARY KEY (sessionId) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
 
CREATE TABLE ai_chat_messages ( 
  id BIGINT NOT NULL AUTO_INCREMENT, 
  session_id VARCHAR(255), 
  sender VARCHAR(100), 
  message TEXT, 
  timestamp DATETIME, 
  PRIMARY KEY (id), 
  FOREIGN KEY (session_id) REFERENCES ai_chat_sessions(sessionId) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;