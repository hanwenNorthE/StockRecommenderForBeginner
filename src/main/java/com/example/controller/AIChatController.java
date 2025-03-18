package com.example.controller;

import com.example.model.AIChatMessage;
import com.example.service.AIChatService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chat")
public class AIChatController {
    
    private AIChatService aiChatService = new AIChatService();

    @PostMapping
    public AIChatMessage chat(@RequestParam String sessionId, @RequestParam String message) {
        return aiChatService.sendMessage(sessionId, message);
    }
} 