package com.example.controller;

import com.example.dao.HoldingDao;
import com.example.dao.PortfolioDao;
import com.example.model.Holding;
import com.example.model.Portfolio;
import com.example.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class ProfileController {

    private final HoldingDao holdingDao;
    private final PortfolioDao portfolioDao;

    @Autowired
    public ProfileController(HoldingDao holdingDao, PortfolioDao portfolioDao) {
        this.holdingDao = holdingDao;
        this.portfolioDao = portfolioDao;
    }

    @GetMapping("/profilePage")
    public String profilePage(HttpSession session, Model model) {
        // 获取当前用户
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // 根据用户ID获取 Portfolio
        Optional<Portfolio> optPortfolio = portfolioDao.findByUserId(user.getId());
        double accountBalance = 0.0;
        List<Holding> holdings = new ArrayList<>();

        if (optPortfolio.isPresent()) {
            Portfolio portfolio = optPortfolio.get();
            accountBalance = portfolio.getCashBalance();
            holdings = holdingDao.findByPortfolioId(portfolio.getId());
        }

        // 不再计算 purchasePrice * quantity
        // 如果你想显示总持仓价值，需要从 stocks 表里查当前价格，或其他方式

        model.addAttribute("user", user);
        model.addAttribute("accountBalance", accountBalance);
        model.addAttribute("userHoldings", holdings);
        model.addAttribute("totalHoldingsValue", 0); // 或者你可以自己做一个逻辑
        model.addAttribute("recommendedStocks", new ArrayList<>()); // 示例

        return "profilePage"; // JSP
    }
}
