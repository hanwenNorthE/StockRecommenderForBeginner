package com.example.model;

import java.util.List;

/**
 * user class
 * relations:
 *  - one to many: User -> Preference
 *  - one to many: User -> favorites
 */
public class User {
    private Long id;
    private String email;
    private String password;
    private Name name;
    private UserPreference preferences;
    private List<Stock> favorites;
    private Portfolio portfolio;

    public User() {
    }

    public User(Long id, String email, String password, Name name, UserPreference preferences, List<Stock> favorites) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.preferences = preferences;
        this.favorites = favorites;
    }

    // getters and setters
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public Name getName() {
        return name;
    }
    public void setName(Name name) {
        this.name = name;
    }
    public UserPreference getPreferences() {
        return preferences;
    }
    public void setPreferences(UserPreference preferences) {
        this.preferences = preferences;
    }
    public List<Stock> getFavorites() {
        return favorites;
    }
    public void setFavorites(List<Stock> favorites) {
        this.favorites = favorites;
    }
    public Portfolio getPortfolio() {
        return portfolio;
    }
    public void setPortfolio(Portfolio portfolio) {
        this.portfolio = portfolio;
    }

    public void register() {
        //
    }

    public boolean login() {
        // login method
        return true;
    }
} 