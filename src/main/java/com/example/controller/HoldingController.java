package com.example.controller;

import com.example.dao.HoldingDao;
import com.example.dao.PortfolioDao;
import com.example.model.Holding;
import com.example.model.Portfolio;
import com.example.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/holdings")
public class HoldingController {

    private final HoldingDao holdingDao;
    private final PortfolioDao portfolioDao;

    @Autowired
    public HoldingController(HoldingDao holdingDao, PortfolioDao portfolioDao) {
        this.holdingDao = holdingDao;
        this.portfolioDao = portfolioDao;
    }

    /**
     * 显示添加持仓的表单页面
     */
    @GetMapping("/add")
    public String showAddHoldingForm() {
        return "add_holding"; // 渲染 add_holding.jsp
    }

    /**
     * 处理“添加/更新持仓”表单提交
     * 不再接收 purchasePrice
     */
    @PostMapping("/add")
    public String addHolding(
            @RequestParam("stockCode") String stockCode,
            @RequestParam("quantity") int quantity,
            HttpSession session
    ) {
        // 1. 获取当前用户
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // 2. 查找该用户的 Portfolio
        Optional<Portfolio> optPortfolio = portfolioDao.findByUserId(user.getId());
        if (optPortfolio.isEmpty()) {
            // 如果没有Portfolio，按需求创建或提示错误
            return "redirect:/profilePage";
        }
        Portfolio portfolio = optPortfolio.get();
        Long portfolioId = portfolio.getId();

        // 3. 检查是否已有相同股票的持仓
        Optional<Holding> existingOpt = holdingDao.findByPortfolioIdAndStockCode(portfolioId, stockCode);
        if (existingOpt.isPresent()) {
            // 若存在，更新数量（累加）
            Holding existing = existingOpt.get();
            holdingDao.updateQuantity(existing.getId(), quantity);
        } else {
            // 不存在则插入新持仓
            Holding newHolding = new Holding();
            newHolding.setPortfolioId(portfolioId);
            newHolding.setStockCode(stockCode);
            newHolding.setQuantity(quantity);
            holdingDao.save(newHolding);
        }

        // 4. 重定向到用户资料页，让 ProfileController 重新加载持仓数据
        return "redirect:/profilePage";
    }

    /**
     * 可选：删除持仓
     */
    @PostMapping("/delete/{id}")
    public String deleteHolding(@PathVariable("id") Long holdingId) {
        holdingDao.deleteById(holdingId);
        return "redirect:/profilePage";
    }
}
