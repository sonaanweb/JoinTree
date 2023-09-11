package com.goodee.JoinTree.restapi;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.CommuteManageService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class CommuteManageRestController {
	
	@Autowired
	private CommuteManageService commuteManageService;
	
	// 연차 목록 조회
	@GetMapping("/commuteManage/searchAnnualLeaveList")
	public Map<String, Object> searchAnnualLeaveList(@RequestParam Map<String, Object> searchAnnualLeaveList){
		
		log.debug(searchAnnualLeaveList+"<-- CommuteManageRestControllre searchAnnualLeaveList");
		
		// 리스트 조회
		Map<String, Object> searchAnnualLeaveListResult = commuteManageService.searchAnnualLeaveList(searchAnnualLeaveList);
		log.debug(searchAnnualLeaveListResult+"<-- CommuteManageRestControllre searchAnnualLeaveListResult");
		
		return searchAnnualLeaveListResult;
	}
	
	// 연가 사용 목록 조회
	@GetMapping("/commuteManage/searchLeaveRecodeList")
	public Map<String, Object> searchLeaveRecodeList(@RequestParam Map<String, Object> searchLeaveRecodeList){
		
		log.debug(searchLeaveRecodeList+"<-- CommuteManageRestControllre searchLeaveRecodeList");
		
		// 리스트 조회
		Map<String, Object> searchLeaveRecodeListResult = commuteManageService.searchLeaveRecodeList(searchLeaveRecodeList);
		log.debug(searchLeaveRecodeListResult+"<-- CommuteManageRestControllre searchLeaveRecodeListResult");
		
		return searchLeaveRecodeListResult;
	}
	
	// 전직원 출퇴근 목록 조회
	@GetMapping("/commuteManage/searchCommuteFullList")
	public Map<String, Object> searchCommuteFullList(@RequestParam Map<String, Object> searchCommuteFullList){
		
		log.debug(searchCommuteFullList+"<-- CommuteManageRestControllre searchCommuteFullList");
		
		// 리스트 조회
		Map<String, Object> searchCommuteFullListResult = commuteManageService.searchCommuteFullList(searchCommuteFullList);
		log.debug(searchCommuteFullListResult+"<-- CommuteManageRestControllre searchCommuteFullListResult");
		
		return searchCommuteFullListResult;
	}
	
	// 사원 연차 정보 조회
	@GetMapping("/commuteManage/getAnnualLeaveInfo")
	public Map<String, Object> getAnnualLeaveInfo (@RequestParam int empNo) {
		
		Map<String, Object> annualInfo = commuteManageService.getAnnualLeaveInfo(empNo);
		
		return annualInfo;
	}
	
}
