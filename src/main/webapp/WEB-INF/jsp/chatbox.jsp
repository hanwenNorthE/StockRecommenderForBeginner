<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/babel">
    // Export the KnowledgeBaseButton component
    window.KnowledgeBaseButton = () => {
        return (
            <div className="fixed bottom-6 left-6 z-50">
                <a 
                    href="http://localhost:5000" 
                    target="_blank"
                    rel="noopener noreferrer" 
                    className="flex items-center justify-center bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-4 rounded-full shadow-lg transition-all duration-300 hover:scale-105"
                >
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                    </svg>
                    Knowledge Base
                </a>
            </div>
        );
    };

    // Export the ChatBox component so it can be used in other files
    window.ChatBox = () => {
        const [isOpen, setIsOpen] = React.useState(false);
        const [messages, setMessages] = React.useState([]);
        const [input, setInput] = React.useState('');
        const [isLoading, setIsLoading] = React.useState(false);
        const [sessionId, setSessionId] = React.useState('session_' + Math.random().toString(36).substring(2, 15));
        const [chatSize, setChatSize] = React.useState({ width: 500, height: 400 });
        const [selectedApi, setSelectedApi] = React.useState('lmstudio');
        const chatRef = React.useRef(null);
        
        // handle markdown format function
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
                            i++; // skip separator line
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
                
                // call backend AI chat API based on selected API
                const apiUrl = selectedApi === 'openrouter' 
                    ? contextPath + "/api/chat/openrouter?sessionId=" + encodeURIComponent(sessionId) + "&message=" + encodeURIComponent(input.trim())
                    : contextPath + "/api/chat?sessionId=" + encodeURIComponent(sessionId) + "&message=" + encodeURIComponent(input.trim());
                
                // send request
                fetch(apiUrl, {
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
                    // add AI reply to chat history
                    setMessages(prev => [...prev, { 
                        text: data.message, 
                        sender: 'system',
                        api: selectedApi // Store which API was used
                    }]);
                })
                .catch(error => {
                    console.error('error when calling AI chat API:', error);
                    setMessages(prev => [...prev, { 
                        text: "sorry, there is an error when calling AI chat API. please try again later.", 
                        sender: 'system',
                        api: selectedApi
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
                {/* chat button */}
                <button 
                    onClick={() => setIsOpen(!isOpen)}
                    className="fixed bottom-4 right-4 bg-indigo-600 text-white p-3 rounded-full shadow-lg hover:bg-indigo-700 z-50"
                >
                    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"></path>
                    </svg>
                </button>
                
                {/* chat window */}
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
                                <select 
                                    value={selectedApi}
                                    onChange={(e) => setSelectedApi(e.target.value)}
                                    className="mr-2 text-xs bg-indigo-700 text-white px-1 py-1 rounded border border-indigo-500"
                                >
                                    <option value="lmstudio">LM Studio</option>
                                    <option value="openrouter">OpenRouter</option>
                                </select>
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
                                        <p>Hi! I am AI Investment assistant, You can ask me any questions, like：</p>
                                        <p className="mt-2 text-indigo-600">- How is AAPL historical performance？</p>
                                        <p className="text-indigo-600">- Is NVDA a good investment？</p>
                                        <p className="text-indigo-600">- Analyze AMZN stock</p>
                                        <p className="mt-3 text-gray-600 text-sm">Select your preferred AI model from the dropdown menu in the top-right corner.</p>
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
                                                        <div className="flex flex-col">
                                                            {msg.api && (
                                                                <span className="text-xs text-gray-500 mb-1 ml-1">
                                                                    {msg.api === 'lmstudio' ? 'LM Studio' : 'OpenRouter'}
                                                                </span>
                                                            )}
                                                            <div className={msgStyle} 
                                                                dangerouslySetInnerHTML={{__html: formatMarkdown(msg.text)}}>
                                                            </div>
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
</script>
