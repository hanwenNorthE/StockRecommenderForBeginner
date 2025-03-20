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
            background-color: #F5F5F5; /* 使用浅灰色作为整体背景 */
            color: #333333; /* 深灰色文本 */
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .welcome-section {
            background-color: #003366; /* 深蓝色背景 */
            color: #C0C0C0; /* 亮银色文本 */
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .welcome-section h1,
        .welcome-section p {
            color: #C0C0C0; /* 亮银色文本 */
        }

        button {
            background-color: #1E90FF; /* 电光蓝按钮 */
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #32CD32; /* 成功色：翠绿色，作为按钮悬浮时的效果 */
        }

    </style>
</head>
<body>
    <!-- 顶部导航栏，包含登录和注册选项 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
      <div class="container">
        <a class="navbar-brand" href="hello.jsp">Stock Recommendation System</a>
        <div class="collapse navbar-collapse justify-content-end">
          <ul class="navbar-nav">
            <li class="nav-item">
              <a class="nav-link" href="/loginPage.jsp">Log In</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/loginPage.jsp">Sign Up</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
    
    <div class="container">
        <div class="welcome-section">
            <h1 class="text-center">Welcome to Stock Recommendation</h1>
            <p class="lead text-center">${message}</p>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Features
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">Personalized Recommendation</li>
                        <li class="list-group-item">Current Market Analysis</li>
                        <li class="list-group-item">Investment Portfolio </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Trending Stocks
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
                            <li class="list-group-item">Not Avaliable</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
