package com.goodee.JoinTree.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class CommuteController {
	
	// commuteList.jsp
	@GetMapping("/commute/commuteList")
	public String commuteList() {
		
		return "/commute/commuteList";
	}
	
	// commuteChart.jsp
	@GetMapping("/commute/commuteChart")
	public String commuteChart() {
		
		return "/commute/commuteChart";
	}
}
