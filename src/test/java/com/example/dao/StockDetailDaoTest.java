package com.example.dao;

import com.example.model.StockDetail;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class StockDetailDaoTest {

    @Autowired
    private StockDetailDao stockDetailDao;

    @Test
    public void testSaveAndFindByStockCode() {
        // 创建新的股票详情
        StockDetail detail = new StockDetail();
        detail.setCode("TESTDETAIL");
        detail.setDescription("这是一个测试用的股票详情描述，包含公司基本情况介绍等信息。");

        // 保存
        StockDetail savedDetail = stockDetailDao.save(detail);
        assertNotNull(savedDetail);
        assertEquals("TESTDETAIL", savedDetail.getCode());

        // 查找
        StockDetail foundDetail = stockDetailDao.findByStockCode("TESTDETAIL");
        assertNotNull(foundDetail);
        assertEquals("这是一个测试用的股票详情描述，包含公司基本情况介绍等信息。", foundDetail.getDescription());
    }

    @Test
    public void testFindByDescriptionContaining() {
        // 保存几条不同的详情记录
        StockDetail detail1 = new StockDetail();
        detail1.setCode("DESC001");
        detail1.setDescription("这家公司专注于人工智能技术研发");
        stockDetailDao.save(detail1);

        StockDetail detail2 = new StockDetail();
        detail2.setCode("DESC002");
        detail2.setDescription("这是一家生物医药研发公司");
        stockDetailDao.save(detail2);

        // 测试查询
        var results = stockDetailDao.findByDescriptionContaining("人工智能");
        assertFalse(results.isEmpty());
        assertEquals(1, results.size());
        assertEquals("DESC001", results.get(0).getCode());
    }
} 