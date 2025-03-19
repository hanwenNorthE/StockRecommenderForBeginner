<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户主页 - 股票推荐系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 20px;
        }
        .container {
            max-width: 900px;
        }
        .user-info {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .card {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 用户基本信息与账户余额 -->
        <div class="user-info">
            <h1>欢迎, ${user.username}!</h1>
            <p>邮箱: ${user.email}</p>
            <p>账户余额: ￥<c:out value="${accountBalance}" /></p>
        </div>
        
        <div class="row">
            <!-- 持有的股票 -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        持有的股票
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:forEach items="${userHoldings}" var="holding">
                            <li class="list-group-item">
                                ${holding.code} - ${holding.companyName}
                                <span class="badge bg-info float-end">持有: ${holding.quantity}</span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty userHoldings}">
                            <li class="list-group-item">暂无持仓</li>
                        </c:if>
                    </ul>
                </div>
            </div>
            
            <!-- 根据持仓推荐的股票 -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        根据您的持仓推荐的股票
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:forEach items="${recommendedStocks}" var="stock">
                            <li class="list-group-item">
                                ${stock.code} - ${stock.companyName}
                                <span class="badge ${stock.priceChange >= 0 ? 'bg-success' : 'bg-danger'} float-end">
                                    ${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange}
                                </span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty recommendedStocks}">
                            <li class="list-group-item">暂无推荐股票</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
