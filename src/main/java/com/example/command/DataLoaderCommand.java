package com.example.command;

import com.example.service.DataLoaderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class DataLoaderCommand implements CommandLineRunner {

    private final DataLoaderService dataLoaderService;

    @Autowired
    public DataLoaderCommand(DataLoaderService dataLoaderService) {
        this.dataLoaderService = dataLoaderService;
    }

    @Override
    public void run(String... args) throws Exception {
        if (args.length > 0 && "load-data".equals(args[0])) {
            System.out.println("start loading data...");
            try {
                dataLoaderService.loadAllData();
                System.out.println("data loaded!");
            } catch (IOException e) {
                System.err.println("data loading failed: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
} 