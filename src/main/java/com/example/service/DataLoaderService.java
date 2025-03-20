package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DataLoaderService {

    private final JdbcTemplate jdbcTemplate;
    private static final String[] STOCK_CODES = {
            "aapl", "abcd", "adro", "amzn", "asml", "baa", "bc", "bcacr", "bcc", "bcd", 
            "bce", "bcei", "bch", "bcor", "bcpc", "bcr", "bcrh", "bcrx", "bcs_d", "brk-b", 
            "corp", "fb", "googl", "jnj", "jpm_a", "mc", "msft", "nvda", "tsla", "v"
    };

    @Autowired
    public DataLoaderService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    /**
     * 加载所有数据
     */
    @Transactional
    public void loadAllData() throws IOException {
        boolean success = true;
        StringBuilder errorMessages = new StringBuilder();
        
        try {
            System.out.println("===================== start loading all data =====================");
            
            // 1. 插入股票详情
            try {
                System.out.println("\n【step 1/9】insert stock details data...");
                insertStockDetails();
                System.out.println("stock details data inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("stock details data inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("stock details data inserted failed: " + e.getMessage());
            }
            
            // 2. 加载股票价格数据
            try {
                System.out.println("\n【step 2/9】load stock price data...");
                loadPriceData();
                System.out.println("stock price data loaded");
            } catch (Exception e) {
                success = false;
                errorMessages.append("stock price data loaded failed: ").append(e.getMessage()).append("\n");
                System.err.println("stock price data loaded failed: " + e.getMessage());
            }
            
            // 3. 插入stocks表数据
            try {
                System.out.println("\n【step 3/9】insert stock basic information...");
                insertStocksData();
                System.out.println("stock basic information inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("stock basic information inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("stock basic information inserted failed: " + e.getMessage());
            }
            
            // 4. 更新公司名称和行业
            try {
                System.out.println("\n【step 4/9】update company name and industry...");
                updateCompanyNameAndIndustry();
                System.out.println("company name and industry updated");
            } catch (Exception e) {
                success = false;
                errorMessages.append("company name and industry updated failed: ").append(e.getMessage()).append("\n");
                System.err.println("company name and industry updated failed: " + e.getMessage());
            }
            
            // 5. 插入用户数据
            try {
                System.out.println("\n【step 5/9】insert user data...");
                insertUsers();
                System.out.println("user data inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("user data inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("user data inserted failed: " + e.getMessage());
            }
            
            // 6. 插入投资组合数据
            try {
                System.out.println("\n【step 6/9】insert portfolio data...");
                insertPortfolios();
                System.out.println("portfolio data inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("portfolio data inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("portfolio data inserted failed: " + e.getMessage());
            }
            
            // 7. 插入用户偏好数据
            try {
                System.out.println("\n【step 7/9】insert user preferences data...");
                insertUserPreferences();
                System.out.println("user preferences data inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("user preferences data inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("user preferences data inserted failed: " + e.getMessage());
            }
            
            // 8. 插入用户行业偏好
            try {
                System.out.println("\n【step 8/9】insert user industries data...");
                insertUserIndustries();
                System.out.println("user industries data inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("user industries data inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("user industries data inserted failed: " + e.getMessage());
            }
            
            // 9. 插入用户收藏
            try {
                System.out.println("\n【step 9/9】insert user favorites data...");
                insertUserFavorites();
                System.out.println("user favorites data inserted");
            } catch (Exception e) {
                success = false;
                errorMessages.append("user favorites data inserted failed: ").append(e.getMessage()).append("\n");
                System.err.println("user favorites data inserted failed: " + e.getMessage());
            }
            
            System.out.println("\n===================== data loading process completed =====================");
            if (success) {
                System.out.println("all data loaded");
            } else {
                System.err.println("some errors occurred during data loading: \n" + errorMessages.toString());
                System.out.println("some data has been loaded, please check the database status.");
            }
            
        } catch (Exception e) {
            System.err.println("a serious error occurred during data loading: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("data loading failed", e);
        }
    }
    
    /**
     * 执行SQL文件中的特定部分
     */
    private void executeSqlSection(String sql) {
        // 分割SQL语句并执行每个语句
        Arrays.stream(sql.split(";"))
              .map(String::trim)
              .filter(statement -> !statement.isEmpty())
              .forEach(statement -> jdbcTemplate.execute(statement + ";"));
    }
    
    /**
     * 插入股票详情
     */
    private void insertStockDetails() throws IOException {
        try {
            // 首先检查表中是否已有数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stock_details", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("stock details data already exists, skip insertion...");
                return;
            }
            
            // 如果没有数据，则执行插入
            String sql = "INSERT INTO stock_details(code,description) VALUES";
            for (int i = 0; i < STOCK_CODES.length; i++) {
                sql += "('" + STOCK_CODES[i] + "','description" + (i+1) + "')";
                if (i < STOCK_CODES.length - 1) {
                    sql += ", ";
                }
            }
            jdbcTemplate.execute(sql);
        } catch (Exception e) {
            // 如果出现主键冲突等错误，则尝试使用INSERT IGNORE
            System.out.println("an error occurred during inserting stock details, trying to use INSERT IGNORE: " + e.getMessage());
            
            String sql = "INSERT IGNORE INTO stock_details(code,description) VALUES";
            for (int i = 0; i < STOCK_CODES.length; i++) {
                sql += "('" + STOCK_CODES[i] + "','description" + (i+1) + "')";
                if (i < STOCK_CODES.length - 1) {
                    sql += ", ";
                }
            }
            jdbcTemplate.execute(sql);
        }
    }
    
    /**
     * 加载所有股票价格数据
     */
    private void loadPriceData() throws IOException {
        // 首先检查是否已经有价格数据
        try {
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM price_data", Long.class);
            
            // 如果已有大量数据，则跳过加载
            if (count != null && count > 10000) {  // 设置一个阈值，表示已经加载了足够多的数据
                System.out.println("price data already exists (" + count + " records), skip loading...");
                return;
            }
            
            System.out.println("start loading price data...");
            for (String stockCode : STOCK_CODES) {
                try {
                    loadStockPriceData(stockCode);
                    System.out.println("successfully loaded price data of " + stockCode);
                } catch (Exception e) {
                    System.err.println("an error occurred during loading price data of " + stockCode + ": " + e.getMessage());
                    // 继续下一个股票，不中断整个过程
                }
            }
            System.out.println("price data loaded");
        } catch (Exception e) {
            System.err.println("an error occurred during checking price data: " + e.getMessage());
        }
    }
    
    /**
     * 加载单个股票的价格数据
     */
    private void loadStockPriceData(String stockCode) throws IOException {
        // 首先检查该股票是否已经有价格数据
        try {
            Long count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM price_data WHERE code = ?", 
                Long.class, 
                stockCode
            );
            
            // 如果该股票已有数据，则跳过
            if (count != null && count > 0) {
                System.out.println("stock " + stockCode + " already has " + count + " price data, skip...");
                return;
            }
            
            Resource resource = new ClassPathResource("data/" + stockCode + ".us.txt");
            if (!resource.exists()) {
                System.out.println("stock " + stockCode + " price data file does not exist, skip...");
                return;
            }
            
            try (Reader reader = new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8)) {
                String content = FileCopyUtils.copyToString(reader);
                
                // 跳过标题行
                List<String> lines = Arrays.stream(content.split("\n"))
                                           .skip(1)
                                           .collect(Collectors.toList());
                                           
                if (lines.isEmpty()) {
                    System.out.println("stock " + stockCode + " price data is empty, skip...");
                    return;
                }
                
                System.out.println("loading " + stockCode + " price data (" + lines.size() + " records)...");
                
                // 批量插入数据
                jdbcTemplate.batchUpdate(
                    "INSERT INTO price_data (code, date, open, high, low, close, volume, openInt) VALUES (?, STR_TO_DATE(?, '%Y-%m-%d'), ?, ?, ?, ?, ?, ?)",
                    lines,
                    lines.size(),
                    (ps, line) -> {
                        try {
                            String[] fields = line.split(",");
                            if (fields.length < 7) {
                                // 跳过格式不正确的行
                                throw new IllegalArgumentException("data line format is incorrect: " + line);
                            }
                            
                            ps.setString(1, stockCode);
                            ps.setString(2, fields[0].trim());
                            
                            try { ps.setDouble(3, Double.parseDouble(fields[1].trim())); } 
                            catch (NumberFormatException e) { ps.setDouble(3, 0.0); }
                            
                            try { ps.setDouble(4, Double.parseDouble(fields[2].trim())); } 
                            catch (NumberFormatException e) { ps.setDouble(4, 0.0); }
                            
                            try { ps.setDouble(5, Double.parseDouble(fields[3].trim())); } 
                            catch (NumberFormatException e) { ps.setDouble(5, 0.0); }
                            
                            try { ps.setDouble(6, Double.parseDouble(fields[4].trim())); } 
                            catch (NumberFormatException e) { ps.setDouble(6, 0.0); }
                            
                            try { ps.setLong(7, Long.parseLong(fields[5].trim())); } 
                            catch (NumberFormatException e) { ps.setLong(7, 0L); }
                            
                            try { ps.setInt(8, Integer.parseInt(fields[6].trim())); } 
                            catch (NumberFormatException e) { ps.setInt(8, 0); }
                        } catch (Exception e) {
                            System.err.println("an error occurred during processing data line: " + line + ", error: " + e.getMessage());
                            // 对于批处理，我们需要设置一些默认值以避免整个批处理失败
                            ps.setString(1, stockCode);
                            ps.setString(2, "1970-01-01"); // 默认日期
                            ps.setDouble(3, 0.0);
                            ps.setDouble(4, 0.0);
                            ps.setDouble(5, 0.0);
                            ps.setDouble(6, 0.0);
                            ps.setLong(7, 0L);
                            ps.setInt(8, 0);
                        }
                    }
                );
            }
        } catch (Exception e) {
            System.err.println("an error occurred during loading stock " + stockCode + " price data: " + e.getMessage());
            throw e; // 重新抛出异常，让调用者知道发生了错误
        }
    }
    
    /**
     * 插入股票数据
     */
    private void insertStocksData() {
        try {
            // 首先检查是否已经有数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM stocks", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("stock basic information already exists, skip insertion...");
                return;
            }
            
            String sql = "INSERT INTO stocks (code, companyName, currentPrice, priceChange, marketValue, industry) " +
                        "SELECT " +
                        "    price_data.code, " +
                        "    'Unknown CompanyName', " +
                        "    price_data.close AS currentPrice, " +
                        "    (price_data.close - COALESCE((SELECT close FROM price_data WHERE code = price_data.code ORDER BY date DESC LIMIT 1 OFFSET 1), price_data.close)) AS priceChange, " +
                        "    price_data.close * 1000000 AS marketValue, " +
                        "    'Unknown Industry' " +
                        "FROM price_data " +
                        "WHERE price_data.date = (SELECT MAX(date) FROM price_data WHERE code = price_data.code)";
            
            jdbcTemplate.execute(sql);
        } catch (Exception e) {
            System.out.println("an error occurred during inserting stock basic information: " + e.getMessage());
        }
    }
    
    /**
     * 更新公司名称和行业
     */
    private void updateCompanyNameAndIndustry() throws IOException {
        
        try {
            Resource resource = new ClassPathResource("db/load_data.sql");
            try (Reader reader = new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8)) {
                String content = FileCopyUtils.copyToString(reader);
                
                // 提取UPDATE语句
                int updateStart = content.indexOf("UPDATE stocks");
                int updateEnd = content.indexOf("SELECT * FROM users");
                
                if (updateStart >= 0 && updateEnd >= 0) {
                    String updateSql = content.substring(updateStart, updateEnd).trim();
                    executeSqlSection(updateSql);
                }
            }
        } catch (Exception e) {
            System.out.println("an error occurred during updating company name and industry: " + e.getMessage());
        }
    }
    
    /**
     * 插入用户数据
     */
    private void insertUsers() {
        try {
            // 首先检查是否已经有用户数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("user data already exists, skip insertion...");
                return;
            }
            
            String sql = "SET @row_number = 0; " +
                        "INSERT INTO users (email, password, firstName, lastName, middleName) " +
                        "SELECT " +
                        "    CONCAT('user', (@row_number := @row_number + 1), '@example.com') AS email, " +
                        "    MD5(CONCAT('password', @row_number)) AS password, " +
                        "    ELT(1 + FLOOR(RAND() * 10), 'Alice', 'Bob', 'Charlie', 'David', 'Emma', 'Frank', 'Grace', 'Henry', 'Ivy', 'Jack') AS firstName, " +
                        "    ELT(1 + FLOOR(RAND() * 10), 'Smith', 'Johnson', 'Brown', 'Williams', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez') AS lastName, " +
                        "    IF(RAND() > 0.7, NULL, ELT(1 + FLOOR(RAND() * 5), 'Lee', 'Ann', 'James', 'Marie', 'Paul')) AS middleName " +
                        "FROM " +
                        "    (SELECT @row_number := 0) AS init, " +
                        "    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) a, " +
                        "    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) b " +
                        "LIMIT 100";
            
            executeSqlSection(sql);
        } catch (Exception e) {
            System.out.println("an error occurred during inserting user data: " + e.getMessage());
        }
    }
    
    /**
     * 插入投资组合数据
     */
    private void insertPortfolios() {
        try {
            // 首先检查是否已经有投资组合数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM portfolios", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("portfolio data already exists, skip insertion...");
                return;
            }
            
            String sql = "INSERT INTO portfolios (users_id, cashBalance) " +
                        "SELECT id, ROUND(RAND() * 10000, 2) AS cashBalance " +
                        "FROM users";
            
            jdbcTemplate.execute(sql);
        } catch (Exception e) {
            System.out.println("an error occurred during inserting portfolio data: " + e.getMessage());
        }
    }
    
    /**
     * 插入用户偏好数据
     */
    private void insertUserPreferences() {
        try {
            // 首先检查是否已经有用户偏好数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM user_preferences", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("user preferences data already exists, skip insertion...");
                return;
            }
            
            String sql = "INSERT INTO user_preferences (user_id, riskLevel) " +
                        "SELECT " +
                        "    u.id AS user_id, " +
                        "    ELT(1 + FLOOR(RAND() * 3), 'LOW', 'MEDIUM', 'HIGH') AS riskLevel " +
                        "FROM users u " +
                        "JOIN (SELECT 1 AS preference UNION SELECT 2 UNION SELECT 3) AS temp " +
                        "ORDER BY RAND() " +
                        "LIMIT 300";
            
            jdbcTemplate.execute(sql);
        } catch (Exception e) {
            System.out.println("an error occurred during inserting user preferences data: " + e.getMessage());
        }
    }
    
    /**
     * 插入用户行业偏好
     */
    private void insertUserIndustries() {
        try {
            // 首先检查是否已经有用户行业偏好数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM user_industries", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("user industry preferences data already exists, skip insertion...");
                return;
            }
            
            String sql = "INSERT INTO user_industries (preference_id, industry) " +
                        "SELECT new_data.preference_id, new_data.industry " +
                        "FROM ( " +
                        "    SELECT " +
                        "        up.id AS preference_id, " +
                        "        ELT(1 + FLOOR(RAND() * 8), " +
                        "            'Technology', 'Healthcare', 'Finance', 'Energy', " +
                        "            'Communication Services', 'Consumer Goods', 'Materials', 'Other') AS industry " +
                        "    FROM user_preferences up " +
                        "    ORDER BY RAND() " +
                        "    LIMIT 1000 " +
                        ") AS new_data " +
                        "LEFT JOIN user_industries ui " +
                        "    ON new_data.preference_id = ui.preference_id " +
                        "    AND new_data.industry = ui.industry " +
                        "WHERE ui.preference_id IS NULL";
            
            jdbcTemplate.execute(sql);
        } catch (Exception e) {
            System.out.println("an error occurred during inserting user industry preferences data: " + e.getMessage());
        }
    }
    
    /**
     * 插入用户收藏
     */
    private void insertUserFavorites() throws IOException {
        try {
            // 首先检查是否已经有用户收藏数据
            Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM user_favorites", Long.class);
            
            // 如果已有数据，则跳过插入
            if (count != null && count > 0) {
                System.out.println("user favorites data already exists, skip insertion...");
                return;
            }
            
            Resource resource = new ClassPathResource("db/load_data.sql");
            try (Reader reader = new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8)) {
                String content = FileCopyUtils.copyToString(reader);
                
                // 提取INSERT INTO user_favorites语句
                int favoritesStart = content.indexOf("INSERT INTO user_favorites");
                int favoritesEnd = content.indexOf("LOAD DATA LOCAL INFILE");
                
                if (favoritesStart >= 0 && favoritesEnd >= 0) {
                    String favoritesSql = content.substring(favoritesStart, favoritesEnd).trim();
                    executeSqlSection(favoritesSql);
                }
            }
        } catch (Exception e) {
            System.out.println("an error occurred during inserting user favorites data: " + e.getMessage());
        }
    }
} 