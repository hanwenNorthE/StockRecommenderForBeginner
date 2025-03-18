package com.example.dao;

import java.util.List;
import java.util.Optional;

/**
 * 通用DAO接口，定义基本的CRUD操作
 * @param <T> 实体类型
 * @param <ID> 主键类型
 */
public interface BaseDao<T, ID> {
    
    /**
     * 根据ID查找实体
     * @param id 主键
     * @return 可能的实体
     */
    Optional<T> findById(ID id);
    
    /**
     * 查找所有实体
     * @return 实体列表
     */
    List<T> findAll();
    
    /**
     * 保存实体（插入或更新）
     * @param entity 要保存的实体
     * @return 保存后的实体
     */
    T save(T entity);
    
    /**
     * 删除实体
     * @param id 要删除的实体ID
     * @return 是否成功删除
     */
    boolean deleteById(ID id);
    
    /**
     * 检查实体是否存在
     * @param id 实体ID
     * @return 是否存在
     */
    boolean existsById(ID id);
} 