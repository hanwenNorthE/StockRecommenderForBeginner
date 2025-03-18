package com.example.model;

import java.util.Date;

public class PriceData {
    private Long priceDataId;
    private String code;
    private Date date;
    private double open;
    private double close;
    private double high;
    private double low;
    private long volume;
    private int openInt;
    private StockDetail stockDetail;

    public PriceData() {}

    public PriceData(String code, Date date, double open, double close, double high, double low, long volume, int openInt) {
        this.code = code;
        this.date = date;
        this.open = open;
        this.close = close;
        this.high = high;
        this.low = low;
        this.volume = volume;
        this.openInt = openInt;
    }

    // getters and setters
    public Long getPriceDataId() { return priceDataId; }
    public void setPriceDataId(Long priceDataId) { this.priceDataId = priceDataId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public double getOpen() { return open; }
    public void setOpen(double open) { this.open = open; }

    public double getClose() { return close; }
    public void setClose(double close) { this.close = close; }

    public double getHigh() { return high; }
    public void setHigh(double high) { this.high = high; }

    public double getLow() { return low; }
    public void setLow(double low) { this.low = low; }

    public long getVolume() { return volume; }
    public void setVolume(long volume) { this.volume = volume; }

    public int getOpenInt() { return openInt; }
    public void setOpenInt(int openInt) { this.openInt = openInt; }

    public StockDetail getStockDetail() { return stockDetail; }
    public void setStockDetail(StockDetail stockDetail) { this.stockDetail = stockDetail; }
}
