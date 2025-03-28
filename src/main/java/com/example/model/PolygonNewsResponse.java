package com.example.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PolygonNewsResponse {
    
    @JsonProperty("status")
    private String status;
    
    @JsonProperty("request_id")
    private String requestId;
    
    @JsonProperty("count")
    private int count;
    
    @JsonProperty("next_url")
    private String nextUrl;
    
    @JsonProperty("results")
    private List<NewsItem> results;
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class NewsItem {
        @JsonProperty("id")
        private String id;
        
        @JsonProperty("publisher")
        private Publisher publisher;
        
        @JsonProperty("title")
        private String title;
        
        @JsonProperty("author")
        private String author;
        
        @JsonProperty("published_utc")
        private String publishedUtc;
        
        @JsonProperty("article_url")
        private String articleUrl;
        
        @JsonProperty("tickers")
        private List<String> tickers;
        
        @JsonProperty("amp_url")
        private String ampUrl;
        
        @JsonProperty("image_url")
        private String imageUrl;
        
        @JsonProperty("description")
        private String description;
        
        @JsonProperty("keywords")
        private List<String> keywords;
        
        // Nested Publisher class
        @JsonIgnoreProperties(ignoreUnknown = true)
        public static class Publisher {
            @JsonProperty("name")
            private String name;
            
            @JsonProperty("homepage_url")
            private String homepageUrl;
            
            @JsonProperty("logo_url")
            private String logoUrl;
            
            @JsonProperty("favicon_url")
            private String faviconUrl;
            
            // Getters and setters
            public String getName() {
                return name;
            }
            
            public void setName(String name) {
                this.name = name;
            }
            
            public String getHomepageUrl() {
                return homepageUrl;
            }
            
            public void setHomepageUrl(String homepageUrl) {
                this.homepageUrl = homepageUrl;
            }
            
            public String getLogoUrl() {
                return logoUrl;
            }
            
            public void setLogoUrl(String logoUrl) {
                this.logoUrl = logoUrl;
            }
            
            public String getFaviconUrl() {
                return faviconUrl;
            }
            
            public void setFaviconUrl(String faviconUrl) {
                this.faviconUrl = faviconUrl;
            }
        }
        
        // Getters and setters
        public String getId() {
            return id;
        }
        
        public void setId(String id) {
            this.id = id;
        }
        
        public Publisher getPublisher() {
            return publisher;
        }
        
        public void setPublisher(Publisher publisher) {
            this.publisher = publisher;
        }
        
        public String getTitle() {
            return title;
        }
        
        public void setTitle(String title) {
            this.title = title;
        }
        
        public String getAuthor() {
            return author;
        }
        
        public void setAuthor(String author) {
            this.author = author;
        }
        
        public String getPublishedUtc() {
            return publishedUtc;
        }
        
        public void setPublishedUtc(String publishedUtc) {
            this.publishedUtc = publishedUtc;
        }
        
        public String getArticleUrl() {
            return articleUrl;
        }
        
        public void setArticleUrl(String articleUrl) {
            this.articleUrl = articleUrl;
        }
        
        public List<String> getTickers() {
            return tickers;
        }
        
        public void setTickers(List<String> tickers) {
            this.tickers = tickers;
        }
        
        public String getAmpUrl() {
            return ampUrl;
        }
        
        public void setAmpUrl(String ampUrl) {
            this.ampUrl = ampUrl;
        }
        
        public String getImageUrl() {
            return imageUrl;
        }
        
        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }
        
        public String getDescription() {
            return description;
        }
        
        public void setDescription(String description) {
            this.description = description;
        }
        
        public List<String> getKeywords() {
            return keywords;
        }
        
        public void setKeywords(List<String> keywords) {
            this.keywords = keywords;
        }
    }
    
    // Getters and setters for main class
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getRequestId() {
        return requestId;
    }
    
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
    
    public int getCount() {
        return count;
    }
    
    public void setCount(int count) {
        this.count = count;
    }
    
    public String getNextUrl() {
        return nextUrl;
    }
    
    public void setNextUrl(String nextUrl) {
        this.nextUrl = nextUrl;
    }
    
    public List<NewsItem> getResults() {
        return results;
    }
    
    public void setResults(List<NewsItem> results) {
        this.results = results;
    }
} 