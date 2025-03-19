<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${stock.companyName} - Stock Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/stocks">Stock List</a></li>
                <li class="breadcrumb-item active" aria-current="page">Stock Details</li>
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
                                <h4 class="mb-3">Basic Information</h4>
                                <p><strong>Stock Code:</strong> ${stock.code}</p>
                                <p><strong>Company Name:</strong> ${stock.companyName}</p>
                                <p><strong>Industry:</strong> ${stock.industry}</p>
                                <p><strong>Market Value:</strong> ${stock.marketValue}</p>
                            </div>
                            <div class="col-md-6">
                                <h4 class="mb-3">Price Information</h4>
                                <p><strong>Current Price:</strong> $${stock.currentPrice}</p>
                                <p>
                                    <strong>Price Change:</strong> 
                                    <span class="${stock.priceChange >= 0 ? 'text-success' : 'text-danger'}">
                                        ${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange}%
                                    </span>
                                </p>
                            </div>
                        </div>
                        
                        <h4 class="mb-3">Company Description</h4>
                        <p>${stockDetail.description != null ? stockDetail.description : 'No description available'}</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-secondary text-white">
                        Related News
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:if test="${empty news}">
                            <li class="list-group-item">No related news</li>
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