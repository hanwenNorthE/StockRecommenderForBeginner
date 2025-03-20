<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Recommendation System</title>
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
    <!-- 顶部导航栏，包含登录和注册选项 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
      <div class="container">
        <a class="navbar-brand" href="/hello">Stock Recommendation System</a>
        <div class="collapse navbar-collapse justify-content-end">
          <ul class="navbar-nav">
            <li class="nav-item">
              <a class="nav-link" href="/login">Login</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/login">Register</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    
    <div class="container">
        <div class="welcome-section">
            <h1 class="text-center">Welcome to Stock Recommendation System</h1>
            <p class="lead text-center">${message}</p>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        System Features
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">Personalized Stock Recommendations</li>
                        <li class="list-group-item">Stock Market Analysis</li>
                        <li class="list-group-item">Investment Portfolio Management</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Hot Stocks
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
                            <li class="list-group-item">No data available</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
