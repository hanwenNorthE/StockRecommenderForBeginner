package com.example.model;

public enum Industry {
    TECHNOLOGY("Technology"),
    HEALTHCARE("Healthcare"),
    FINANCE("Finance"),
    ENERGY("Energy"),
    COMMUNICATION_SERVICES("Communication Services"),
    CONSUMER_GOODS("Consumer Goods"),
    MATERIALS("Materials"),
    OTHER("Other");
    
    private final String displayName;
    
    Industry(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}
