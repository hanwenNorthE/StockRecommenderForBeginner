package com.example.controller;

import com.example.service.DataCheckService;
import com.example.service.DataLoaderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@Controller
public class DataCheckController {

    private final DataCheckService dataCheckService;
    private final DataLoaderService dataLoaderService;

    @Autowired
    public DataCheckController(DataCheckService dataCheckService, DataLoaderService dataLoaderService) {
        this.dataCheckService = dataCheckService;
        this.dataLoaderService = dataLoaderService;
    }

    /**
     * 显示数据库检查页面
     */
    @GetMapping("/dataCheck")
    public String dataCheckPage(Model model) {
        Map<String, Long> counts = dataCheckService.getAllTableCounts();
        
        model.addAttribute("stockDetailsCount", counts.get("stock_details"));
        model.addAttribute("priceDataCount", counts.get("price_data"));
        model.addAttribute("stocksCount", counts.get("stocks"));
        model.addAttribute("usersCount", counts.get("users"));
        model.addAttribute("portfoliosCount", counts.get("portfolios"));
        model.addAttribute("preferencesCount", counts.get("user_preferences"));
        model.addAttribute("industriesCount", counts.get("user_industries"));
        model.addAttribute("favoritesCount", counts.get("user_favorites"));
        
        return "dataCheckPage";
    }

    /**
     * 仅刷新数据状态
     */
    @GetMapping("/checkDataStatus")
    public String checkDataStatus(Model model) {
        return dataCheckPage(model);
    }

    /**
     * 查看表数据
     */
    @GetMapping("/checkData")
    public String checkData(
            @RequestParam String tableName,
            @RequestParam(defaultValue = "10") int limit,
            Model model) {
        
        // 首先加载所有表的计数
        Map<String, Long> counts = dataCheckService.getAllTableCounts();
        
        model.addAttribute("stockDetailsCount", counts.get("stock_details"));
        model.addAttribute("priceDataCount", counts.get("price_data"));
        model.addAttribute("stocksCount", counts.get("stocks"));
        model.addAttribute("usersCount", counts.get("users"));
        model.addAttribute("portfoliosCount", counts.get("portfolios"));
        model.addAttribute("preferencesCount", counts.get("user_preferences"));
        model.addAttribute("industriesCount", counts.get("user_industries"));
        model.addAttribute("favoritesCount", counts.get("user_favorites"));
        
        // 获取表数据
        List<String> columns = dataCheckService.getTableColumns(tableName);
        List<List<Object>> data = dataCheckService.getTableData(tableName, limit);
        long totalRecords = counts.getOrDefault(tableName, 0L);
        
        model.addAttribute("selectedTable", tableName);
        model.addAttribute("tableColumns", columns);
        model.addAttribute("tableData", data);
        model.addAttribute("totalRecords", totalRecords);
        
        return "dataCheckPage";
    }

    /**
     * 导出表数据为CSV
     */
    @GetMapping("/exportTableData")
    public void exportTableData(
            @RequestParam String tableName,
            HttpServletResponse response) throws IOException {
        
        // 设置响应头，指定内容类型为CSV
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + tableName + ".csv\"");
        
        // 获取表的列和数据
        List<String> columns = dataCheckService.getTableColumns(tableName);
        List<List<Object>> data = dataCheckService.getTableData(tableName, Integer.MAX_VALUE);
        
        // 写入CSV数据
        try (PrintWriter writer = response.getWriter()) {
            // 写入列标题
            writer.println(String.join(",", columns));
            
            // 写入每行数据
            for (List<Object> row : data) {
                writer.println(
                    row.stream()
                       .map(cell -> cell == null ? "" : "\"" + cell.toString().replace("\"", "\"\"") + "\"")
                       .reduce((a, b) -> a + "," + b)
                       .orElse("")
                );
            }
        }
    }

    /**
     * 加载所有数据
     */
    @GetMapping("/loadData")
    public String loadAllData(Model model) throws IOException {
        // 执行数据加载
        dataLoaderService.loadAllData();
        
        // 重定向到数据检查页面
        return "redirect:/dataCheck";
    }
} 