<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Home - Stock Recommendation System</title>
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
        
        // chat box component
        const ChatBox = () => {
            const [isOpen, setIsOpen] = React.useState(false);
            const [messages, setMessages] = React.useState([]);
            const [input, setInput] = React.useState('');
            const [isLoading, setIsLoading] = React.useState(false);
            const [sessionId, setSessionId] = React.useState('session_' + Math.random().toString(36).substring(2, 15));
            const [chatSize, setChatSize] = React.useState({ width: 500, height: 400 });
            const chatRef = React.useRef(null);
            
            // handle markdown format
            const formatMarkdown = (text) => {
                if (!text) return '';
                
                // handle code block ```code```
                text = text.replace(/```([\s\S]*?)```/g, '<pre class="bg-gray-800 text-gray-200 p-2 rounded my-2 overflow-x-auto"><code>$1</code></pre>');
                
                // handle inline code `code`
                text = text.replace(/`([^`]+)`/g, '<code class="bg-gray-200 text-gray-800 px-1 rounded">$1</code>');
                
                // handle title # Heading
                text = text.replace(/^# (.*$)/gm, '<h1 class="text-xl font-bold my-2">$1</h1>');
                text = text.replace(/^## (.*$)/gm, '<h2 class="text-lg font-bold my-2">$1</h2>');
                text = text.replace(/^### (.*$)/gm, '<h3 class="text-md font-bold my-2">$1</h3>');
                
                // handle bold **text**
                text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
                
                // handle italic *text*
                text = text.replace(/\*([^*]+)\*/g, '<em>$1</em>');
                
                // handle unordered list - item
                text = text.replace(/^\s*-\s*(.*$)/gm, '<li class="ml-4">• $1</li>');
                
                // handle ordered list 1. item
                text = text.replace(/^\s*(\d+)\.\s*(.*$)/gm, '<li class="ml-4">$1. $2</li>');
                
                // handle separator ---
                text = text.replace(/^\s*---\s*$/gm, '<hr class="my-2 border-gray-300" />');
                
                // handle table
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
                            
                            // handle table header or content line
                            const cells = line.split('|').filter(cell => cell.trim() !== '');
                            const tag = !headerProcessed ? 'th' : 'td';
                            const cellClass = !headerProcessed ? 'font-bold border px-2 py-1 bg-gray-100' : 'border px-2 py-1';
                            
                            tableHTML += '<tr>';
                            cells.forEach(cell => {
                                tableHTML += `<${tag} class="${cellClass}">${cell.trim()}</${tag}>`;
                            });
                            tableHTML += '</tr>';
                            
                            // check if the next line is a separator line (| --- | --- |)
                            if (!headerProcessed && i + 1 < lines.length && lines[i + 1].includes('-')) {
                                headerProcessed = true;
                                i++; // skip the separator line
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
                
                // handle normal link [text](url)
                text = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" class="text-blue-600 hover:underline" target="_blank">$1</a>');
                
                // handle paragraph and line break
                // first replace double line break with a temporary marker
                text = text.replace(/\n\s*\n/g, '{{PARAGRAPH_BREAK}}');
                
                // replace single line break with <br>
                text = text.replace(/\n/g, '<br>');
                
                // restore paragraph
                text = text.replace(/{{PARAGRAPH_BREAK}}/g, '</p><p class="my-2">');
                
                // wrap in paragraph tags
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
                    // add user message to chat history
                    const userMessage = { text: input, sender: 'user' };
                    setMessages(prev => [...prev, userMessage]);
                    
                    // clear input
                    setInput('');
                    
                    // show loading status
                    setIsLoading(true);
                    
                    // call backend AI chat API
                    const url = contextPath + "/api/chat?sessionId=" + encodeURIComponent(sessionId) + "&message=" + encodeURIComponent(input.trim());
                    
                    // send request
                    fetch(url, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response error');
                        }
                        return response.json();
                    })
                    .then(data => {
                        // add AI reply to chat history
                        setMessages(prev => [...prev, { 
                            text: data.message, 
                            sender: 'system' 
                        }]);
                    })
                    .catch(error => {
                        console.error('Error calling AI chat API:', error);
                        setMessages(prev => [...prev, { 
                            text: "Sorry, there was an issue connecting to the AI assistant. Please try again later.", 
                            sender: 'system' 
                        }]);
                    })
                    .finally(() => {
                        setIsLoading(false);
                    });
                }
            };
            
            // handle Enter key event
            const handleKeyDown = (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleSend();
                }
            };
            
            return (
                <>
                    <button 
                        onClick={() => setIsOpen(!isOpen)}
                        className="fixed bottom-4 right-4 bg-indigo-600 text-white p-3 rounded-full shadow-lg hover:bg-indigo-700 z-50"
                    >
                        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path>
                        </svg>
                    </button>
                    
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
                                <h3 className="font-bold">AI Stock Assistant</h3>
                                <div className="flex items-center">
                                    <span className="text-xs text-gray-200 mr-2">Drag to resize</span>
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
                                            <p>Hello, {USER_DATA.firstName}! I am AI stock assistant, you can ask me about your holdings or other investment questions, for example:</p>
                                            <p className="mt-2 text-indigo-600">- Analyze my holdings</p>
                                            <p className="text-indigo-600">- Is NVDA a good investment choice?</p>
                                            <p className="text-indigo-600">- How to optimize my investment portfolio</p>
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
                                        placeholder="Please enter your question..."
                                        className="flex-1 px-3 py-2 border rounded-l-lg focus:outline-none focus:ring-2 focus:ring-indigo-400 resize-none"
                                        rows="2"
                                    />
                                    <button 
                                        onClick={handleSend}
                                        disabled={isLoading}
                                        className={`${isLoading ? 'bg-gray-400' : 'bg-indigo-600 hover:bg-indigo-700'} text-white px-4 py-2 rounded-r-lg`}
                                    >
                                        {isLoading ? 'Sending...' : 'Send'}
                                    </button>
                                </div>
                            </div>
                            
                            {/* handle resize */}
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
                                        
                                        // modify element style to keep the bottom right corner position
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