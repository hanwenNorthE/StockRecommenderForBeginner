<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Debug Page</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta name="stock-code" content="${stockCode}">
</head>
<body>
    <div class="container mt-4">
        <h1>Stock Data Debug Page</h1>
        
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                Stock Information
            </div>
            <div class="card-body">
                <p>${stockInfo}</p>
                
                <c:if test="${not empty stockCode}">
                    <div class="mb-3">
                        <h4>API Test</h4>
                        <p><strong>Stock Code:</strong> <span class="text-primary">${stockCode}</span></p>
                        <input type="hidden" id="stockCodeInput" value="${stockCode}">
                        <button class="btn btn-primary" onclick="testAPIWithCode('daily')">Test Daily API</button>
                        <button class="btn btn-secondary" onclick="testAPIWithCode('weekly')">Test Weekly API</button>
                        <button class="btn btn-info" onclick="testAPIWithCode('monthly')">Test Monthly API</button>
                    </div>
                    
                    <div id="apiResponse" class="mt-3">
                        <div class="alert alert-info">Click a button to test the API</div>
                    </div>
                </c:if>
                
                <c:if test="${empty stockCode}">
                    <form action="/stocks/debug-stock" method="get" class="mb-3">
                        <div class="input-group">
                            <input type="text" name="code" class="form-control" placeholder="Enter stock code...">
                            <button class="btn btn-outline-primary" type="submit">Load Stock</button>
                        </div>
                    </form>
                    
                    <c:if test="${not empty availableStocks}">
                        <h5>Available Stocks:</h5>
                        <ul class="list-group">
                            <c:forEach items="${availableStocks}" var="stock">
                                <li class="list-group-item">
                                    <a href="/stocks/debug-stock?code=${stock.code}">${stock.code} - ${stock.companyName}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:if>
                </c:if>
            </div>
        </div>
        
        <div class="mt-3">
            <a href="/stocks" class="btn btn-secondary">Back to Stock List</a>
        </div>
    </div>
    
    <script>
        // 新函数：从隐藏字段获取股票代码
        function testAPIWithCode(timeframe) {
            const code = document.getElementById('stockCodeInput').value;
            testAPI(code, timeframe);
        }
    
        function testAPI(code, timeframe) {
            // 验证股票代码是否为空
            if (!code || code.trim() === '') {
                document.getElementById('apiResponse').innerHTML = 
                    '<div class="alert alert-danger">错误：股票代码不能为空</div>';
                console.error('Stock code is empty, cannot make API call');
                return;
            }
            
            document.getElementById('apiResponse').innerHTML = 
                '<div class="spinner-border text-primary" role="status"></div> Loading...';
            
            const apiUrl = `/stocks/api/timeseries?code=${code}&timeframe=${timeframe}`;
            console.log(`Testing API: ${apiUrl} with code=${code}`);
            
            fetch(apiUrl)
                .then(response => {
                    console.log(`Response status: ${response.status}`);
                    return response.json();
                })
                .then(data => {
                    console.log("API response:", data);
                    let html = '<div class="alert alert-success">API call successful!</div>';
                    html += '<pre class="bg-light p-3" style="max-height: 300px; overflow: auto;">';
                    html += JSON.stringify(data, null, 2);
                    html += '</pre>';
                    document.getElementById('apiResponse').innerHTML = html;
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('apiResponse').innerHTML = 
                        `<div class="alert alert-danger">Error: ${error.message}</div>`;
                });
        }
        
        // 页面加载时验证股票代码
        document.addEventListener('DOMContentLoaded', function() {
            const codeElement = document.getElementById('stockCodeInput');
            if (codeElement) {
                const code = codeElement.value;
                console.log('Page loaded with stock code:', code);
                if (!code || code.trim() === '') {
                    console.warn('Warning: Stock code is empty');
                }
            }
        });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 