<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Holding - Stock Recommendation System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 20px;
        }
        .container {
            max-width: 600px;
        }
        .form-container {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2>Add Holding</h2>
            <form action="${pageContext.request.contextPath}/holdings/add" method="post">
                <div class="mb-3">
                    <label for="stockCode" class="form-label">Stock Code</label>
                    <select id="stockCode" name="stockCode" class="form-select">
                        <option value="aapl">AAPL</option>
                        <option value="abcd">ABCD</option>
                        <option value="adro">ADRO</option>
                        <option value="amzn">AMZN</option>
                        <option value="asml">ASML</option>
                        <option value="baa">BAA</option>
                        <option value="bc">BC</option>
                        <option value="bcacr">BCACR</option>
                        <option value="bcc">BCC</option>
                        <option value="bcd">BCD</option>
                        <option value="bce">BCE</option>
                        <option value="bcei">BCEI</option>
                        <option value="bch">BCH</option>
                        <option value="bcor">BCOR</option>
                        <option value="bcpc">BCPC</option>
                        <option value="bcr">BCR</option>
                        <option value="bcrh">BCRH</option>
                        <option value="bcrx">BCRX</option>
                        <option value="bcs_d">BCS_D</option>
                        <option value="brk-b">BRK-B</option>
                        <option value="corp">CORP</option>
                        <option value="fb">FB</option>
                        <option value="googl">GOOGL</option>
                        <option value="jnj">JNJ</option>
                        <option value="jpm_a">JPM_A</option>
                        <option value="mc">MC</option>
                        <option value="msft">MSFT</option>
                        <option value="nvda">NVDA</option>
                        <option value="tsla">TSLA</option>
                        <option value="v">V</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="quantity" class="form-label">Quantity</label>
                    <input type="number" id="quantity" name="quantity" class="form-control" min="1" required>
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
                <!-- 返回用户资料页面的按钮 -->
                <a href="${pageContext.request.contextPath}/profilePage" class="btn btn-secondary">Back To Profile</a>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
