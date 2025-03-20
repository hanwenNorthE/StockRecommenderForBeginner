package com.example.controller;

import com.example.model.Stock;
import com.example.model.StockDetail;
import com.example.model.StockNews;
import com.example.service.StockService;
import com.example.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/stocks")
public class StockController {
    
    private final StockService stockService;
    private final NewsService newsService;
    
    @Autowired
    public StockController(StockService stockService, NewsService newsService) {
        this.stockService = stockService;
        this.newsService = newsService;
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
    public String showStockDetail(@RequestParam String code, Model model) {
        Stock stock = stockService.getStock(code);
        if (stock == null) {
            return "redirect:/stocks?error=Stock+not+found";
        }
        
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
        
        return "stock/detail";
    }
    
    // API接口 - 收藏股票
    @PostMapping("/api/favorite")
    @ResponseBody
    public String favorite(@RequestParam String stockCode) {
        // 这里为示例，实际操作时需要确定用户身份
        System.out.println("Favoriting stock: " + stockCode);
        return "Stock favorited successfully!";
    }
} 