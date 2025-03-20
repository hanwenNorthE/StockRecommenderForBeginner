<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Stock Recommendation System</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <!-- React需要的脚本 -->
    <script src="https://unpkg.com/react@17/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        /* Markdown内容样式 */
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
    <!-- 热门股票数据 -->
    <div id="hot-stocks-data" style="display:none">
        <c:forEach items="${hotStocks}" var="stock">
            <div class="stock-item" 
                 data-code="${stock.code}" 
                 data-name="${stock.companyName}" 
                 data-change="${stock.priceChange}">
            </div>
        </c:forEach>
    </div>
    
    <!-- React挂载点 -->
    <div id="main-root"></div>
    
    <!-- React组件 -->
    <script type="text/babel">
        // 从DOM元素中获取热门股票数据
        const HOT_STOCKS = [];
        const stockElements = document.querySelectorAll('#hot-stocks-data .stock-item');
        stockElements.forEach(element => {
            HOT_STOCKS.push({
                code: element.getAttribute('data-code'),
                companyName: element.getAttribute('data-name'),
                priceChange: parseFloat(element.getAttribute('data-change') || 0)
            });
        });
        
        // 股票推荐数据 (模拟数据)
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
        
        // 导航栏组件
        const NavigationBar = () => {
            const [showMenu, setShowMenu] = React.useState(false);
            
            return (
                <nav className="bg-white shadow-md py-4 px-8">
                    <div className="flex justify-between items-center">
                        <h1 className="text-2xl font-bold text-indigo-700">StockFinder</h1>
                        
                        {/* 移动端菜单按钮 */}
                        <div className="md:hidden">
                            <button onClick={() => setShowMenu(!showMenu)} className="text-gray-500 focus:outline-none">
                                <svg className="h-6 w-6" fill="none" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" viewBox="0 0 24 24" stroke="currentColor">
                                    <path d={showMenu ? "M6 18L18 6M6 6l12 12" : "M4 6h16M4 12h16M4 18h16"}></path>
                                </svg>
                            </button>
                        </div>
                        
                        {/* 桌面端菜单 */}
                        <ul className="hidden md:flex space-x-6 text-gray-700">
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href="${pageContext.request.contextPath}/">home</a>
                            </li>
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href="${pageContext.request.contextPath}/login">login/register</a>
                            </li>
                            <li className="hover:text-indigo-700 cursor-pointer">
                                <a href="${pageContext.request.contextPath}/profile">profile</a>
                            </li>
                        </ul>
                    </div>
                    
                    {/* 移动端下拉菜单 */}
                    {showMenu && (
                        <div className="md:hidden mt-4 py-2 bg-white border-t">
                            <a href="${pageContext.request.contextPath}/" className="block py-2 px-4 text-gray-700 hover:bg-gray-100">home</a>
                            <a href="${pageContext.request.contextPath}/login" className="block py-2 px-4 text-gray-700 hover:bg-gray-100">login/register</a>
                            <a href="${pageContext.request.contextPath}/profile" className="block py-2 px-4 text-gray-700 hover:bg-gray-100">profile</a>
                        </div>
                    )}
                </nav>
            );
        };
        
        // 搜索栏组件
        const SearchBar = () => {
            const [searchTerm, setSearchTerm] = React.useState("");
            
            const handleSubmit = (e) => {
                e.preventDefault();
                if (searchTerm.trim()) {
                    // 避免使用模板字符串和encodeURIComponent，改用字符串连接和escape函数
                    const contextPath = "${pageContext.request.contextPath}";
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
        
        // 股票网格组件
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
                                        <a href="${pageContext.request.contextPath}/stock/${stock.code}" 
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
        
        // 热门股票组件
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
        
        // 页脚组件
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
                                    <li><a href="${pageContext.request.contextPath}/" className="text-gray-400 hover:text-white">home</a></li>
                                    <li><a href="${pageContext.request.contextPath}/login" className="text-gray-400 hover:text-white">login/register</a></li>
                                    <li><a href="${pageContext.request.contextPath}/profile" className="text-gray-400 hover:text-white">profile</a></li>
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
        
        // 聊天盒子组件
        const ChatBox = () => {
            const [isOpen, setIsOpen] = React.useState(false);
            const [messages, setMessages] = React.useState([]);
            const [input, setInput] = React.useState('');
            const [isLoading, setIsLoading] = React.useState(false);
            const [sessionId, setSessionId] = React.useState('session_' + Math.random().toString(36).substring(2, 15));
            const [chatSize, setChatSize] = React.useState({ width: 500, height: 400 });
            const chatRef = React.useRef(null);
            
            // 处理Markdown格式的函数
            const formatMarkdown = (text) => {
                if (!text) return '';
                
                // 处理代码块 ```code```
                text = text.replace(/```([\s\S]*?)```/g, '<pre class="bg-gray-800 text-gray-200 p-2 rounded my-2 overflow-x-auto"><code>$1</code></pre>');
                
                // 处理行内代码 `code`
                text = text.replace(/`([^`]+)`/g, '<code class="bg-gray-200 text-gray-800 px-1 rounded">$1</code>');
                
                // 处理标题 # Heading
                text = text.replace(/^# (.*$)/gm, '<h1 class="text-xl font-bold my-2">$1</h1>');
                text = text.replace(/^## (.*$)/gm, '<h2 class="text-lg font-bold my-2">$1</h2>');
                text = text.replace(/^### (.*$)/gm, '<h3 class="text-md font-bold my-2">$1</h3>');
                
                // 处理粗体 **text**
                text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
                
                // 处理斜体 *text*
                text = text.replace(/\*([^*]+)\*/g, '<em>$1</em>');
                
                // 处理无序列表 - item
                text = text.replace(/^\s*-\s*(.*$)/gm, '<li class="ml-4">• $1</li>');
                
                // 处理有序列表 1. item
                text = text.replace(/^\s*(\d+)\.\s*(.*$)/gm, '<li class="ml-4">$1. $2</li>');
                
                // 处理分隔线 ---
                text = text.replace(/^\s*---\s*$/gm, '<hr class="my-2 border-gray-300" />');
                
                // 处理表格
                if (text.includes('|')) {
                    const lines = text.split('\n');
                    let inTable = false;
                    let tableHTML = '<table class="w-full border-collapse my-2">';
                    let headerProcessed = false;
                    
                    for (let i = 0; i < lines.length; i++) {
                        const line = lines[i].trim();
                        if (line.startsWith('|') && line.endsWith('|')) {
                            if (!inTable) {
                                inTable = true;
                            }
                            
                            // 处理表头或内容行
                            const cells = line.split('|').filter(cell => cell.trim() !== '');
                            const tag = !headerProcessed ? 'th' : 'td';
                            const cellClass = !headerProcessed ? 'font-bold border px-2 py-1 bg-gray-100' : 'border px-2 py-1';
                            
                            tableHTML += '<tr>';
                            cells.forEach(cell => {
                                tableHTML += `<${tag} class="${cellClass}">${cell.trim()}</${tag}>`;
                            });
                            tableHTML += '</tr>';
                            
                            // 检查下一行是否为分隔符行 (| --- | --- |)
                            if (!headerProcessed && i + 1 < lines.length && lines[i + 1].includes('-')) {
                                headerProcessed = true;
                                i++; // 跳过分隔符行
                            }
                        } else if (inTable) {
                            inTable = false;
                            tableHTML += '</table>';
                            lines[i] = tableHTML;
                            tableHTML = '<table class="w-full border-collapse my-2">';
                            headerProcessed = false;
                        }
                    }
                    
                    if (inTable) {
                        tableHTML += '</table>';
                        lines.push(tableHTML);
                    }
                    
                    text = lines.join('\n');
                }
                
                // 处理正常链接 [text](url)
                text = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" class="text-blue-600 hover:underline" target="_blank">$1</a>');
                
                // 处理段落和换行
                // 先替换双换行为临时标记
                text = text.replace(/\n\s*\n/g, '{{PARAGRAPH_BREAK}}');
                
                // 将单个换行替换为<br>
                text = text.replace(/\n/g, '<br>');
                
                // 恢复段落
                text = text.replace(/{{PARAGRAPH_BREAK}}/g, '</p><p class="my-2">');
                
                // 包装在段落标签中
                if (!text.startsWith('<')) {
                    text = '<p class="my-2">' + text;
                }
                if (!text.endsWith('>')) {
                    text += '</p>';
                }
                
                return text;
            };

            const handleSend = () => {
                if (input.trim()) {
                    // 添加用户消息到聊天记录
                    const userMessage = { text: input, sender: 'user' };
                    setMessages(prev => [...prev, userMessage]);
                    
                    // 清空输入框
                    setInput('');
                    
                    // 显示加载状态
                    setIsLoading(true);
                    
                    // 调用后端AI聊天API
                    const contextPath = "${pageContext.request.contextPath}";
                    const url = contextPath + "/api/chat?sessionId=" + encodeURIComponent(sessionId) + "&message=" + encodeURIComponent(input.trim());
                    
                    // 发送请求
                    fetch(url, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('network response error');
                        }
                        return response.json();
                    })
                    .then(data => {
                        // 添加AI回复到聊天记录
                        setMessages(prev => [...prev, { 
                            text: data.message, 
                            sender: 'system' 
                        }]);
                    })
                    .catch(error => {
                        console.error('error when calling AI chat API:', error);
                        setMessages(prev => [...prev, { 
                            text: "sorry, there is an error when calling AI chat API. please try again later.", 
                            sender: 'system' 
                        }]);
                    })
                    .finally(() => {
                        setIsLoading(false);
                    });
                }
            };
            
            // 处理按下Enter键事件
            const handleKeyDown = (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleSend();
                }
            };
            
            return (
                <>
                    {/* 聊天按钮 */}
                    <button 
                        onClick={() => setIsOpen(!isOpen)}
                        className="fixed bottom-4 right-4 bg-indigo-600 text-white p-3 rounded-full shadow-lg hover:bg-indigo-700 z-50"
                    >
                        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path>
                        </svg>
                    </button>
                    
                    {/* 聊天窗口 */}
                    {isOpen && (
                        <div 
                            ref={chatRef}
                            className="fixed bottom-16 right-4 bg-white rounded-lg shadow-xl z-50 overflow-hidden"
                            style={{ 
                                width: chatSize.width + 'px',
                                height: chatSize.height + 'px'
                            }}
                        >
                            <div className="p-4 bg-indigo-600 text-white rounded-t-lg flex justify-between items-center">
                                <h3 className="font-bold">AI Investment assistant</h3>
                                <div className="flex items-center">
                                    <span className="text-xs text-gray-200 mr-2">drag to resize</span>
                                    <button onClick={() => setIsOpen(false)} className="text-white">
                                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            
                            <div className="overflow-y-auto" style={{ height: 'calc(100% - 135px)' }}>
                                <div className="p-4">
                                    {messages.length === 0 ? (
                                        <div className="text-center text-gray-500 py-8">
                                            <p>Hi!I am AI Investment assistant, You can ask me any questions, like：</p>
                                            <p className="mt-2 text-indigo-600">- How is AAPL historical performance？</p>
                                            <p className="text-indigo-600">- Is NVDA a good investment？</p>
                                            <p className="text-indigo-600">- Analyze AMZN stock</p>
                                        </div>
                                    ) : (
                                        <div className="space-y-3">
                                            {messages.map((msg, index) => {
                                                const flexClass = msg.sender === 'user' ? "flex justify-end" : "flex justify-start";
                                                const msgStyle = msg.sender === 'user' ? 
                                                    "max-w-xs px-4 py-2 rounded-lg bg-indigo-100 text-indigo-800" : 
                                                    "max-w-xs px-4 py-2 rounded-lg bg-gray-100 text-gray-800 markdown-content";
                                                return (
                                                    <div key={index} className={flexClass}>
                                                        {msg.sender === 'user' ? (
                                                            <div className={msgStyle}>
                                                                {msg.text}
                                                            </div>
                                                        ) : (
                                                            <div className={msgStyle} 
                                                                dangerouslySetInnerHTML={{__html: formatMarkdown(msg.text)}}>
                                                            </div>
                                                        )}
                                                    </div>
                                                );
                                            })}
                                            
                                            {isLoading && (
                                                <div className="flex justify-start">
                                                    <div className="max-w-xs px-4 py-2 rounded-lg bg-gray-100 text-gray-800">
                                                        <div className="flex items-center space-x-2">
                                                            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                                                            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{animationDelay: '0.2s'}}></div>
                                                            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{animationDelay: '0.4s'}}></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            )}
                                        </div>
                                    )}
                                </div>
                            </div>
                            
                            <div className="p-4 border-t absolute bottom-0 w-full bg-white">
                                <div className="flex">
                                    <textarea 
                                        value={input}
                                        onChange={(e) => setInput(e.target.value)}
                                        onKeyDown={handleKeyDown}
                                        placeholder="please enter your question..."
                                        className="flex-1 px-3 py-2 border rounded-l-lg focus:outline-none focus:ring-2 focus:ring-indigo-400 resize-none"
                                        rows="2"
                                    />
                                    <button 
                                        onClick={handleSend}
                                        disabled={isLoading}
                                        className={`${isLoading ? 'bg-gray-400' : 'bg-indigo-600 hover:bg-indigo-700'} text-white px-4 py-2 rounded-r-lg`}
                                    >
                                        {isLoading ? 'sending...' : 'send'}
                                    </button>
                                </div>
                            </div>
                            
                            {/* 调整大小的句柄 */}
                            <div 
                                className="absolute top-0 left-0 w-8 h-8 cursor-nwse-resize z-10 flex items-start justify-start"
                                onMouseDown={(e) => {
                                    e.preventDefault();
                                    const startX = e.clientX;
                                    const startY = e.clientY;
                                    const startWidth = chatRef.current.offsetWidth;
                                    const startHeight = chatRef.current.offsetHeight;
                                    const startRight = window.innerWidth - (chatRef.current.getBoundingClientRect().left + startWidth);
                                    const startBottom = window.innerHeight - (chatRef.current.getBoundingClientRect().top + startHeight);
                                    
                                    const handleMouseMove = (moveEvent) => {
                                        const diffX = startX - moveEvent.clientX;
                                        const diffY = startY - moveEvent.clientY;
                                        
                                        const newWidth = Math.max(300, startWidth + diffX);
                                        const newHeight = Math.max(300, startHeight + diffY);
                                        
                                        // 修改元素样式保持右下角位置不变
                                        chatRef.current.style.right = startRight + 'px';
                                        chatRef.current.style.bottom = startBottom + 'px';
                                        chatRef.current.style.left = 'auto';
                                        chatRef.current.style.top = 'auto';
                                        
                                        setChatSize({
                                            width: newWidth,
                                            height: newHeight
                                        });
                                    };
                                    
                                    const handleMouseUp = () => {
                                        document.removeEventListener('mousemove', handleMouseMove);
                                        document.removeEventListener('mouseup', handleMouseUp);
                                    };
                                    
                                    document.addEventListener('mousemove', handleMouseMove);
                                    document.addEventListener('mouseup', handleMouseUp);
                                }}
                            >
                                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M2 2H6M2 2V6M2 2L8 8M10 2H14M14 2V6M14 2L8 8M2 10V14M2 14H6M2 14L8 8M14 10V14M14 14H10M14 14L8 8" stroke="#718096" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                                </svg>
                            </div>
                        </div>
                    )}
                </>
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
