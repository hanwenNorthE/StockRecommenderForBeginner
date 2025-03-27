<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Include the shared ChatBox component -->
<jsp:include page="../chatbox.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${stock.companyName} - Stock Details</title>
    <!-- use stock.code as a JavaScript variable -->
    <script>
        // directly get stock code from JSP
        var STOCK_CODE = "${stock.code}";
        console.log("JSP defined stock code:", STOCK_CODE);
        
        // if stock code is empty, log the error
        if (!STOCK_CODE || STOCK_CODE.trim() === "") {
            console.error("严重错误：JSP中的股票代码为空！请检查Controller传递的stock对象");
            // try to get stock code from URL
            var urlParams = new URLSearchParams(window.location.search);
            var codeFromUrl = urlParams.get('code');
            if (codeFromUrl) {
                console.log("get stock code from URL:", codeFromUrl);
                STOCK_CODE = codeFromUrl;
            }
        }
    </script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <!-- React needed scripts -->
    <script src="https://unpkg.com/react@17/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
    </style>
</head>
<body>
    <!-- Stock data -->
    <div id="stock-data" style="display:none">
        <div 
            data-code="${stock.code}" 
            data-company-name="${stock.companyName}"
            data-industry="${stock.industry}"
            data-market-value="${stock.marketValue}"
            data-current-price="${stock.currentPrice}"
            data-price-change="${stock.priceChange}"
            data-description="${stockDetail.description}"
        ></div>
    </div>
    
    <!-- News data -->
    <div id="news-data" style="display:none">
        <c:forEach items="${news}" var="item">
            <div class="news-item" 
                 data-title="${item.title}" 
                 data-url="${item.url}" 
                 data-publish-date="${item.publishDate}">
            </div>
        </c:forEach>
    </div>
    
    <!-- React mount point -->
    <div id="stock-detail-root"></div>
    
    <!-- React component -->
    <script type="text/babel">
        const contextPath = "${pageContext.request.contextPath}";
        
        // use the global variable defined in the JSP
        const stockCode = window.STOCK_CODE || "";
        console.log("React used stock code:", stockCode);
        
        // ensure the stock code is valid
        if (!stockCode || stockCode.trim() === "") {
            console.error("stock code is empty, please check if the stock.code is correctly passed from the backend");
        }
        
        // Get stock data from DOM element
        const stockElement = document.querySelector('#stock-data div');
        
        const STOCK_DATA = {
            code: stockCode, // use the directly defined variable instead of getting from DOM
            companyName: stockElement.getAttribute('data-company-name') || '',
            industry: stockElement.getAttribute('data-industry') || '',
            marketValue: stockElement.getAttribute('data-market-value') || '',
            currentPrice: stockElement.getAttribute('data-current-price') || '0',
            priceChange: parseFloat(stockElement.getAttribute('data-price-change') || 0),
            description: stockElement.getAttribute('data-description') || 'No description available'
        };
        
        // Debug log to verify stock data
        console.log("Stock data object:", STOCK_DATA);
        
        // Get news data from DOM element
        const NEWS_DATA = [];
        const newsElements = document.querySelectorAll('#news-data .news-item');
        newsElements.forEach(element => {
            NEWS_DATA.push({
                title: element.getAttribute('data-title'),
                url: element.getAttribute('data-url'),
                publishDate: element.getAttribute('data-publish-date')
            });
        });
        
        // Navigation Bar component
        const NavigationBar = () => {
            const [showMenu, setShowMenu] = React.useState(false);
            
            return (
                <nav className="bg-white shadow-md py-4 px-8">
                    <div className="flex justify-between items-center">
                        <h1 className="text-2xl font-bold text-indigo-700">StockFinder</h1>
                        
                        {/* Mobile menu button */}
                        <div className="md:hidden">
                            <button onClick={() => setShowMenu(!showMenu)} className="text-gray-500 focus:outline-none">
                                <svg className="h-6 w-6" fill="none" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" viewBox="0 0 24 24" stroke="currentColor">
                                    <path d={showMenu ? "M6 18L18 6M6 6l12 12" : "M4 6h16M4 12h16M4 18h16"}></path>
                                </svg>
                            </button>
                        </div>
                        
                        {/* Desktop menu */}
                        <ul className="hidden md:flex space-x-6 text-gray-700">
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href={contextPath + "/"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">Home</a>
                            </li>
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href={contextPath + "/stocks"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">Stocks</a>
                            </li>
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href={contextPath + "/profile"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">Profile</a>
                            </li>
                        </ul>
                    </div>
                    
                    {/* Mobile dropdown menu */}
                    {showMenu && (
                        <div className="md:hidden mt-4 py-2 bg-white border-t">
                            <a href={contextPath + "/"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">Home</a>
                            <a href={contextPath + "/stocks"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">Stocks</a>
                            <a href={contextPath + "/profile"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">Profile</a>
                        </div>
                    )}
                </nav>
            );
        };
        
        // Breadcrumb component
        const Breadcrumb = () => {
            return (
                <nav className="bg-white p-4 rounded-lg shadow mb-6">
                    <ol className="list-reset flex text-gray-600">
                        <li><a href={contextPath + "/"} className="text-indigo-600 hover:text-indigo-800">Home</a></li>
                        <li className="mx-2">/</li>
                        <li><a href={contextPath + "/stocks"} className="text-indigo-600 hover:text-indigo-800">Stock List</a></li>
                        <li className="mx-2">/</li>
                        <li className="text-gray-700">Stock Details</li>
                    </ol>
                </nav>
            );
        };
        
        // Stock Info component
        const StockInfo = ({ stock }) => {
            const priceChangeClass = stock.priceChange >= 0 ? 
                "bg-green-100 text-green-800" : 
                "bg-red-100 text-red-800";
            
            return (
                <div className="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
                    <div className="bg-gradient-to-r from-indigo-600 to-blue-500 px-6 py-4">
                        <h2 className="text-2xl font-bold text-white">{stock.code} - {stock.companyName}</h2>
                    </div>
                    <div className="p-6">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <h3 className="text-xl font-semibold text-gray-800 mb-4">Basic Information</h3>
                                <div className="space-y-2">
                                    <p className="flex justify-between">
                                        <span className="text-gray-600 font-medium">Stock Code:</span>
                                        <span className="text-gray-800">{stock.code}</span>
                                    </p>
                                    <p className="flex justify-between">
                                        <span className="text-gray-600 font-medium">Company Name:</span>
                                        <span className="text-gray-800">{stock.companyName}</span>
                                    </p>
                                    <p className="flex justify-between">
                                        <span className="text-gray-600 font-medium">Industry:</span>
                                        <span className="text-gray-800">{stock.industry}</span>
                                    </p>
                                    <p className="flex justify-between">
                                        <span className="text-gray-600 font-medium">Market Value:</span>
                                        <span className="text-gray-800">{stock.marketValue}</span>
                                    </p>
                                </div>
                            </div>
                            <div>
                                <h3 className="text-xl font-semibold text-gray-800 mb-4">Price Information</h3>
                                <div className="space-y-2">
                                    <p className="flex justify-between">
                                        <span className="text-gray-600 font-medium">Current Price:</span>
                                        <span className="text-gray-800">${stock.currentPrice}</span>
                                    </p>
                                    <p className="flex justify-between">
                                        <span className="text-gray-600 font-medium">Price Change:</span>
                                        <span className={`px-3 py-1 rounded-full ${priceChangeClass}`}>
                                            {stock.priceChange >= 0 ? '+' : ''}{stock.priceChange}%
                                        </span>
                                    </p>
                                </div>
                                
                                <div className="mt-8">
                                    <h3 className="text-xl font-semibold text-gray-800 mb-4">Company Description</h3>
                                    <p className="text-gray-700">{stock.description}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            );
        };
        
        // Stock Chart component
        const StockChart = ({ stockCode }) => {
            const [status, setStatus] = React.useState("Loading stock price data...");
            const [activeTimeframe, setActiveTimeframe] = React.useState("daily");
            const chartRef = React.useRef(null);
            const chartInstance = React.useRef(null);
            
            // get the final valid stock code
            const getValidStockCode = () => {
                // use the passed stockCode first, then the global STOCK_CODE, finally try to get from URL
                if (stockCode && stockCode.trim()) return stockCode.trim();
                if (window.STOCK_CODE && window.STOCK_CODE.trim()) return window.STOCK_CODE.trim();
                
                // try to get from URL
                try {
                    const urlParams = new URLSearchParams(window.location.search);
                    const codeFromUrl = urlParams.get('code');
                    if (codeFromUrl && codeFromUrl.trim()) {
                        console.log("get stock code from URL:", codeFromUrl);
                        return codeFromUrl.trim();
                    }
                } catch (e) {
                    console.error("cannot get stock code from URL", e);
                }
                
                return ""; // no valid stock code
            };
            
            // debug function
            const debugStockCode = () => {
                console.log("StockChart component received stock code:", stockCode);
                console.log("stock code in global variable:", window.STOCK_CODE);
                console.log("stock code in STOCK_DATA:", STOCK_DATA.code);
                
                // get and return the valid stock code
                const validCode = getValidStockCode();
                console.log("final used stock code:", validCode);
                return validCode;
            };
            
            React.useEffect(() => {
                // use the debug function to get the valid stock code
                const validStockCode = debugStockCode();
                
                if (validStockCode && validStockCode.trim() !== '') {
                    console.log(`Initializing chart for stock: ${validStockCode}`);
                    setTimeout(() => {
                        fetchStockData(validStockCode, 'daily');
                    }, 500);
                } else {
                    console.error('严重错误: 无法获取有效的股票代码，无法加载图表');
                    setStatus('错误: 无法获取股票代码。请确保URL包含有效的股票代码，例如 ?code=AAPL');
                }
            }, [stockCode]);
            
            const fetchStockData = (ticker, timeframe) => {
                // get the final valid stock code
                ticker = ticker || getValidStockCode();
                
                if (!ticker || ticker.trim() === '') {
                    console.error('严重错误: 股票代码为空，无法请求数据');
                    setStatus('错误: 股票代码缺失');
                    return;
                }
                
                ticker = ticker.trim(); // 确保去除空格
                
                setStatus("loading data...");
                setActiveTimeframe(timeframe);
                
                console.log(`get stock data: ${ticker}, timeframe: ${timeframe}`);
                const apiUrl = `/stocks/api/timeseries?code=\${ticker}&timeframe=\${timeframe}`;
                console.log(`API URL: ${apiUrl}`);
                
                fetch(apiUrl)
                    .then(response => {
                        console.log(`response status: ${response.status}`);
                        return response.json();
                    })
                    .then(data => {
                        console.log("API response:", data);
                        if (data.success) {
                            processChartData(data, timeframe);
                        } else {
                            setStatus(data.error || 'error loading stock data');
                            console.error('API error:', data.error);
                        }
                    })
                    .catch(error => {
                        setStatus('error loading stock data. please try again later.');
                        console.error('error loading stock data:', error);
                    });
            };
            
            const processChartData = (data, timeframe) => {
                const timeSeriesData = data.timeSeries;
                
                const dates = [];
                const closePrices = [];
                
                let count = 0;
                const limit = 100;
                
                const sortedDates = Object.keys(timeSeriesData).sort();
                
                for (let i = sortedDates.length - 1; i >= 0 && count < limit; i--) {
                    const date = sortedDates[i];
                    dates.unshift(date);
                    closePrices.unshift(parseFloat(timeSeriesData[date]['4. close']));
                    count++;
                }
                
                createChart(dates, closePrices, timeframe);
                
                setStatus(`Showing ${timeframe} price data (last ${dates.length} periods)`);
            };
            
            const createChart = (dates, prices, timeframe) => {
                const ctx = chartRef.current.getContext('2d');
                
                if (chartInstance.current) {
                    chartInstance.current.destroy();
                }
                
                chartInstance.current = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: dates,
                        datasets: [{
                            label: `${timeframe.charAt(0).toUpperCase() + timeframe.slice(1)} Close Price`,
                            data: prices,
                            backgroundColor: 'rgba(99, 102, 241, 0.2)',
                            borderColor: 'rgba(99, 102, 241, 1)',
                            borderWidth: 2,
                            pointRadius: 1,
                            pointHoverRadius: 5,
                            tension: 0.1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                ticks: {
                                    maxTicksLimit: 10,
                                    maxRotation: 45,
                                    minRotation: 45
                                }
                            },
                            y: {
                                beginAtZero: false
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return `$${context.parsed.y.toFixed(2)}`;
                                    }
                                }
                            }
                        }
                    }
                });
            };
            
            return (
                <div className="bg-white rounded-xl shadow-lg overflow-hidden mb-6">
                    <div className="px-6 py-4">
                        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-4">
                            <h3 className="text-xl font-semibold text-gray-800 mb-2 md:mb-0">Stock Price History</h3>
                            <div className="inline-flex rounded-md shadow-sm">
                                <button 
                                    type="button" 
                                    onClick={() => fetchStockData(stockCode, 'daily')}
                                    className={`px-4 py-2 text-sm font-medium rounded-l-lg \${
                                        activeTimeframe === 'daily' 
                                            ? 'bg-indigo-600 text-white' 
                                            : 'bg-white text-gray-700 hover:bg-gray-50'
                                    } border border-gray-300`}
                                >
                                    Daily
                                </button>
                                <button 
                                    type="button" 
                                    onClick={() => fetchStockData(stockCode, 'weekly')}
                                    className={`px-4 py-2 text-sm font-medium \${
                                        activeTimeframe === 'weekly' 
                                            ? 'bg-indigo-600 text-white' 
                                            : 'bg-white text-gray-700 hover:bg-gray-50'
                                    } border-t border-b border-gray-300`}
                                >
                                    Weekly
                                </button>
                                <button 
                                    type="button" 
                                    onClick={() => fetchStockData(stockCode, 'monthly')}
                                    className={`px-4 py-2 text-sm font-medium rounded-r-lg \${
                                        activeTimeframe === 'monthly' 
                                            ? 'bg-indigo-600 text-white' 
                                            : 'bg-white text-gray-700 hover:bg-gray-50'
                                    } border border-gray-300`}
                                >
                                    Monthly
                                </button>
                            </div>
                        </div>
                        
                        <div className="relative h-96">
                            <canvas ref={chartRef}></canvas>
                        </div>
                        
                        <div className="text-center mt-2 text-sm text-gray-500">
                            <span>{status}</span>
                        </div>
                    </div>
                </div>
            );
        };
        
        // News component
        const NewsSection = ({ news }) => {
            return (
                <div className="bg-white rounded-xl shadow-lg overflow-hidden">
                    <div className="bg-gradient-to-r from-gray-700 to-gray-800 px-6 py-4">
                        <h3 className="text-xl font-semibold text-white">Related News</h3>
                    </div>
                    <div className="p-4">
                        {news.length === 0 ? (
                            <p className="text-gray-500 text-center py-4">No related news</p>
                        ) : (
                            <ul className="divide-y divide-gray-200">
                                {news.map((item, index) => (
                                    <li key={index} className="py-4">
                                        <a 
                                            href={item.url} 
                                            target="_blank" 
                                            className="block hover:bg-gray-50 p-2 rounded transition"
                                        >
                                            <h4 className="text-indigo-600 font-medium hover:text-indigo-800 mb-1">{item.title}</h4>
                                            <span className="text-sm text-gray-500">{item.publishDate}</span>
                                        </a>
                                    </li>
                                ))}
                            </ul>
                        )}
                    </div>
                </div>
            );
        };
        
        // Footer component
        const Footer = () => {
            return (
                <footer className="bg-gray-800 text-white py-8 px-4">
                    <div className="max-w-7xl mx-auto">
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                            <div>
                                <h3 className="text-xl font-bold mb-4">StockFinder</h3>
                                <p className="text-gray-400">Provide stock recommendation and investment advice for beginners</p>
                            </div>
                            <div>
                                <h3 className="text-xl font-bold mb-4">Links</h3>
                                <ul className="space-y-2">
                                    <li><a href={contextPath + "/"} className="text-gray-400 hover:text-white">Home</a></li>
                                    <li><a href={contextPath + "/login"} className="text-gray-400 hover:text-white">Login/Register</a></li>
                                    <li><a href={contextPath + "/profile"} className="text-gray-400 hover:text-white">Profile</a></li>
                                </ul>
                            </div>
                            <div>
                                <h3 className="text-xl font-bold mb-4">Contact Us</h3>
                                <p className="text-gray-400">hermann@stockfinder.com</p>
                                <p className="text-gray-400">+1 (123) 456-7890</p>
                            </div>
                        </div>
                        <div className="border-t border-gray-700 mt-8 pt-4 text-center">
                            <p>&copy; 2025 CS5200-StockFinder. </p>
                        </div>
                    </div>
                </footer>
            );
        };
        
        // Main Detail Page
        const StockDetailPage = () => {
            // Log the stock code being passed to components
            console.log("Rendering StockDetailPage with stock code:", STOCK_DATA.code);
            
            return (
                <div className="min-h-screen flex flex-col">
                    <NavigationBar />
                    
                    <main className="flex-grow container mx-auto px-4 py-8">
                        <Breadcrumb />
                        
                        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                            <div className="lg:col-span-2">
                                <StockInfo stock={STOCK_DATA} />
                                <StockChart stockCode={STOCK_DATA.code} />
                            </div>
                            
                            <div className="lg:col-span-1">
                                <NewsSection news={NEWS_DATA} />
                                <div className="mt-6">
                                    <ChatBox />
                                </div>
                            </div>
                        </div>
                    </main>
                    
                    <Footer />
                </div>
            );
        };
        
        // Render the page
        ReactDOM.render(<StockDetailPage />, document.getElementById('stock-detail-root'));
    </script>
</body>
</html> 