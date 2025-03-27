package com.example.service;

import com.example.dao.StockDao;
import com.example.model.Industry;
import com.example.model.Stock;
import com.example.model.StockDetail;
import com.example.dao.StockDetailDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StockService {
    
    private final StockDao stockDao;
    private final StockDetailDao stockDetailDao;
    private final RestTemplate restTemplate;
    
    @Value("${alphavantage.api.key}")
    private String alphaVantageApiKey;
    
    @Autowired
    public StockService(StockDao stockDao, StockDetailDao stockDetailDao) {
        this.stockDao = stockDao;
        this.stockDetailDao = stockDetailDao;
        this.restTemplate = new RestTemplate();
    }
    
    // search stock by keyword
    public List<Stock> searchStock(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return stockDao.search(keyword);
    }
    
    // get stock detail
    public StockDetail getStockDetail(String stockCode) {
        return stockDetailDao.findByStockCode(stockCode);
    }
    
    // get hot stocks
    public List<Stock> getHotStocks() {
        try {
            // get the top 5 stocks with the highest price change
            List<Stock> hotStocks = stockDao.findByPriceChangeGreaterThan(0);
            return hotStocks.size() > 5 ? hotStocks.subList(0, 5) : hotStocks;
        } catch (Exception e) {
            // if the database query fails, return simulated data
            List<Stock> hotStocks = new ArrayList<>();
            
            hotStocks.add(new Stock("AAPL", "Apple Inc.", 150.25, 2.35, 2.45e12, "Technology"));
            hotStocks.add(new Stock("MSFT", "Microsoft Corporation", 290.17, 1.89, 2.2e12, "Technology"));
            hotStocks.add(new Stock("GOOGL", "Alphabet Inc.", 2750.28, 15.67, 1.83e12, "Communication Services"));
            hotStocks.add(new Stock("AMZN", "Amazon.com, Inc.", 3380.05, -12.34, 1.71e12, "Consumer Goods"));
            hotStocks.add(new Stock("TSLA", "Tesla, Inc.", 725.60, 8.96, 7.33e11, "Consumer Goods"));
            
            return hotStocks;
        }
    }
    
    // find all stocks
    public List<Stock> findAllStocks() {
        return stockDao.findAll();
    }
    
    // find stocks by industry
    public List<Stock> findByIndustry(String industry) {
        return stockDao.findByIndustry(industry);
    }
    
    // get stock detail
    public Stock getStock(String code) {
        return stockDao.findById(code).orElse(null);
    }
    
    /**
     * Get stock time series data from Alpha Vantage API
     * @param stockCode the stock code/symbol
     * @param timeframe the timeframe (daily, weekly, monthly)
     * @return a map containing time series data
     */
    @Cacheable(value = "stockTimeSeries", key = "#stockCode + '-' + #timeframe")
    public Map<String, Object> getStockTimeSeries(String stockCode, String timeframe) {
        // Sanitize the stock code
        String sanitizedStockCode = stockCode;
        if (sanitizedStockCode == null || sanitizedStockCode.isEmpty()) {
            return createErrorResponse("Invalid stock symbol: " + stockCode);
        }
        
        // 确保股票代码格式化为大写并移除空格
        sanitizedStockCode = sanitizedStockCode.trim().toUpperCase();
        System.out.println("Processing stock symbol: " + sanitizedStockCode);
        
        String function;
        StringBuilder urlBuilder = new StringBuilder("https://www.alphavantage.co/query?");
        
        // Determine the correct API function based on timeframe
        switch (timeframe) {
            case "daily":
                function = "TIME_SERIES_DAILY";
                urlBuilder.append(String.format("function=%s&symbol=%s&outputsize=compact", function, sanitizedStockCode));
                break;
            case "weekly":
                function = "TIME_SERIES_WEEKLY";
                urlBuilder.append(String.format("function=%s&symbol=%s", function, sanitizedStockCode));
                break;
            case "monthly":
                function = "TIME_SERIES_MONTHLY";
                urlBuilder.append(String.format("function=%s&symbol=%s", function, sanitizedStockCode));
                break;
            default:
                function = "TIME_SERIES_DAILY";
                urlBuilder.append(String.format("function=%s&symbol=%s&outputsize=compact", function, sanitizedStockCode));
        }
        
        // Add API key
        urlBuilder.append("&apikey=").append(alphaVantageApiKey);
        
        String apiUrl = urlBuilder.toString();
        System.out.println("Making Alpha Vantage API request: " + apiUrl);
        
        try {
            // Make the API request
            Map<String, Object> response = restTemplate.getForObject(apiUrl, Map.class);
            
            if (response != null) {
                // Print response keys for debugging
                System.out.println("API Response keys: " + response.keySet());
                
                // Check for error messages
                if (response.containsKey("Error Message")) {
                    System.out.println("Alpha Vantage API error: " + response.get("Error Message"));
                    return createErrorResponse("API error: " + response.get("Error Message"));
                }
                
                // Check for note (usually indicates API call limit reached)
                if (response.containsKey("Note")) {
                    System.out.println("Alpha Vantage API limit reached: " + response.get("Note"));
                    return createErrorResponse("API limit reached. Please try again later.");
                }
                
                // Check if we got information message
                if (response.containsKey("Information")) {
                    System.out.println("Alpha Vantage Information: " + response.get("Information"));
                    return createErrorResponse("API Information: " + response.get("Information"));
                }
                
                // Process and return the data
                return processTimeSeriesData(response, timeframe);
            } else {
                System.out.println("No response received from Alpha Vantage API");
                return createErrorResponse("No data received from API");
            }
        } catch (Exception e) {
            System.out.println("Exception when calling Alpha Vantage API: " + e.getMessage());
            e.printStackTrace();
            return createErrorResponse("Error fetching stock data: " + e.getMessage());
        }
    }
    
    /**
     * Sanitize stock symbol to ensure it's valid for Alpha Vantage API
     * @param symbol Raw stock symbol
     * @return Sanitized stock symbol
     */
    private String sanitizeStockSymbol(String symbol) {
        if (symbol == null || symbol.trim().isEmpty()) {
            return "";
        }
        
        // Remove any spaces and convert to uppercase
        String sanitized = symbol.trim().toUpperCase();
        
        // Remove any characters that aren't alphanumeric or dots
        sanitized = sanitized.replaceAll("[^A-Z0-9\\.]", "");
        
        return sanitized;
    }
    
    /**
     * Process the raw time series data from Alpha Vantage API
     * @param apiResponse the raw API response
     * @param timeframe the timeframe (daily, weekly, monthly)
     * @return a processed map containing time series data
     */
    private Map<String, Object> processTimeSeriesData(Map<String, Object> apiResponse, String timeframe) {
        Map<String, Object> result = new HashMap<>();
        
        // Determine the time series key based on timeframe
        String timeSeriesKey;
        switch (timeframe) {
            case "daily":
                timeSeriesKey = "Time Series (Daily)";
                break;
            case "weekly":
                timeSeriesKey = "Weekly Time Series";
                break;
            case "monthly":
                timeSeriesKey = "Monthly Time Series";
                break;
            default:
                timeSeriesKey = "Time Series (Daily)";
        }
        
        System.out.println("Looking for time series key: " + timeSeriesKey);
        
        // Check if the time series data exists
        if (!apiResponse.containsKey(timeSeriesKey)) {
            System.out.println("Time series key not found. Available keys: " + apiResponse.keySet());
            // If we received an Information message, it's likely API limit reached
            if (apiResponse.containsKey("Information")) {
                return createErrorResponse("API limit reached: " + apiResponse.get("Information"));
            }
            return createErrorResponse("No time series data found in the API response");
        }
        
        // Extract metadata and time series data
        result.put("metadata", apiResponse.get("Meta Data"));
        result.put("timeSeries", apiResponse.get(timeSeriesKey));
        result.put("success", true);
        
        return result;
    }
    
    /**
     * Create an error response map
     * @param errorMessage the error message
     * @return a map containing the error details
     */
    private Map<String, Object> createErrorResponse(String errorMessage) {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", errorMessage);
        return errorResponse;
    }
} 