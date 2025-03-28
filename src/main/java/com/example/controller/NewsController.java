package com.example.controller;

import com.example.model.StockNews;
import com.example.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/news")
public class NewsController {

    private final NewsService newsService;

    @Autowired
    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping("/stock/{ticker}")
    public ResponseEntity<List<StockNews>> getNewsForStock(@PathVariable String ticker) {
        System.out.println("NewsController: Getting news for stock: " + ticker);
        List<StockNews> news = newsService.getNewsForStock(ticker);
        System.out.println("NewsController: Returning " + news.size() + " news items for stock: " + ticker);
        return ResponseEntity.ok(news);
    }
    
    @GetMapping("/latest")
    public ResponseEntity<List<StockNews>> getLatestNews() {
        System.out.println("NewsController: Getting latest news");
        List<StockNews> news = newsService.getLatestNews();
        System.out.println("NewsController: Returning " + news.size() + " latest news items");
        return ResponseEntity.ok(news);
    }
} 