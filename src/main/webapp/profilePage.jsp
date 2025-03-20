<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
<<<<<<< Updated upstream:src/main/webapp/profilePage.jsp
    <title>Client Profile</title>
=======
    <title>Profile Page - Stock Recommendation System</title>
>>>>>>> Stashed changes:src/main/webapp/WEB-INF/jsp/profilePage.jsp
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
       body {
            padding-top: 20px;
            background-color: #F5F5F5; /* 浅灰色背景 */
            color: #333333; /* 深灰色文本 */
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .user-info {
            background-color: #003366; /* 深蓝色背景 */
            color: #C0C0C0; /* 亮银色文本 */
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .user-info h2 {
            color: #C0C0C0; /* 亮银色标题 */
        }

        .card {
            background-color: #FFFFFF; /* 卡片背景使用白色 */
            border: 1px solid #C0C0C0; /* 卡片边框为亮银色 */
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .card h3 {
            color: #003366; /* 卡片标题使用深蓝色 */
        }

        button {
            background-color: #1E90FF; /* 电光蓝按钮 */
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #32CD32; /* 悬浮时使用翠绿色 */
        }

    </style>
</head>
<body>
    <div class="container">
        <!-- 用户基本信息与账户余额 -->
        <div class="user-info">
<<<<<<< Updated upstream:src/main/webapp/profilePage.jsp
            <h1>
                Welcome, 
                <c:choose>
                    <c:when test="${not empty user.name}">
                        ${User.name.getFirstName()} ${User.name.getLastName()}
                    </c:when>
                    <c:otherwise>
                        ${User.getEmail()}
                    </c:otherwise>
                </c:choose>
                !
            </h1>
            <p>E-mail: ${User.getEmail()}</p>
            <p>Account Balance: $<c:out value="${accountBalance}" /></p>
=======
            <h1>Welcome, ${user.name.firstName}!</h1>
            <p>Email: ${user.email}</p>
            <p>Account Balance: $<c:out value="${accountBalance}" /></p>
            <!-- 新增按钮，跳转到持仓录入页面 -->
            <div class="text-end">
                <a href="${pageContext.request.contextPath}/holdings/add" class="btn btn-primary">Add Holdings</a>
            </div>
>>>>>>> Stashed changes:src/main/webapp/WEB-INF/jsp/profilePage.jsp
        </div>
        
        <div class="row">
            <!-- 持有的股票展示 -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Current Holding
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:forEach items="${userHoldings}" var="holding">
                            <li class="list-group-item">
                                ${holding.stockCode} - Qty: ${holding.quantity}
                            </li>
                        </c:forEach>
                        <c:if test="${empty userHoldings}">
                            <li class="list-group-item">Not Investing</li>
                        </c:if>
                    </ul>
                </div>
            </div>
            
            <!-- 根据持仓推荐的股票 -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        Recommended Stocks
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
                            <li class="list-group-item">Current Unavaliable</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
