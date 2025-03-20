package com.example.controller;

import com.example.model.User;
import com.example.model.UserPreference;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller // Changed from @RestController to @Controller
public class UserController {
    
    private final UserService userService;
    
    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }
    
    // REST endpoints with @ResponseBody annotations
    @PostMapping("/api/users/register")
    @ResponseBody
    public String register(@RequestBody User user) {
        userService.register(user);
        return "User registered successfully!";
    }
    
    @PostMapping("/api/users/login")
    @ResponseBody
    public User login(@RequestParam String email, @RequestParam String password) {
        return userService.login(email, password);
    }
    
    @PutMapping("/api/users/{userId}/preference")
    @ResponseBody
    public String updatePreference(@PathVariable Long userId, @RequestBody UserPreference preference) {
        userService.updatePreference(userId, preference);
        return "User preference updated successfully!";
    }
    
    // Web form handling for update profile
    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam("email") String newEmail,
            @RequestParam(value = "password", required = false) String newPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please log in first.");
            return "redirect:/login";
        }
        
        try {
            // Update user object
            currentUser.setEmail(newEmail);
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                currentUser.setPassword(newPassword);
            }
            
            // Update in database
            userService.updateUser(currentUser);
            
            // Update session
            session.setAttribute("user", currentUser);
            
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating profile: " + e.getMessage());
        }
        
        return "redirect:/profile";
    }
    
    // Web form handling for account deletion
    @PostMapping("/profile/delete")
    public String deleteAccount(
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please log in first.");
            return "redirect:/login";
        }
        
        try {
            // Delete user from database
            userService.deleteUser(currentUser.getId());
            
            // Invalidate session
            session.invalidate();
            
            redirectAttributes.addFlashAttribute("successMessage", "Your account has been deleted successfully.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting account: " + e.getMessage());
            return "redirect:/profile";
        }
    }
}