package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.CommuteService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Commute;
import com.goodee.JoinTree.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@CrossOrigin
@RestController
public class CommuteRestController {

	@Autowired
	private CommuteService commuteService;
	
	// 출퇴근 시간 등록
	@PostMapping("/saveCommuteTime")
	public int saveCommuteTime(HttpSession session,
							   @RequestParam String time, @RequestParam String type) {
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		int createId = 0; // 생성자
		int updateId = 0; // 수정자
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
			createId = loginAccount.getEmpNo();
			updateId = loginAccount.getEmpNo();
		}
		
		// Commute vo 객체에 값 저장
		Commute commute = new Commute();
		commute.setEmpNo(empNo); // 사번
		commute.setCommute(type); // 출퇴근 타입
		
		// 반환 값 저장
		int saveCommuteTime = 0;
	
		if(type.equals("C0101")) { // 출근 
			
			commute.setEmpOnTime(time); // 출근시간
			commute.setCreateId(createId); // 생성자
			commute.setUpdateId(updateId); // 수정자
			saveCommuteTime = commuteService.addCommute(commute);
			log.debug(saveCommuteTime+"<-- CommuteRestController saveCommuteTime");
			
		} else if(type.equals("C0102")) { // 퇴근
			
			commute.setEmpOffTime(time); // 퇴근시간
			saveCommuteTime = commuteService.modifyCommute(commute);
			log.debug(saveCommuteTime+"<-- CommuteRestController saveCommuteTime");
		}
		
		return saveCommuteTime;
	}
	
	// 출퇴근 시간 조회
	@GetMapping("/getCommuteTime")
	public Commute getCommuteData(HttpSession session) {
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
		}
		
		// 사원 출퇴근 정보 조회
		Commute commute = commuteService.selectCommute(empNo);
		
		return commute;
	}
	
	// 사원별 입사일 조회
	@GetMapping("/getEmpHireDate")
	public EmpInfo getEmpHireDate(HttpSession session) {
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
		}
		
		EmpInfo empHireDate = commuteService.getEmpHireDate(empNo);
		log.debug(empHireDate+"<-- CommuteRestController empHireDate");
		
		return empHireDate;
	}
	
	// 월 별 근로시간 통계 조회
	@GetMapping("/getMonthWorkTimeData")
	public List<Map<String, Object>> getMonthWorkTimeData(HttpSession session,
														  @RequestParam String year){
		log.debug(year+"<-- CommuteRestController year");
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
		}
		
		// 서비스에 보낼 값 map에 저장
		Map<String, Object> monthWorkTimeDataMap = new HashMap<>();
		monthWorkTimeDataMap.put("empNo", empNo);
		monthWorkTimeDataMap.put("year", year);
		
		// 월별 근로시간 통계 조회
		List<Map<String, Object>> monthWorkTimeDataResult = commuteService.getMonthWorkTimeData(monthWorkTimeDataMap);
		
		return monthWorkTimeDataResult;
	}
	
	// 주 별 근로시간 통계 조회
	@GetMapping("/getWeekWorkTimeData")
	public List<Map<String, Object>> getWeekWorkTimeData(HttpSession session,
														  @RequestParam String year, @RequestParam String month){
		log.debug(year+"<-- CommuteRestController year");
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
		}
		
		// 서비스에 보낼 값 map에 저장
		Map<String, Object> weekWorkTimeDataMap = new HashMap<>();
		weekWorkTimeDataMap.put("empNo", empNo);
		weekWorkTimeDataMap.put("year", year);
		weekWorkTimeDataMap.put("month", month);
		
		// 월별 근로시간 통계 조회
		List<Map<String, Object>> weekWorkTimeDataMapResult = commuteService.getWeekWorkTimeData(weekWorkTimeDataMap);
		
		return weekWorkTimeDataMapResult;
	}
	
}
