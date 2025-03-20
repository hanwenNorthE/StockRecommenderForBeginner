package com.example.dao;

import com.example.model.Stock;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class StockDaoTest {

    @Autowired
    private StockDao stockDao;

    @Test
    public void testFindAll() {
        List<Stock> stocks = stockDao.findAll();
        assertNotNull(stocks);
        System.out.println("found " + stocks.size() + " stocks");
        stocks.forEach(stock -> {
            System.out.println(stock.getCode() + " - " + stock.getCompanyName());
        });
    }

    @Test
    public void testSaveAndFindById() {
        // 创建新的股票
        Stock newStock = new Stock();
        newStock.setCode("TEST123");
        newStock.setCompanyName("test company");
        newStock.setCurrentPrice(123.45);
        newStock.setPriceChange(5.67);
        newStock.setMarketValue(1.23e9);
        newStock.setIndustry("Technology");

        // 保存
        Stock savedStock = stockDao.save(newStock);
        assertNotNull(savedStock);
        assertEquals("TEST123", savedStock.getCode());

        // 查找
        Optional<Stock> foundStock = stockDao.findById("TEST123");
        assertTrue(foundStock.isPresent());
        assertEquals("test company", foundStock.get().getCompanyName());
    }

    @Test
    public void testFindByCompanyName() {
        // 先保存一条记录
        Stock stock = new Stock();
        stock.setCode("FIND001");
        stock.setCompanyName("find company");
        stock.setCurrentPrice(100.0);
        stock.setPriceChange(1.0);
        stock.setMarketValue(1e9);
        stock.setIndustry("Technology");
        stockDao.save(stock);

        // 测试查找
        List<Stock> foundStocks = stockDao.findByCompanyName("find company");
        assertFalse(foundStocks.isEmpty());
        assertTrue(foundStocks.stream().anyMatch(s -> s.getCode().equals("FIND001")));
    }

    @Test
    public void testFindByIndustry() {
        // 测试查找
        List<Stock> techStocks = stockDao.findByIndustry("Technology");
        System.out.println("found " + techStocks.size() + " tech stocks");
        assertNotNull(techStocks);
    }
} 