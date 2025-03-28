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

import java.util.Collections;
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
        
        // 检查代码是否为空
        if (code == null || code.trim().isEmpty()) {
            System.out.println("Stock code is empty or null");
            return "redirect:/stocks?error=Stock+code+is+required";
        }
        
        // 确保code是去除空格后的值
        code = code.trim();
        
        Stock stock = stockService.getStock(code);
        if (stock == null) {
            System.out.println("Stock not found for code: " + code);
            return "redirect:/stocks?error=Stock+not+found";
        }
        
        // 确保stock对象的code字段不为空
        if (stock.getCode() == null || stock.getCode().trim().isEmpty()) {
            System.out.println("WARNING: Stock object has empty code despite being retrieved with code: " + code);
            // 使用请求中的代码
            stock.setCode(code);
        }
        
        System.out.println("Stock loaded successfully: " + stock.getCode() + " - " + stock.getCompanyName());
        
        StockDetail stockDetail = stockService.getStockDetail(code);
        List<StockNews> news = Collections.emptyList();
        try {
            // 如果有新闻服务实现，则获取相关新闻
            news = newsService.getNewsForStock(code);
        } catch (Exception e) {
            // 忽略错误，使用空列表
        }
        
        model.addAttribute("stock", stock);
        model.addAttribute("stockDetail", stockDetail);
        model.addAttribute("news", news);
        
        // 打印添加到模型中的股票代码，确认其有效性
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
    
    // API接口 - 收藏股票
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
} 