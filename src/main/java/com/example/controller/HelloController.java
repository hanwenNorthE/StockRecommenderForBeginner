package com.example.controller;

import com.example.model.Stock;
import com.example.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
public class HelloController {
    
    private StockService stockService;
    
    @Autowired
    public HelloController(StockService stockService) {
        this.stockService = stockService;
    }
    
    @GetMapping("/hello")
    public String hello(Model model) {
        model.addAttribute("message", "欢迎访问股票推荐系统，为初学者打造的投资助手！");
        
        try {
            // 从服务获取热门股票
            List<Stock> hotStocks = stockService.getHotStocks();
            model.addAttribute("hotStocks", hotStocks);
        } catch (Exception e) {
            // 服务不可用时使用空列表
            model.addAttribute("hotStocks", new ArrayList<>());
        }
        
        return "hello";
    }
    
    @GetMapping("/")
    public String index() {
        return "redirect:/hello";
    }
} 