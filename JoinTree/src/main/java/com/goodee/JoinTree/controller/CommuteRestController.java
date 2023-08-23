package com.goodee.JoinTree.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.CommuteService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Commute;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class CommuteRestController {

	@Autowired
	private CommuteService commuteService;
	
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
	
	// 버튼상태 값 세션에 저장
	@PostMapping("/setCommuteBtnState")
	public void setCommuteBtnState(HttpSession session, @RequestParam String state) {
		session.setAttribute("commuteButtonState", state);
	}
	
	// 버튼상태 값 가져오기
	@GetMapping("/getCommuteBtnState")
	public String getCommuteBtnState(HttpSession session) {
		
		String getCommuteButtonState = (String) session.getAttribute("commuteButtonState");
		return getCommuteButtonState;
	}
}
