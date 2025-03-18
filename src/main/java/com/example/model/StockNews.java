package com.example.model;

import java.util.Date;

public class StockNews {
    private Long id;
    private String code;
    private String title;
    private String summary;
    private String url;
    private Date publishDate;
    private StockDetail stockDetail;

    public StockNews() {
    }

    public StockNews(String code, String title, String summary, String url, Date publishDate) {
        this.code = code;
        this.title = title;
        this.summary = summary;
        this.url = url;
        this.publishDate = publishDate;
    }

    // getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    
    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }
    
    public StockDetail getStockDetail() { return stockDetail; }
    public void setStockDetail(StockDetail stockDetail) { this.stockDetail = stockDetail; }
} 