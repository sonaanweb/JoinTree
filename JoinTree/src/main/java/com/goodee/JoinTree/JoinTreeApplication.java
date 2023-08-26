package com.goodee.JoinTree;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan // 서블릿, 필터, 리스너를 스캔하여 등록
public class JoinTreeApplication { 	
	public static void main(String[] args) {
		SpringApplication.run(JoinTreeApplication.class, args);
	
	}
}