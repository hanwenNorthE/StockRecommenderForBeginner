<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>股票列表</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">股票列表</h1>
        
        <div class="row mb-3">
            <div class="col">
                <form action="/stocks" method="get" class="d-flex">
                    <input type="text" name="keyword" class="form-control me-2" placeholder="搜索股票..." value="${param.keyword}">
                    <button type="submit" class="btn btn-primary">搜索</button>
                </form>
            </div>
            <div class="col-auto">
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle" type="button" id="industryDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        按行业筛选
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="industryDropdown">
                        <li><a class="dropdown-item" href="/stocks">全部</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Technology">科技</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Finance">金融</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Healthcare">医疗健康</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Consumer Goods">消费品</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Energy">能源</a></li>
                    </ul>
                </div>
            </div>
        </div>
        
        <table class="table table-striped table-hover">
            <thead class="table-dark">
                <tr>
                    <th>代码</th>
                    <th>公司名称</th>
                    <th>当前价格</th>
                    <th>涨跌幅</th>
                    <th>市值</th>
                    <th>行业</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${stocks}" var="stock">
                    <tr>
                        <td>${stock.code}</td>
                        <td>${stock.companyName}</td>
                        <td>$${stock.currentPrice}</td>
                        <td class="${stock.priceChange >= 0 ? 'text-success' : 'text-danger'}">
                            ${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange}%
                        </td>
                        <td>${stock.marketValue}</td>
                        <td>${stock.industry}</td>
                        <td>
                            <a href="/stocks/detail?code=${stock.code}" class="btn btn-sm btn-info">详情</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stocks}">
                    <tr>
                        <td colspan="7" class="text-center">暂无数据</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 