<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- Include the shared ChatBox component -->
<jsp:include page="chatbox.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Recommendation System</title>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <!-- React needed scripts -->
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
    <!-- hot stocks data -->
    <div id="hot-stocks-data" style="display:none">
        <c:forEach items="${hotStocks}" var="stock">
            <div class="stock-item" 
                 data-code="${stock.code}" 
                 data-name="${stock.companyName}" 
                 data-change="${stock.priceChange}">
            </div>
        </c:forEach>
    </div>
    
    <!-- React mount point -->
    <div id="main-root"></div>
    
    <!-- React component -->
    <script type="text/babel">
        const contextPath = "${pageContext.request.contextPath}";
        
        // get hot stocks data from DOM element
        const HOT_STOCKS = [];
        const stockElements = document.querySelectorAll('#hot-stocks-data .stock-item');
        stockElements.forEach(element => {
            HOT_STOCKS.push({
                code: element.getAttribute('data-code'),
                companyName: element.getAttribute('data-name'),
                priceChange: parseFloat(element.getAttribute('data-change') || 0)
            });
        });
        
        // recommended stocks data (simulated data)
        const RECOMMENDED_STOCKS = [
            {
                code: "NVDA",
                companyName: "NVIDIA Corporation",
                logo: "https://logo.clearbit.com/nvidia.com",
                description: "Leader in AI and graphics processing"
            },
            {
                code: "AMZN",
                companyName: "Amazon.com, Inc.",
                logo: "https://logo.clearbit.com/amazon.com",
                description: "E-commerce and cloud computing giant"
            },
            {
                code: "GOOGL",
                companyName: "Alphabet Inc.",
                logo: "https://logo.clearbit.com/google.com",
                description: "Internet services and products"
            }
        ];
        
        // navigation bar component
        const NavigationBar = () => {
            const [showMenu, setShowMenu] = React.useState(false);
            
            return (
                <nav className="bg-white shadow-md py-4 px-8">
                    <div className="flex justify-between items-center">
                        <h1 className="text-2xl font-bold text-indigo-700">StockFinder</h1>
                        
                        {/* mobile menu button */}
                        <div className="md:hidden">
                            <button onClick={() => setShowMenu(!showMenu)} className="text-gray-500 focus:outline-none">
                                <svg className="h-6 w-6" fill="none" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" viewBox="0 0 24 24" stroke="currentColor">
                                    <path d={showMenu ? "M6 18L18 6M6 6l12 12" : "M4 6h16M4 12h16M4 18h16"}></path>
                                </svg>
                            </button>
                        </div>
                        
                        {/* desktop menu */}
                        <ul className="hidden md:flex space-x-6 text-gray-700">
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href={contextPath + "/"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">home</a>
                            </li>
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href={contextPath + "/login"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">login/register</a>
                            </li>
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href={contextPath + "/profile"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">profile</a>
                            </li>
                        </ul>
                    </div>
                    
                    {/* mobile dropdown menu */}
                    {showMenu && (
                        <div className="md:hidden mt-4 py-2 bg-white border-t">
                            <a href={contextPath + "/"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">home</a>
                            <a href={contextPath + "/login"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">login/register</a>
                            <a href={contextPath + "/profile"} className="block py-2 px-4 text-gray-700 hover:bg-gray-100">profile</a>
                        </div>
                    )}
                </nav>
            );
        };
        
        // search bar component
        const SearchBar = () => {
            const [searchTerm, setSearchTerm] = React.useState("");
            
            const handleSubmit = (e) => {
                e.preventDefault();
                if (searchTerm.trim()) {
                    // avoid using template strings and encodeURIComponent, use string concatenation and escape function instead
                    const encodedTerm = escape(searchTerm.trim());
                    window.location.href = contextPath + "/search?q=" + encodedTerm;
                }
            };
            
            return (
                <div className="bg-gradient-to-r from-indigo-600 to-blue-500 py-16 px-4">
                    <div className="max-w-7xl mx-auto text-center">
                        <h1 className="text-4xl font-bold text-white mb-8">Stock Recommendation System for Beginners</h1>
                        <p className="text-xl text-white mb-8">use our intelligent recommendation system, provide personalized stock advice for beginners</p>
                        
                        <form onSubmit={handleSubmit} className="flex flex-col md:flex-row justify-center">
                            <input
                                type="text"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="w-full md:w-96 px-6 py-3 rounded-lg md:rounded-r-none border border-transparent focus:outline-none focus:ring-2 focus:ring-indigo-400"
                                placeholder="search stock code or company name..."
                            />
                            <button
                                type="submit"
                                className="mt-2 md:mt-0 bg-indigo-800 text-white px-6 py-3 rounded-lg md:rounded-l-none hover:bg-indigo-900"
                            >
                                search
                            </button>
                        </form>
                    </div>
                </div>
            );
        };
        
        // stock grid component
        const StockGrid = () => {
            return (
                <div className="py-16 px-4 bg-gray-50">
                    <div className="max-w-7xl mx-auto">
                        <h2 className="text-3xl font-bold text-gray-800 mb-8 text-center">Recommended stocks</h2>
                        
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                            {RECOMMENDED_STOCKS.map((stock, index) => (
                                <div key={index} className="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                                    <div className="p-6">
                                        <div className="flex items-center mb-4">
                                            <img 
                                                src={stock.logo} 
                                                alt={stock.companyName} 
                                                className="w-12 h-12 mr-4 rounded-lg"
                                                onError={(e) => {
                                                    e.target.onerror = null;
                                                    e.target.src = 'https://via.placeholder.com/48?text=' + stock.code;
                                                }}
                                            />
                                            <div>
                                                <h3 className="text-xl font-bold text-indigo-700">{stock.code}</h3>
                                                <p className="text-gray-600">{stock.companyName}</p>
                                            </div>
                                        </div>
                                        <p className="text-gray-700 mb-4">{stock.description}</p>
                                        <a href={contextPath + "/stocks/detail?code=" + stock.code}
                                           className="block text-center bg-indigo-600 text-white py-2 px-4 rounded-lg hover:bg-indigo-700 transition-colors">
                                            learn more
                                        </a>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            );
        };
        
        // hot stocks component
        const HotStocks = () => {
            return (
                <div className="py-16 px-4 bg-white">
                    <div className="max-w-7xl mx-auto">
                        <h2 className="text-3xl font-bold text-gray-800 mb-8 text-center">hot stocks</h2>
                        
                        {HOT_STOCKS.length > 0 ? (
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                {HOT_STOCKS.map((stock, index) => {
                                    const priceChangeClass = stock.priceChange >= 0 ? 
                                        "bg-green-100 text-green-800" : 
                                        "bg-red-100 text-red-800";
                                    const priceChangePrefix = stock.priceChange >= 0 ? "+" : "";
                                    return (
                                        <div key={index} className="bg-gray-50 rounded-lg p-4 flex justify-between items-center">
                                            <div>
                                                <span className="font-medium text-indigo-700">{stock.code}</span>
                                                <p className="text-gray-600">{stock.companyName}</p>
                                            </div>
                                            <div className={"py-1 px-3 rounded-full text-sm " + priceChangeClass}>
                                                {priceChangePrefix}{stock.priceChange}
                                            </div>
                                        </div>
                                    );
                                })}
                            </div>
                        ) : (
                            <p className="text-center text-gray-500">no hot stocks data</p>
                        )}
                    </div>
                </div>
            );
        };
        
        // footer component
        const Footer = () => {
            return (
                <footer className="bg-gray-800 text-white py-8 px-4">
                    <div className="max-w-7xl mx-auto">
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                            <div>
                                <h3 className="text-xl font-bold mb-4">StockFinder</h3>
                                <p className="text-gray-400">provide stock recommendation and investment advice for beginners</p>
                            </div>
                            <div>
                                <h3 className="text-xl font-bold mb-4">links</h3>
                                <ul className="space-y-2">
                                    <li><a href={contextPath + "/"} className="text-gray-400 hover:text-white">home</a></li>
                                    <li><a href={contextPath + "/login"} className="text-gray-400 hover:text-white">login/register</a></li>
                                    <li><a href={contextPath + "/profile"} className="text-gray-400 hover:text-white">profile</a></li>
                                </ul>
                            </div>
                            <div>
                                <h3 className="text-xl font-bold mb-4">contact us</h3>
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
        
        // MAIN PAGE
        const MainPage = () => {
            return (
                <div className="min-h-screen flex flex-col">
                    <NavigationBar />
                    <SearchBar />
                    <StockGrid />
                    <HotStocks />
                    <Footer />
                    <ChatBox />
                </div>
            );
        };
        
        // RENDER MAIN PAGE
        ReactDOM.render(<MainPage />, document.getElementById('main-root'));
    </script>
</body>
</html>
