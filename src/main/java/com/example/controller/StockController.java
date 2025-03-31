package com.example.controller;

import com.example.model.Stock;
import com.example.model.StockDetail;
import com.example.model.StockNews;
import com.example.service.StockService;
import com.example.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stocks")
public class StockController {
    
    private final StockService stockService;
    private final NewsService newsService;
    private final RestTemplate restTemplate;

    
    @Autowired
    public StockController(StockService stockService, NewsService newsService) {
        this.stockService = stockService;
        this.newsService = newsService;
        this.restTemplate = new RestTemplate();
    }

    // show stock list page
    @GetMapping("")
    public String listStocks(@RequestParam(required = false) String keyword, 
                            @RequestParam(required = false) String industry,
                            Model model) {
        List<Stock> stocks;
        
        if (keyword != null && !keyword.isEmpty()) {
            // search stock by keyword
            stocks = stockService.searchStock(keyword);
            model.addAttribute("searchType", "keyword");
            model.addAttribute("searchValue", keyword);
        } else if (industry != null && !industry.isEmpty()) {
            // filter stock by industry
            stocks = stockService.findByIndustry(industry);
            model.addAttribute("searchType", "industry");
            model.addAttribute("searchValue", industry);
        } else {
            // get all stocks
            stocks = stockService.findAllStocks();
        }
        
        model.addAttribute("stocks", stocks);
        return "stock/list";
    }
    
    // show stock detail page
    @GetMapping("/detail")
    public String showStockDetail(@RequestParam(required = false) String code, Model model) {
        System.out.println("Loading detail page for stock code: " + code);
        
        // check if code is empty
        if (code == null || code.trim().isEmpty()) {
            System.out.println("Stock code is empty or null");
            return "redirect:/stocks?error=Stock+code+is+required";
        }
        
        // ensure code is the trimmed value
        code = code.trim();
        
        Stock stock = stockService.getStock(code);
        if (stock == null) {
            System.out.println("Stock not found for code: " + code);
            return "redirect:/stocks?error=Stock+not+found";
        }
        
        // ensure stock object's code field is not empty
        if (stock.getCode() == null || stock.getCode().trim().isEmpty()) {
            System.out.println("WARNING: Stock object has empty code despite being retrieved with code: " + code);
            // use code from request
            stock.setCode(code);
        }
        
        System.out.println("Stock loaded successfully: " + stock.getCode() + " - " + stock.getCompanyName());
        
        StockDetail stockDetail = stockService.getStockDetail(code);
        List<StockNews> news = Collections.emptyList();
        try {
            // if there is news service implementation, get related news
            news = newsService.getNewsForStock(code);
        } catch (Exception e) {
            // ignore error, use empty list
        }
        
        model.addAttribute("stock", stock);
        model.addAttribute("stockDetail", stockDetail);
        model.addAttribute("news", news);
        
        // print stock code added to model, confirm its validity
        System.out.println("添加到模型的股票代码(stock.code): " + stock.getCode());
        
        return "stock/detail";
    }
    
    /**
     * API endpoint for fetching stock time series data
     * @param code The stock symbol
     * @param timeframe The timeframe (daily, weekly, monthly)
     * @return ResponseEntity containing the time series data
     */
    @GetMapping("/api/timeseries")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getStockTimeSeries(
            @RequestParam String code,
            @RequestParam(defaultValue = "daily") String timeframe) {
        
        System.out.println("API request received for stock: " + code + ", timeframe: " + timeframe);
        
        // Validate parameters
        if (code == null || code.trim().isEmpty()) {
            System.out.println("Invalid stock code provided: " + code);
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("error", "Invalid stock code: empty or null");
            return ResponseEntity.status(400).body(errorResult);
        }
        
        // 确保code是去除空格后的值
        code = code.trim();
        System.out.println("处理后的股票代码: " + code);
        
        // 尝试首先检查是否能找到该股票
        Stock stock = stockService.getStock(code);
        if (stock == null) {
            System.out.println("股票未找到: " + code);
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("error", "Stock not found: " + code);
            return ResponseEntity.status(404).body(errorResult);
        }
        
        System.out.println("找到股票: " + stock.getCode() + " - " + stock.getCompanyName());
        
        try {
            Map<String, Object> result = stockService.getStockTimeSeries(code, timeframe);
            
            if (Boolean.TRUE.equals(result.get("success"))) {
                System.out.println("Successfully fetched data for stock: " + code);
                return ResponseEntity.ok(result);
            } else {
                System.out.println("Error in API response for stock " + code + ": " + result.get("error"));
                return ResponseEntity.status(400).body(result);
            }
        } catch (Exception e) {
            System.out.println("Exception in getStockTimeSeries endpoint for stock " + code + ": " + e.getMessage());
            e.printStackTrace();
            
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("error", "Server error: " + e.getMessage());
            
            return ResponseEntity.status(500).body(errorResult);
        }
    }
    
    // TODO API接口 - 收藏股票
    @PostMapping("/api/favorite")
    @ResponseBody
    public String favorite(@RequestParam String stockCode) {
        // 这里为示例，实际操作时需要确定用户身份
        System.out.println("Favoriting stock: " + stockCode);
        return "Stock favorited successfully!";
    }

    /**
     * Simple test page to display stock data for debugging
     */
    @GetMapping("/debug-stock")
    public String debugStock(@RequestParam(required = false) String code, Model model) {
        System.out.println("Debug page accessed with code: " + code);
        
        if (code != null && !code.trim().isEmpty()) {
            Stock stock = stockService.getStock(code);
            if (stock != null) {
                model.addAttribute("stockInfo", "Stock found: " + stock.getCode() + " - " + stock.getCompanyName());
                model.addAttribute("stockCode", stock.getCode());
            } else {
                model.addAttribute("stockInfo", "Stock not found for code: " + code);
            }
        } else {
            // Get a list of available stocks
            List<Stock> stocks = stockService.findAllStocks().subList(0, Math.min(5, stockService.findAllStocks().size()));
            model.addAttribute("availableStocks", stocks);
            model.addAttribute("stockInfo", "Please provide a stock code");
        }
        
        return "stock/debug";
    }

    /**
     * export stock news to CSV and save to knowledgebase folder
     */
    @GetMapping("/exportNewsToCSV")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> exportNewsToCSV(
            @RequestParam String code) throws IOException {
        
        Map<String, Object> response = new HashMap<>();
        
        // check if code is empty
        if (code == null || code.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Stock code is required");
            return ResponseEntity.badRequest().body(response);
        }
        
        // get stock news data
        List<StockNews> news = newsService.getNewsForStock(code);
        
        if (news.isEmpty()) {
            response.put("success", false);
            response.put("message", "No news available for this stock");
            return ResponseEntity.ok(response);
        }
        
        // create knowledgebase folder path
        String knowledgebasePath;
        // 检查是否在Docker环境中运行
        if (System.getenv("DOCKER_ENV") != null) {
            // Docker环境使用挂载的路径
            knowledgebasePath = "/shared/knowledgeBase";
        } else {
            // 本地环境使用项目目录下的shared文件夹
            knowledgebasePath = System.getProperty("user.dir") + File.separator + "shared" + File.separator + "knowledgeBase";
        }
        
        File directory = new File(knowledgebasePath);
        if (!directory.exists()) {
            directory.mkdirs();
        }
        
        // generate file name, include stock code and timestamp
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String timestamp = dateFormat.format(new Date());
        String fileName = "stock_news_" + code + "_" + timestamp + ".csv";
        String filePath = knowledgebasePath + "/" + fileName;
        
        // write CSV data
        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            // write column titles
            writer.println("Stock Code,Title,Publish Date,Summary,URL");
            
            // write each row data
            for (StockNews item : news) {
                String publishDate = item.getPublishDate() != null ? 
                    dateFormat.format(item.getPublishDate()) : "";
                
                String csvLine = String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"",
                    escapeCSV(item.getCode()),
                    escapeCSV(item.getTitle()),
                    escapeCSV(publishDate),
                    escapeCSV(item.getSummary()),
                    escapeCSV(item.getUrl())
                );
                
                writer.println(csvLine);
            }
        }
        
        response.put("success", true);
        response.put("message", "Successfully exported " + news.size() + " news items");
        response.put("fileName", fileName);
        response.put("filePath", filePath);
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * helper method: escape double quotes in CSV fields
     */
    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "\"\"");
    }
} 