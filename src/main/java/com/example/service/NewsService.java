package com.example.service;

import com.example.dao.StockNewsDao;
import com.example.model.StockNews;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class NewsService {
    
    private final StockNewsDao stockNewsDao;
    
    @Autowired
    public NewsService(StockNewsDao stockNewsDao) {
        this.stockNewsDao = stockNewsDao;
    }
    
    // 获取指定股票的相关新闻
    public List<StockNews> getNewsForStock(String stockCode) {
        try {
            return stockNewsDao.findByCode(stockCode);
        } catch (Exception e) {
            // 出错时返回空列表
            return new ArrayList<>();
        }
    }
} 