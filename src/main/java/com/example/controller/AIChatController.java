package com.example.controller;

import com.example.model.AIChatMessage;
import com.example.service.AIChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/chat")
public class AIChatController {
    
    private final AIChatService aiChatService;
    
    @Autowired
    public AIChatController(AIChatService aiChatService) {
        this.aiChatService = aiChatService;
    }

    @PostMapping
    public AIChatMessage chat(@RequestParam String sessionId, @RequestParam String message) {
        return aiChatService.sendMessage(sessionId, message);
    }
    
    @PostMapping("/openrouter")
    public AIChatMessage chatWithOpenRouter(@RequestParam String sessionId, @RequestParam String message) {
        return aiChatService.sendMessageWithOpenRouter(sessionId, message);
    }
} 