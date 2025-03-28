package com.example.service;

import com.example.dao.StockNewsDao;
import com.example.model.PolygonNewsResponse;
import com.example.model.StockNews;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class NewsService {
    
    private final StockNewsDao stockNewsDao;
    private final RestTemplate restTemplate;
    
    @Value("${polygon.api.key}")
    private String apiKey;
    
    @Value("${polygon.api.baseurl}")
    private String baseUrl;
    
    @Autowired
    public NewsService(StockNewsDao stockNewsDao, RestTemplate restTemplate) {
        this.stockNewsDao = stockNewsDao;
        this.restTemplate = restTemplate;
    }
    
    // get news for a specific stock
    public List<StockNews> getNewsForStock(String stockCode) {
        try {
            System.out.println("Getting news for stock: " + stockCode);
            
            // First check if we have the news in database
            List<StockNews> newsFromDb = stockNewsDao.findByCode(stockCode);
            if (!newsFromDb.isEmpty()) {
                System.out.println("Found " + newsFromDb.size() + " news items in database for " + stockCode);
                return newsFromDb;
            }
            
            System.out.println("No news found in database for " + stockCode + ", fetching from Polygon.io API");
            
            // Get news from the past month
            LocalDate today = LocalDate.now();
            LocalDate oneMonthAgo = today.minusMonths(1);
            
            // Format date to YYYY-MM-DD which is required by Polygon API
            String fromDate = oneMonthAgo.toString();
            
            // Construct the URL - Make sure ticker is formatted correctly
            String url = baseUrl + "/v2/reference/news" +
                         "?ticker=" + stockCode.toUpperCase() + 
                         "&published_utc.gte=" + fromDate + 
                         "&order=desc" +  // Get newest first
                         "&limit=20" +
                         "&apiKey=" + apiKey;
            
            System.out.println("Polygon.io API URL: " + url);
            
            return fetchNewsFromApi(url, stockCode);
        } catch (Exception e) {
            // Print the error for debugging
            System.err.println("Error getting news for stock " + stockCode + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // get latest news
    public List<StockNews> getLatestNews() {
        try {
            System.out.println("Getting latest news");
            
            // Get news from the past week
            LocalDate today = LocalDate.now();
            LocalDate oneWeekAgo = today.minusDays(7);
            
            // Format date properly
            String fromDate = oneWeekAgo.toString();
            
            String url = baseUrl + "/v2/reference/news" +
                         "?published_utc.gte=" + fromDate + 
                         "&order=desc" +  // Get newest first
                         "&limit=20" +
                         "&apiKey=" + apiKey;
            
            System.out.println("Polygon.io API URL: " + url);
            
            return fetchNewsFromApi(url, null);
        } catch (Exception e) {
            System.err.println("Error getting latest news: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    private List<StockNews> fetchNewsFromApi(String url, String stockCode) {
        try {
            System.out.println("Fetching news from API: " + url);
            
            // For debugging, first get the raw response as a String
            String rawResponse = restTemplate.getForObject(url, String.class);
            System.out.println("Raw response from Polygon.io: " + (rawResponse != null ? rawResponse.substring(0, Math.min(500, rawResponse.length())) + "..." : "null"));
            
            // Now try to parse it to our response object
            PolygonNewsResponse response = restTemplate.getForObject(url, PolygonNewsResponse.class);
            List<StockNews> news = new ArrayList<>();
            
            System.out.println("API Response: " + (response != null ? "not null" : "null"));
            
            // Check response status
            if (response != null) {
                System.out.println("Response status: " + response.getStatus());
                System.out.println("Response count: " + response.getCount());
            }
            
            if (response != null && response.getResults() != null && !response.getResults().isEmpty()) {
                System.out.println("Found " + response.getResults().size() + " news items from API");
                
                for (PolygonNewsResponse.NewsItem item : response.getResults()) {
                    try {
                        if (item == null) {
                            System.out.println("Skipping null news item");
                            continue;
                        }
                        
                        System.out.println("Processing news item: " + (item.getTitle() != null ? item.getTitle() : "No title"));
                        
                        Date publishDate = null;
                        if (item.getPublishedUtc() != null) {
                            try {
                                // Convert ISO 8601 date format to Java Date
                                ZonedDateTime zonedDateTime = ZonedDateTime.parse(item.getPublishedUtc());
                                publishDate = Date.from(zonedDateTime.toInstant());
                                System.out.println("Parsed date: " + publishDate + " from " + item.getPublishedUtc());
                            } catch (Exception e) {
                                System.err.println("Failed to parse date: " + item.getPublishedUtc() + ", error: " + e.getMessage());
                                publishDate = new Date(); // Default to current date if parsing fails
                            }
                        } else {
                            System.out.println("No published date found for item");
                            publishDate = new Date(); // Use current date as fallback
                        }
                        
                        // If no specific stock code was provided but the item has tickers, use the first one
                        String newsStockCode = stockCode;
                        if (newsStockCode == null && item.getTickers() != null && !item.getTickers().isEmpty()) {
                            newsStockCode = item.getTickers().get(0);
                            System.out.println("Using ticker from news item: " + newsStockCode);
                        }
                        
                        // Make sure we have values for required fields, using defaults if necessary
                        String title = item.getTitle() != null ? item.getTitle() : "No title available";
                        String description = item.getDescription() != null ? item.getDescription() : "No description available";
                        String articleUrl = item.getArticleUrl() != null ? item.getArticleUrl() : "";
                        
                        StockNews newsItem = new StockNews(
                            newsStockCode, 
                            title, 
                            description, 
                            articleUrl, 
                            publishDate
                        );
                        
                        System.out.println("Created news item: " + newsItem.getTitle());
                        news.add(newsItem);
                        
                        // Optionally save to database, tested, it is working!
                        if (stockCode != null) {
                            try {
                                System.out.println("Saving news item to database");
                                stockNewsDao.save(newsItem);
                            } catch (Exception e) {
                                System.err.println("Error saving news to database: " + e.getMessage());
                            }
                        }
                    } catch (Exception e) {
                        System.err.println("Error processing news item: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            } else {
                System.out.println("No results found in API response or response is null");
                if (response != null) {
                    System.out.println("Response status: " + response.getStatus());
                }
            }
            
            System.out.println("Returning " + news.size() + " news items");
            return news;
        } catch (Exception e) {
            System.err.println("Error fetching news from API: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
} 