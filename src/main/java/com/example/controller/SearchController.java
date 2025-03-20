package com.example.controller;

import com.example.model.Stock;
import com.example.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class SearchController {
    
    private final StockService stockService;
    
    @Autowired
    public SearchController(StockService stockService) {
        this.stockService = stockService;
    }
    
    // front-end search page
    @GetMapping("/search")
    public String searchPage(@RequestParam(name = "q", required = false) String keyword, Model model) {
        if (keyword != null && !keyword.isEmpty()) {
            System.out.println("Searching for: " + keyword);
            List<Stock> results = stockService.searchStock(keyword);
            System.out.println("Found " + results.size() + " results");
            for (Stock stock : results) {
                System.out.println("- " + stock.getCode() + ": " + stock.getCompanyName());
            }
            
            model.addAttribute("keyword", keyword);
            model.addAttribute("searchResults", results);
            model.addAttribute("resultCount", results.size());
        }
        return "stock/search";
    }
} 