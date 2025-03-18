<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>股票推荐系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 20px;
        }
        .container {
            max-width: 800px;
        }
        .welcome-section {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-section">
            <h1 class="text-center">欢迎使用股票推荐系统</h1>
            <p class="lead text-center">${message}</p>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        系统功能
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">个性化股票推荐</li>
                        <li class="list-group-item">股票行情分析</li>
                        <li class="list-group-item">投资组合管理</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        热门股票
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:forEach items="${hotStocks}" var="stock">
                            <li class="list-group-item">
                                ${stock.code} - ${stock.companyName}
                                <span class="badge ${stock.priceChange >= 0 ? 'bg-success' : 'bg-danger'} float-end">
                                    ${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange}
                                </span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty hotStocks}">
                            <li class="list-group-item">暂无数据</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 