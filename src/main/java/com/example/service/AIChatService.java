package com.example.service;

import com.example.model.AIChatMessage;
import java.util.Date;

public class AIChatService {
    
    // 处理 AI 聊天消息，返回 AI 回复
    public AIChatMessage sendMessage(String sessionId, String message) {
        System.out.println("Received message in session " + sessionId + ": " + message);
        // 实际实现可集成第三方大语言模型API，此处返回示例回复
        return new AIChatMessage("assistant", "这是AI回复示例", new Date());
    }
} 