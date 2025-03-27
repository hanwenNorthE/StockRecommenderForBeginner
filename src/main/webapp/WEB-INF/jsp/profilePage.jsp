<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- Include the shared ChatBox component -->
<jsp:include page="chatbox.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Home - Stock Recommendation System</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <!-- React scripts -->
    <script src="https://unpkg.com/react@17/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        /* Markdown content style */
        .markdown-content {
            font-size: 0.95rem;
            line-height: 1.5;
        }
        
        .markdown-content pre {
            max-width: 100%;
            white-space: pre-wrap;
            border-radius: 4px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
        }
        
        .markdown-content code {
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 0.9em;
        }
        
        .markdown-content h1, .markdown-content h2, .markdown-content h3 {
            margin-top: 0.8em;
            margin-bottom: 0.5em;
        }
        
        .markdown-content li {
            margin-bottom: 0.25em;
        }
        
        .markdown-content strong {
            font-weight: 600;
        }
        
        .markdown-content p {
            margin-bottom: 0.5em;
        }
    </style>
</head>
<body>
    <!-- put data into hidden div, but not parse JS directly -->
    <div id="user-data" style="display:none" 
         data-id="${user.id}" 
         data-email="${user.email}" 
         data-firstname="${user.name.firstName}" 
         data-lastname="${user.name.lastName}" 
         data-balance="${accountBalance}">
    </div>
    
    <!-- user holdings data -->
    <div id="holdings-data" style="display:none">
        <c:forEach items="${userHoldings}" var="holding">
            <div class="holding-item" 
                 data-code="${holding.code}" 
                 data-name="${holding.companyName}" 
                 data-quantity="${holding.quantity}">
            </div>
        </c:forEach>
    </div>
    
    <!-- recommended stocks data -->
    <div id="recommended-data" style="display:none">
        <c:forEach items="${recommendedStocks}" var="stock">
            <div class="stock-item" 
                 data-code="${stock.code}" 
                 data-name="${stock.companyName}" 
                 data-change="${stock.priceChange}">
            </div>
        </c:forEach>
    </div>
    
    <!-- React mount point -->
    <div id="profile-root" class="container mx-auto px-4 py-8"></div>
    
    <!-- React components (Profile, Holdings, ChatBox, etc.) -->
    <script type="text/babel">
        const contextPath = "${pageContext.request.contextPath}";
        
        // get user data from DOM element
        const userDataElement = document.getElementById('user-data');
        const USER_DATA = {
            id: userDataElement.getAttribute('data-id'),
            email: userDataElement.getAttribute('data-email'),
            firstName: userDataElement.getAttribute('data-firstname'),
            lastName: userDataElement.getAttribute('data-lastname'),
            accountBalance: userDataElement.getAttribute('data-balance')
        };
        
        // get holdings data from DOM element
        const USER_HOLDINGS = [];
        const holdingElements = document.querySelectorAll('#holdings-data .holding-item');
        holdingElements.forEach(element => {
            USER_HOLDINGS.push({
                code: element.getAttribute('data-code'),
                companyName: element.getAttribute('data-name'),
                quantity: element.getAttribute('data-quantity')
            });
        });
        
        // get recommended stocks data from DOM element
        const RECOMMENDED_STOCKS = [];
        const stockElements = document.querySelectorAll('#recommended-data .stock-item');
        stockElements.forEach(element => {
            RECOMMENDED_STOCKS.push({
                code: element.getAttribute('data-code'),
                companyName: element.getAttribute('data-name'),
                priceChange: parseFloat(element.getAttribute('data-change'))
            });
        });
        
        const ProfileHeader = () => {
            return (
                <div className="bg-white rounded-xl shadow-lg p-6 mb-6">
                    <div className="flex flex-col md:flex-row items-center md:items-start">
                        <div className="w-24 h-24 bg-indigo-100 rounded-full flex items-center justify-center text-indigo-800 text-2xl font-bold mb-4 md:mb-0 md:mr-6">
                            {USER_DATA.firstName.charAt(0)}{USER_DATA.lastName.charAt(0)}
                        </div>
                        <div>
                            <h1 className="text-3xl font-bold text-gray-800">{USER_DATA.firstName} {USER_DATA.lastName}</h1>
                            <p className="text-gray-600">{USER_DATA.email}</p>
                            <div className="mt-3 bg-green-100 text-green-800 px-4 py-2 rounded-lg inline-block">
                                account balance: ${USER_DATA.accountBalance}
                            </div>
                        </div>
                    </div>
                </div>
            );
        };
        
        const StockHoldings = () => {
            return (
                <div className="bg-white rounded-xl shadow-lg p-6 mb-6">
                    <h2 className="text-xl font-bold text-gray-800 mb-4">Holdings</h2>
                    {USER_HOLDINGS.length > 0 ? (
                        <div className="space-y-3">
                            {USER_HOLDINGS.map((stock, index) => (
                                <div key={index} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition duration-150">
                                    <div>
                                        <span className="font-medium text-indigo-700">{stock.code}</span>
                                        <p className="text-sm text-gray-600">{stock.companyName}</p>
                                    </div>
                                    <div className="flex items-center">
                                        <div className="bg-blue-100 text-blue-800 py-1 px-3 rounded-full text-sm mr-2">
                                            holding: {stock.quantity}
                                        </div>
                                        <a href={contextPath + "/stocks/detail?code=" + stock.code} 
                                           className="text-indigo-600 hover:text-indigo-800">
                                            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 9l3 3m0 0l-3 3m3-3H8m13 0a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                            </svg>
                                        </a>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <p className="text-gray-500">no holdings</p>
                    )}
                </div>
            );
        };
        
        const RecommendedStocks = () => {
            return (
                <div className="bg-white rounded-xl shadow-lg p-6">
                    <h2 className="text-xl font-bold text-gray-800 mb-4">Recommended stocks</h2>
                    {RECOMMENDED_STOCKS.length > 0 ? (
                        <div className="space-y-3">
                            {RECOMMENDED_STOCKS.map((stock, index) => (
                                <div key={index} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition duration-150">
                                    <div>
                                        <span className="font-medium text-indigo-700">{stock.code}</span>
                                        <p className="text-sm text-gray-600">{stock.companyName}</p>
                                    </div>
                                    <div className="flex items-center">
                                        <div className={`${stock.priceChange >= 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} py-1 px-3 rounded-full text-sm mr-2`}>
                                            {stock.priceChange >= 0 ? '+' : ''}{stock.priceChange}
                                        </div>
                                        <a href={contextPath + "/stocks/detail?code=" + stock.code} 
                                           className="text-indigo-600 hover:text-indigo-800">
                                            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 9l3 3m0 0l-3 3m3-3H8m13 0a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                            </svg>
                                        </a>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <p className="text-gray-500">no recommended stocks</p>
                    )}
                </div>
            );
        };
        
        const UserProfile = () => {
            return (
                <div className="max-w-5xl mx-auto">
                    <nav className="bg-white shadow-sm rounded-lg p-4 mb-6">
                        <div className="flex justify-between items-center">
                            <div className="flex items-center">
                                <h1 className="text-xl font-bold text-indigo-700">Stock Recommendation System</h1>
                                <div className="flex items-center">
                                    <a href={contextPath + "/"} className="ml-4 text-gray-500 hover:text-indigo-600 transition duration-150">
                                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                    </a>
                                    <a href={contextPath + "/logout"} className="text-gray-500 hover:text-red-500 transition duration-150">
                                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </nav>
                    
                    <ProfileHeader />
                    
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <StockHoldings />
                        <RecommendedStocks />
                    </div>
                </div>
            );
        };
        
        const App = () => {
            return (
                <>
                    <UserProfile />
                    <ChatBox />
                </>
            );
        };
        
        ReactDOM.render(
            <App />, 
            document.getElementById('profile-root')
        );
    </script>
    
<!-- Replace the existing update and delete forms with these corrected versions -->

<!-- Update Profile Form -->
<div class="max-w-3xl mx-auto my-8 p-4 bg-white rounded-lg shadow-md">
    <h2 class="text-xl font-bold mb-4">Update Your Information</h2>
    <form action="${pageContext.request.contextPath}/profile/update" method="post" class="space-y-4">
        <div>
            <label for="newEmail" class="block font-medium">New Email:</label>
            <input type="email" name="email" id="newEmail" class="border border-gray-300 rounded p-2 w-full" 
                   placeholder="Enter new email" value="${user.email}" required>
        </div>
        <div>
            <label for="newPassword" class="block font-medium">New Password:</label>
            <input type="password" name="password" id="newPassword" class="border border-gray-300 rounded p-2 w-full"
                   placeholder="Leave blank if you don't want to change" />
        </div>
        <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700">
            Update Information
        </button>
    </form>
</div>

<!-- Delete Account Form -->
<div class="max-w-3xl mx-auto my-8 p-4 bg-white rounded-lg shadow-md">
    <h2 class="text-xl font-bold mb-4 text-red-600">Close Your Account</h2>
    <form action="${pageContext.request.contextPath}/profile/delete" method="post"
          onsubmit="return confirm('Are you sure you want to delete this account? This action cannot be undone.');">
        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">
            Delete My Account
        </button>
    </form>
</div>

<!-- Display messages (success or error) -->
<div class="max-w-3xl mx-auto">
    <c:if test="${not empty successMessage}">
        <p class="text-green-600 font-bold mt-4">${successMessage}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="text-red-600 font-bold mt-4">${error}</p>
    </c:if>
</div>
