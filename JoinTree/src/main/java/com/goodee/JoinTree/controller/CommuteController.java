package com.goodee.JoinTree.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.CommuteService;
import com.goodee.JoinTree.vo.AccountList;

@Controller
public class CommuteController {

	@Autowired
	private CommuteService commuteService;
	
	// commuteList.jsp
	@GetMapping("/commute/commuteList")
	public String commuteList(Model model,
							  HttpSession session, 
							  @RequestParam(required = false, name = "targetYear") Integer targetYear,
							  @RequestParam(required = false, name = "targetMonth") Integer targetMonth) {
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
		}
		
		// commuteTimeList
		Map<String, Object> resultMap = commuteService.getCommuteTimeList(empNo, targetYear, targetMonth);
		
		model.addAttribute("targetYear", resultMap.get("targetYear")); // 현재 년
		model.addAttribute("targetMonth", resultMap.get("targetMonth")); // 현재 월
		model.addAttribute("daysInMonth", resultMap.get("daysInMonth")); // 해당 월의 마지막 일
		model.addAttribute("daysOfWeek", resultMap.get("daysOfWeek")); // 요일 배열
		model.addAttribute("firstDayOfWeek", resultMap.get("firstDayOfWeek")); // 해당 월의 1일의 요일
		model.addAttribute("commuteTimeList", resultMap.get("commuteTimeList")); // 해당 월의 출퇴근 리스트
		
		return "/commute/commuteList";
	}
	
	// commuteChart.jsp
	@GetMapping("/commute/commuteChart")
	public String commuteChart() {
		
		return "/commute/commuteChart";
	}
}
