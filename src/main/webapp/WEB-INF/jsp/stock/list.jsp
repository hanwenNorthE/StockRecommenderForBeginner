<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">Stock List</h1>
        
        <div class="row mb-3">
            <div class="col">
                <form action="/stocks" method="get" class="d-flex">
                    <input type="text" name="keyword" class="form-control me-2" placeholder="Search for stocks..." value="${param.keyword}">
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>
            <div class="col-auto">
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle" type="button" id="industryDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        Filter by Industry
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="industryDropdown">
                        <li><a class="dropdown-item" href="/stocks">All</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Technology">Technology</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Finance">Finance</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Healthcare">Healthcare</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Consumer Goods">Consumer Goods</a></li>
                        <li><a class="dropdown-item" href="/stocks?industry=Energy">Energy</a></li>
                    </ul>
                </div>
            </div>
        </div>
        
        <table class="table table-striped table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Code</th>
                    <th>Company Name</th>
                    <th>Current Price</th>
                    <th>Price Change</th>
                    <th>Market Value</th>
                    <th>Industry</th>
                    <th>Operation</th>
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
                            <a href="/stocks/detail?code=${stock.code}" class="btn btn-sm btn-info">Details</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty stocks}">
                    <tr>
                        <td colspan="7" class="text-center">No data available</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 