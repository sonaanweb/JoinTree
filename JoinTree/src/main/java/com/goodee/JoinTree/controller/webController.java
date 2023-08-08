package com.goodee.JoinTree.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class webController {

	@GetMapping("/index")
	public String main() {
		
		return "test";
	}
}
