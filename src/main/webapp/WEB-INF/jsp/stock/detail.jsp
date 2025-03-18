<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${stock.companyName} - 股票详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/stocks">股票列表</a></li>
                <li class="breadcrumb-item active" aria-current="page">股票详情</li>
            </ol>
        </nav>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3>${stock.code} - ${stock.companyName}</h3>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h4 class="mb-3">基本信息</h4>
                                <p><strong>股票代码:</strong> ${stock.code}</p>
                                <p><strong>公司名称:</strong> ${stock.companyName}</p>
                                <p><strong>行业:</strong> ${stock.industry}</p>
                                <p><strong>市值:</strong> ${stock.marketValue}</p>
                            </div>
                            <div class="col-md-6">
                                <h4 class="mb-3">价格信息</h4>
                                <p><strong>当前价格:</strong> $${stock.currentPrice}</p>
                                <p>
                                    <strong>涨跌幅:</strong> 
                                    <span class="${stock.priceChange >= 0 ? 'text-success' : 'text-danger'}">
                                        ${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange}%
                                    </span>
                                </p>
                            </div>
                        </div>
                        
                        <h4 class="mb-3">公司描述</h4>
                        <p>${stockDetail.description != null ? stockDetail.description : '暂无描述'}</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-secondary text-white">
                        相关新闻
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:if test="${empty news}">
                            <li class="list-group-item">暂无相关新闻</li>
                        </c:if>
                        <c:forEach items="${news}" var="item">
                            <li class="list-group-item">
                                <a href="${item.url}" target="_blank">${item.title}</a>
                                <small class="text-muted d-block">${item.publishDate}</small>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 