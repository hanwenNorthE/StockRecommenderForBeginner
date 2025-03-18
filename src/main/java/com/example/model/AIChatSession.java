package com.example.model;

import java.util.ArrayList;
import java.util.List;

public class AIChatSession {
    private String sessionId;
    private List<AIChatMessage> messages = new ArrayList<>();

    public AIChatSession() {
    }

    public AIChatSession(String sessionId) {
        this.sessionId = sessionId;
        this.messages = new ArrayList<>();
    }

    // getters and setters
    public String getSessionId() {
        return sessionId;
    }
    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    public List<AIChatMessage> getMessages() {
        return messages;
    }
    public void setMessages(List<AIChatMessage> messages) {
        this.messages = messages;
    }

    public void addMessage(AIChatMessage message) {
        this.messages.add(message);
    }
} 