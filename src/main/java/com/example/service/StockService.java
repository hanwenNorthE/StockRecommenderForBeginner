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
    
    @Value("${polygon.api.key}")
    private String polygonApiKey;
    
    @Value("${polygon.api.baseurl}")
    private String polygonBaseUrl;
    
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
     * Get stock time series data from Polygon.io API
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
        
        // Ensure stock code is formatted as uppercase and remove spaces
        sanitizedStockCode = sanitizedStockCode.trim().toUpperCase();
        System.out.println("Processing stock symbol: " + sanitizedStockCode);
        
        StringBuilder urlBuilder = new StringBuilder(polygonBaseUrl);
        
        // Determine the correct API endpoint based on timeframe
        String multiplier = "1";
        String timespan;
        int limit = 100;  // Default limit for results
        
        switch (timeframe) {
            case "daily":
                timespan = "day";
                break;
            case "weekly":
                timespan = "week";
                break;
            case "monthly":
                timespan = "month";
                break;
            default:
                timespan = "day";
        }
        
        // Calculating from and to dates for recent data
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalDate startDate;
        
        // Adjust range based on timeframe
        if ("daily".equals(timeframe)) {
            startDate = today.minusMonths(3); // 3 months of daily data
        } else if ("weekly".equals(timeframe)) {
            startDate = today.minusMonths(6); // 6 months of weekly data
        } else {
            startDate = today.minusYears(1);  // 1 year of monthly data
        }
        
        String fromDate = startDate.toString();
        String toDate = today.toString();
        
        System.out.println("Date range: " + fromDate + " to " + toDate);
        
        // For Polygon API, we need to add the ticker prefix for stocks
        String tickerSymbol = sanitizedStockCode;
        if (!tickerSymbol.startsWith("$")) {
            tickerSymbol = tickerSymbol;
        }
        
        urlBuilder.append("/v2/aggs/ticker/")
                .append(tickerSymbol)
                .append("/range/")
                .append(multiplier)
                .append("/")
                .append(timespan)
                .append("/")
                .append(fromDate)
                .append("/")
                .append(toDate);
        
        // Add query parameters
        urlBuilder.append("?adjusted=true&sort=asc&limit=").append(limit);
        
        // Add API key
        urlBuilder.append("&apiKey=").append(polygonApiKey);
        
        String apiUrl = urlBuilder.toString();
        System.out.println("Making Polygon.io API request: " + apiUrl);
        
        try {
            // Make the API request
            System.out.println("Full API URL: " + apiUrl);
            Map<String, Object> response = restTemplate.getForObject(apiUrl, Map.class);
            
            if (response != null) {
                // Print response keys for debugging
                System.out.println("API Response keys: " + response.keySet());
                System.out.println("Full API Response: " + response);
                
                // Check for error messages from Polygon.io
                if (response.containsKey("error")) {
                    String errorMessage = response.get("error").toString();
                    System.out.println("Polygon.io API error: " + errorMessage);
                    return createErrorResponse("API error: " + errorMessage);
                }
                
                // Check status (Polygon.io uses "OK" for successful responses or "DELAYED" for delayed data)
                if (response.containsKey("status") && 
                    !("OK".equals(response.get("status")) || "DELAYED".equals(response.get("status")))) {
                    System.out.println("Polygon.io API returned invalid status: " + response.get("status"));
                    return createErrorResponse("API returned invalid status: " + response.get("status"));
                }
                
                // If status is missing, that's also an error
                if (!response.containsKey("status")) {
                    System.out.println("Polygon.io API response missing status field");
                    System.out.println("Full response: " + response);
                    return createErrorResponse("API response missing status field");
                }
                
                // Process and return the data
                return processPolygonData(response, timeframe);
            } else {
                System.out.println("No response received from Polygon.io API");
                return createErrorResponse("No data received from API");
            }
        } catch (Exception e) {
            System.out.println("Exception when calling Polygon.io API: " + e.getMessage());
            e.printStackTrace();
            return createErrorResponse("Error fetching stock data: " + e.getMessage());
        }
    }
    
    /**
     * Sanitize stock symbol to ensure it's valid for Polygon.io API
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
     * Process the raw data from Polygon.io API
     * @param apiResponse the raw API response
     * @param timeframe the timeframe (daily, weekly, monthly)
     * @return a processed map containing time series data
     */
    private Map<String, Object> processPolygonData(Map<String, Object> apiResponse, String timeframe) {
        Map<String, Object> result = new HashMap<>();
        
        // Check if the results data exists
        if (!apiResponse.containsKey("results")) {
            System.out.println("Results key not found. Available keys: " + apiResponse.keySet());
            return createErrorResponse("No data found in the API response");
        }
        
        // Extract metadata
        Map<String, Object> metadata = new HashMap<>();
        metadata.put("1. Information", "Daily Prices from Polygon.io");
        metadata.put("2. Symbol", apiResponse.get("ticker"));
        metadata.put("3. Last Refreshed", new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
        metadata.put("4. Output Size", "Compact");
        metadata.put("5. Time Zone", "US/Eastern");
        
        // Convert Polygon's array format to Alpha Vantage's date-keyed map format
        List<Map<String, Object>> polygonResults = (List<Map<String, Object>>) apiResponse.get("results");
        Map<String, Map<String, String>> timeSeriesData = new HashMap<>();
        
        if (polygonResults != null) {
            for (Map<String, Object> bar : polygonResults) {
                try {
                    // Get timestamp and log the raw value
                    Object rawTimestamp = bar.get("t");
                    System.out.println("Raw timestamp type: " + (rawTimestamp != null ? rawTimestamp.getClass().getName() : "null"));
                    System.out.println("Raw timestamp value: " + rawTimestamp);
                    
                    // Convert to milliseconds
                    long timestamp;
                    
                    if (rawTimestamp instanceof Number) {
                        timestamp = ((Number) rawTimestamp).longValue();
                        
                        // Check if the timestamp might be in seconds instead of milliseconds
                        // If timestamp is before 2000 when converted as milliseconds, it's likely in seconds
                        java.util.Date testDate = new java.util.Date(timestamp);
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(testDate);
                        int year = cal.get(java.util.Calendar.YEAR);
                        
                        System.out.println("Initial timestamp interpretation: " + testDate + " (year: " + year + ")");
                        
                        // If year is after 2100, it's clearly wrong - adjust by dividing
                        if (year > 2100) {
                            timestamp = timestamp / 1000;
                            System.out.println("Timestamp adjusted by dividing by 1000: " + timestamp);
                        }
                        // If year is before 2000, it might be in seconds - adjust by multiplying
                        else if (year < 2000) {
                            timestamp = timestamp * 1000;
                            System.out.println("Timestamp adjusted by multiplying by 1000: " + timestamp);
                        }
                    } else {
                        // Default to current time if we can't parse the timestamp
                        System.out.println("WARNING: Could not parse timestamp: " + rawTimestamp);
                        timestamp = System.currentTimeMillis();
                    }
                    
                    // Convert to date string in YYYY-MM-DD format
                    java.util.Date date = new java.util.Date(timestamp);
                    String dateStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(date);
                    System.out.println("Final converted date: " + dateStr);
                    
                    // Create data point with Alpha Vantage-like structure
                    Map<String, String> dataPoint = new HashMap<>();
                    dataPoint.put("1. open", String.valueOf(bar.get("o")));
                    dataPoint.put("2. high", String.valueOf(bar.get("h")));
                    dataPoint.put("3. low", String.valueOf(bar.get("l")));
                    dataPoint.put("4. close", String.valueOf(bar.get("c")));
                    dataPoint.put("5. volume", String.valueOf(bar.get("v")));
                    
                    // Add to the map
                    timeSeriesData.put(dateStr, dataPoint);
                } catch (Exception e) {
                    System.out.println("Error processing data point: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        
        // Determine correct time series key based on the timeframe
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
        
        // Structure the response like Alpha Vantage for compatibility
        result.put("metadata", metadata);
        result.put("timeSeries", timeSeriesData);
        result.put(timeSeriesKey, timeSeriesData); // Add with the original key format
        result.put("Meta Data", metadata); // Add with the original key format
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