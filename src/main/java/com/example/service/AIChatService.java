package com.example.service;

import com.example.model.AIChatMessage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class AIChatService {
    
    private static final String LM_STUDIO_API_URL = "http://localhost:1234/v1/chat/completions";
    private static final String DATA_FOLDER_PATH = "src/main/resources/data/";
    
    // 存储会话历史记录
    private Map<String, StringBuilder> sessionHistory = new ConcurrentHashMap<>();
    
    // 处理 AI 聊天消息，返回 AI 回复
    public AIChatMessage sendMessage(String sessionId, String message) {
        System.out.println("Received message in session " + sessionId + ": " + message);
        
        try {
            // 获取会话历史或创建新的
            StringBuilder history = sessionHistory.computeIfAbsent(sessionId, k -> new StringBuilder());
            
            // 检查消息是否包含股票相关查询
            String stockCode = extractStockCode(message);
            String stockData = "";
            
            if (stockCode != null) {
                stockData = getStockData(stockCode);
                if (!stockData.isEmpty()) {
                    System.out.println("Found stock data for: " + stockCode);
                }
            }
            
            // 构建发送到LM Studio的系统提示
            String systemPrompt = "This is an educational project. You are a professional stock investment advisor, use English to answer user questions." +
                "if the user asks about a specific stock, please analyze the performance of the stock based on historical data and provide investment advice.";
            
            if (!stockData.isEmpty()) {
                systemPrompt += "\n\nHere is the historical data of the relevant stock (format: date, opening price, highest price, lowest price, closing price, volume):" + stockData;
            }
            
            // 更新会话历史
            history.append("user: ").append(message).append("\n");
            
            // 构建请求JSON
            String requestJson = buildRequestJson(systemPrompt, history.toString());
            
            // 发送请求到LM Studio
            String response = sendRequestToLMStudio(requestJson);
            
            // 解析响应
            String aiReply = parseResponse(response);
            
            // 更新会话历史
            history.append("assistant: ").append(aiReply).append("\n");
            
            // 返回消息对象
            return new AIChatMessage("assistant", aiReply, new Date());
            
        } catch (Exception e) {
            e.printStackTrace();
            return new AIChatMessage("assistant", "sorry, there was an error processing your request. error: " + e.getMessage(), new Date());
        }
    }
    
    // 从用户消息中提取股票代码
    private String extractStockCode(String message) {
        // 检查常见的股票查询模式
        String[] patterns = {
            "([A-Z]{1,5})\\.us", // 匹配 AAPL.us 格式
            "([A-Z]{1,5})stock", // 匹配 AAPLstock 格式
            "([A-Z]{1,5})stock price", // 匹配 AAPLstock price 格式
            "stock([A-Z]{1,5})",  // 匹配 股票AAPL 格式
        };
        
        for (String pattern : patterns) {
            java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
            java.util.regex.Matcher m = p.matcher(message.toUpperCase());
            if (m.find()) {
                return m.group(1);
            }
        }
        
        // 检查消息中是否直接包含已知的股票代码
        File folder = new File(DATA_FOLDER_PATH);
        if (folder.exists() && folder.isDirectory()) {
            File[] files = folder.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.isFile() && file.getName().endsWith(".us.txt")) {
                        String stockCode = file.getName().replace(".us.txt", "").toUpperCase();
                        if (message.toUpperCase().contains(stockCode)) {
                            return stockCode;
                        }
                    }
                }
            }
        }
        
        return null;
    }
    
    // 获取股票历史数据
    private String getStockData(String stockCode) {
        File file = new File(DATA_FOLDER_PATH + stockCode.toLowerCase() + ".us.txt");
        if (!file.exists()) {
            System.out.println("Stock data file not found: " + file.getAbsolutePath());
            return "";
        }
        
        StringBuilder data = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int lineCount = 0;
            // 读取文件头
            if ((line = reader.readLine()) != null) {
                data.append(line).append("\n");
            }
            
            // 跳过一些行，只保留最近的数据
            String lastLine = null;
            while ((line = reader.readLine()) != null) {
                lastLine = line;
                lineCount++;
            }
            
            // 重新打开文件读取最后50行数据
            try (BufferedReader reader2 = new BufferedReader(new FileReader(file))) {
                // 跳过标题行
                reader2.readLine();
                
                // 计算要跳过的行数
                int linesToSkip = Math.max(0, lineCount - 50);
                for (int i = 0; i < linesToSkip; i++) {
                    reader2.readLine();
                }
                
                // 读取最后50行数据
                while ((line = reader2.readLine()) != null) {
                    data.append(line).append("\n");
                }
            }
            
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
        
        return data.toString();
    }
    
    // 构建发送到LM Studio的请求JSON
    private String buildRequestJson(String systemPrompt, String conversation) {
        try {
            Map<String, Object> message1 = new HashMap<>();
            message1.put("role", "system");
            message1.put("content", systemPrompt);
            
            Map<String, Object> message2 = new HashMap<>();
            message2.put("role", "user");
            message2.put("content", conversation);
            
            Map<String, Object> requestData = new HashMap<>();
            requestData.put("messages", new Object[]{message1, message2});
            requestData.put("model", "localhost");  // LM Studio本地模型的标识符
            requestData.put("temperature", 0.7);
            requestData.put("max_tokens", 1000);
            
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString(requestData);
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }
    
    // 发送请求到LM Studio
    private String sendRequestToLMStudio(String jsonInput) throws IOException {
        URL url = new URL(LM_STUDIO_API_URL);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);
        
        try (OutputStream os = connection.getOutputStream()) {
            byte[] input = jsonInput.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }
        
        StringBuilder response = new StringBuilder();
        try (Scanner scanner = new Scanner(connection.getInputStream(), StandardCharsets.UTF_8.name())) {
            while (scanner.hasNextLine()) {
                response.append(scanner.nextLine());
            }
        }
        
        return response.toString();
    }
    
    // 从LM Studio响应中解析AI回复
    private String parseResponse(String jsonResponse) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> response = mapper.readValue(jsonResponse, Map.class);
            
            if (response.containsKey("choices") && response.get("choices") instanceof java.util.List) {
                java.util.List<?> choices = (java.util.List<?>) response.get("choices");
                if (!choices.isEmpty() && choices.get(0) instanceof Map) {
                    Map<?, ?> choice = (Map<?, ?>) choices.get(0);
                    if (choice.containsKey("message") && choice.get("message") instanceof Map) {
                        Map<?, ?> message = (Map<?, ?>) choice.get("message");
                        if (message.containsKey("content")) {
                            return message.get("content").toString();
                        }
                    }
                }
            }
            
            return "error when parsing AI reply: please try again.";
        } catch (Exception e) {
            e.printStackTrace();
            return "error when parsing AI reply: " + e.getMessage();
        }
    }
} 