<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Stock Recommendation System</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full p-6 bg-white rounded-lg shadow-lg">
        <div class="text-center">
            <svg class="w-16 h-16 text-red-500 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
            </svg>
            
            <h1 class="text-2xl font-bold text-gray-800 mb-2">Something went wrong</h1>
            
            <p class="text-gray-600 mb-4">
                <c:choose>
                    <c:when test="${not empty error}">
                        ${error}
                    </c:when>
                    <c:when test="${not empty exception}">
                        ${exception.message}
                    </c:when>
                    <c:when test="${not empty pageContext.exception}">
                        ${pageContext.exception.message}
                    </c:when>
                    <c:otherwise>
                        An unexpected error occurred. Please try again later.
                    </c:otherwise>
                </c:choose>
            </p>
            
            <div class="flex space-x-4 justify-center">
                <a href="${pageContext.request.contextPath}/" class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700">
                    Go to Home
                </a>
                <a href="javascript:history.back()" class="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400">
                    Go Back
                </a>
            </div>
        </div>
    </div>
</body>
</html>