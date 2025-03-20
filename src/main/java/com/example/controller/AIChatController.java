package com.example.controller;

import com.example.model.AIChatMessage;
import com.example.service.AIChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
} 