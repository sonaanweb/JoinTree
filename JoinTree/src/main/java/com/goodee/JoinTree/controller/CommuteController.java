package com.goodee.JoinTree.controller;

import java.time.LocalDate;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.CommuteService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
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
		log.debug(resultMap+"<-- CommuteController resultMap");
		
		// 사원별 입사일 조회
		EmpInfo empInfo = commuteService.getEmpHireDate(empNo);
		String empHireDateStr = (String)empInfo.getEmpHireDate();
		log.debug(empHireDateStr+"<-- CommuteController empHireDateStr");
		
		// empHireDate를 LocalDate로 변환
		LocalDate empHireDate = LocalDate.parse(empHireDateStr);
		log.debug(empHireDate+"<-- CommuteController empHireDate");
		
		// 입사일 연월 추출
		int hireYear = empHireDate.getYear();
		int hireMonth = empHireDate.getMonthValue();
		log.debug(hireYear+"<-- CommuteController hireYear");
		log.debug(hireMonth+"<-- CommuteController hireMonth");
		
		// 현재 날짜
        LocalDate currentDate = LocalDate.now();
 
        // 현재 날자 연월 추출
		int currentYear = currentDate.getYear();
		int currentMonth = currentDate.getMonthValue();
        
		model.addAttribute("targetYear", resultMap.get("targetYear")); // 선택한 년
		model.addAttribute("targetMonth", resultMap.get("targetMonth")); // 선택한 월
		model.addAttribute("daysInMonth", resultMap.get("daysInMonth")); // 해당 월의 마지막 일
		model.addAttribute("daysOfWeek", resultMap.get("daysOfWeek")); // 요일 배열
		model.addAttribute("firstDayOfWeek", resultMap.get("firstDayOfWeek")); // 해당 월의 1일의 요일
		model.addAttribute("commuteTimeList", resultMap.get("commuteTimeList")); // 해당 월의 출퇴근 리스트
		model.addAttribute("hireYear", hireYear); // 입사 연도
		model.addAttribute("hireMonth", hireMonth); // 입사 월
		model.addAttribute("currentYear", currentYear); // 현재 연도
		model.addAttribute("currentMonth", currentMonth); // 현재 월
		
		return "/commute/commuteList";
	}
	
	// commuteChart.jsp
	@GetMapping("/commute/commuteChart")
	public String commuteChart() {
		
		return "/commute/commuteChart";
	}
}
