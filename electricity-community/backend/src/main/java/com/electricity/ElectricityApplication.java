package com.electricity;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.electricity.mapper")
public class ElectricityApplication {
    public static void main(String[] args) {
        SpringApplication.run(ElectricityApplication.class, args);
    }
}
