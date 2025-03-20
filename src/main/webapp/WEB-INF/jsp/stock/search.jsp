<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results - ${keyword}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
    </style>
</head>
<body>
    <div class="container mx-auto mt-8 px-4">
        <nav class="bg-white shadow-sm rounded-lg p-4 mb-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center">
                    <h1 class="text-xl font-bold text-indigo-700 mr-4">Stock Recommendation System</h1>
                    <a href="${pageContext.request.contextPath}/" class="text-gray-500 hover:text-indigo-600 transition duration-150">
                        Home
                    </a>
                </div>
            </div>
        </nav>
        
        <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
            <h1 class="text-2xl font-bold text-gray-800 mb-6">Search Results for "${keyword}"</h1>
            
            <div class="mb-4">
                <form action="${pageContext.request.contextPath}/search" method="get" class="flex">
                    <input 
                        type="text" 
                        name="q" 
                        value="${keyword}"
                        class="flex-1 px-4 py-2 rounded-l-lg border focus:outline-none focus:ring-2 focus:ring-indigo-400"
                        placeholder="Search stock code or company name..."
                    />
                    <button 
                        type="submit"
                        class="bg-indigo-600 text-white px-6 py-2 rounded-r-lg hover:bg-indigo-700"
                    >
                        Search
                    </button>
                </form>
            </div>
            
            <div class="mt-8">
                <c:choose>
                    <c:when test="${empty searchResults}">
                        <div class="text-center py-8">
                            <p class="text-gray-500 text-lg">No results found for "${keyword}"</p>
                            <p class="text-gray-400 mt-2">Try searching for a different stock code or company name</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-gray-600 mb-4">Found ${resultCount} results</p>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            <c:forEach items="${searchResults}" var="stock">
                                <div class="bg-gray-50 rounded-lg p-4 hover:shadow-md transition-shadow duration-200">
                                    <div class="flex justify-between items-start mb-3">
                                        <div>
                                            <h3 class="text-lg font-bold text-indigo-700">${stock.code}</h3>
                                            <p class="text-gray-600">${stock.companyName}</p>
                                        </div>
                                        <c:if test="${not empty stock.priceChange}">
                                            <div class="${stock.priceChange >= 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} py-1 px-3 rounded-full text-sm">
                                                ${stock.priceChange >= 0 ? '+' : ''}${stock.priceChange}%
                                            </div>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty stock.industry}">
                                        <p class="text-gray-500 text-sm mb-3">
                                            <span class="font-medium">Industry:</span> ${stock.industry}
                                        </p>
                                    </c:if>
                                    <a 
                                        href="${pageContext.request.contextPath}/stocks/detail?code=${stock.code}" 
                                        class="block text-center bg-indigo-600 text-white py-2 px-4 rounded-lg hover:bg-indigo-700 transition-colors mt-3"
                                    >
                                        View Details
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 