package com.goodee.JoinTree.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.ScheduleService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Schedule;

import lombok.extern.slf4j.Slf4j;

import com.fasterxml.jackson.databind.ObjectMapper; // Jackson 라이브러리 추가

@Slf4j
@Controller
public class ScheduleController {
	
	@Autowired
    private ScheduleService scheduleService;
	
	// 전사 일정 출력 페이지 (모두 볼수 있음)
	@GetMapping("/schedule/companySchedule")
    public String companySchedulePage() {
		
		return "/schedule/companySchedule";
    }
	
	// 전사 일정 데이터를 JSON 형태로 반환
	@GetMapping("/schedule/getCompanySchedules")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getCompanySchedules(
    		@RequestParam(name="scheduleCategory", defaultValue = "S0101") String scheduleCategory) {
		
        // MyBatis를 사용하여 데이터베이스에서 일정 데이터 가져오기
        List<Schedule> schedules = scheduleService.selectCompanySchedules(scheduleCategory);
        
        // FullCalendar에서 요구하는 데이터 형식으로 변환
        List<Map<String, Object>> eventDataList = new ArrayList<>();
        for (Schedule schedule : schedules) {
            Map<String, Object> eventData = new HashMap<>();
            // FullCalendar 필수데이터
            eventData.put("id", schedule.getScheduleNo());
            eventData.put("title", schedule.getScheduleTitle());
            eventData.put("start", schedule.getScheduleStart());
            eventData.put("end", schedule.getScheduleEnd());
            eventDataList.add(eventData);
        }
        
        // JSON 형식의 데이터를 ResponseEntity에 넣어서 반환
        return new ResponseEntity<>(eventDataList, HttpStatus.OK);
    }
		
	// 부서 일정 출력 페이지 (같은 부서끼리만 볼수있음)
	@GetMapping("/schedule/departmentSchedule")
    public String departmentSchedulePage() {
		
		return "/schedule/departmentSchedule";
    }
		
	// 부서 일정 데이터를 JSON 형태로 반환
	@GetMapping("/schedule/getDepartmentSchedules")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getDepartmentSchedules(HttpSession session,
    		@RequestParam(name="scheduleCategory", defaultValue = "S0102") String scheduleCategory) {
		
		// 세션에서 dept 정보 추출
	    String dept = (String) session.getAttribute("dept");
		
		// MyBatis를 사용하여 데이터베이스에서 일정 데이터 가져오기
        List<Schedule> schedules = scheduleService.selectDepartmentSchedules(dept, scheduleCategory);
        
        // FullCalendar에서 요구하는 데이터 형식으로 변환
        List<Map<String, Object>> eventDataList = new ArrayList<>();
        for (Schedule schedule : schedules) {
            Map<String, Object> eventData = new HashMap<>();
            // FullCalendar 필수데이터
            eventData.put("id", schedule.getScheduleNo());
            eventData.put("title", schedule.getScheduleTitle());
            eventData.put("start", schedule.getScheduleStart());
            eventData.put("end", schedule.getScheduleEnd());
            eventDataList.add(eventData);
        }
        
        // JSON 형식의 데이터를 ResponseEntity에 넣어서 반환
        return new ResponseEntity<>(eventDataList, HttpStatus.OK);
    }
		
	// 개인 일정 출력 페이지 (자기의 일정만 볼수있음)
	@GetMapping("/schedule/personalSchedule")
    public String personalSchedulePage() {
		
		return "/schedule/personalSchedule";
    }
	
	// 개인 일정 데이터를 JSON 형태로 반환
	@GetMapping("/schedule/getPersonalSchedules")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getPersonalSchedules(HttpSession session,
    		@RequestParam(name="scheduleCategory", defaultValue = "S0103") String scheduleCategory) {
		
		// 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		
		// MyBatis를 사용하여 데이터베이스에서 일정 데이터 가져오기
        List<Schedule> schedules = scheduleService.selectPersonalSchedules(empNo, scheduleCategory);
        
        // FullCalendar에서 요구하는 데이터 형식으로 변환
        List<Map<String, Object>> eventDataList = new ArrayList<>();
        for (Schedule schedule : schedules) {
            Map<String, Object> eventData = new HashMap<>();
            // FullCalendar 필수데이터
            eventData.put("id", schedule.getScheduleNo());
            eventData.put("title", schedule.getScheduleTitle());
            eventData.put("start", schedule.getScheduleStart());
            eventData.put("end", schedule.getScheduleEnd());
            eventDataList.add(eventData);
        }
        
        // JSON 형식의 데이터를 ResponseEntity에 넣어서 반환
        return new ResponseEntity<>(eventDataList, HttpStatus.OK);
    }
	
	// 홈 - 오늘의 일정 출력
	@GetMapping("/schedule/todayScheduleList")
    @ResponseBody
	public List<Schedule> todaySchedule(HttpSession session){
		
		// 세션에서 dept 정보 추출
	    String dept = (String) session.getAttribute("dept");
	    
	    // 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		
		List<Schedule> todayScheduleList =  scheduleService.selectTodaySchedules(dept, empNo);
		
		return todayScheduleList;
	}
	
	// 전사 일정 추가 (경영지원부만 추가가능)
	@PostMapping("/schedule/addCompanySchedule")
	public ResponseEntity<Map<String, Object>> addCompanySchedule(@RequestBody Schedule schedule, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    
	    // 세션에서 dept 정보 추출
	    String dept = (String) session.getAttribute("dept");
	    log.debug(dept + "<-- 로그인 사용자 dept");
	    // 경영지원부(D0202)만 전사일정 추가가능
	    if (!"D0202".equals(dept)) {
	        response.put("success", false);
	        response.put("message", "You do not have permission to add company schedules.");
	        return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
	    }
	    
	    // 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		// empNo를 schedule에 설정
	    schedule.setEmpNo(empNo);
	    
	    // 세션에서 empName 정보 추출
	    String empName = (String) session.getAttribute("empName");
	    schedule.setEmpName(empName);
	    
	    // 일정 카테고리(전사)
		String scheduleCategory = "S0101";
	    schedule.setScheduleCategory(scheduleCategory);
	    
	    // 스케줄 추가 로직
	    try {
	        scheduleService.addSchedule(schedule);
	        response.put("success", true);
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "Failed to add personal schedule.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 부서 일정 추가
	@PostMapping("/schedule/addDepartmentSchedule")
	public ResponseEntity<Map<String, Object>> addDepartmentSchedule(@RequestBody Schedule schedule, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    
	    // 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		// empNo를 schedule에 설정
	    schedule.setEmpNo(empNo);
	    
	    // 세션에서 empName 정보 추출
	    String empName = (String) session.getAttribute("empName");
	    schedule.setEmpName(empName);
	    
		// 일정 카테고리(부서)
		String scheduleCategory = "S0102";
	    schedule.setScheduleCategory(scheduleCategory);
	    
	    log.debug(scheduleCategory);
	    
	    // 스케줄 추가 로직
	    try {
	        scheduleService.addSchedule(schedule);
	        response.put("success", true);
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "Failed to add personal schedule.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 개인 일정 추가
	@PostMapping("/schedule/addPersonalSchedule")
	public ResponseEntity<Map<String, Object>> addPersonalSchedule(@RequestBody Schedule schedule, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    
	    // 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		// empNo를 schedule에 설정
	    schedule.setEmpNo(empNo);
	    
	    // 세션에서 empName 정보 추출
	    String empName = (String) session.getAttribute("empName");
	    schedule.setEmpName(empName);
	    
		// 일정 카테고리(개인)
		String scheduleCategory = "S0103";
	    schedule.setScheduleCategory(scheduleCategory);
	    
	    log.debug(scheduleCategory);
	    
	    // 스케줄 추가 로직
	    try {
	        scheduleService.addSchedule(schedule);
	        response.put("success", true);
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "Failed to add personal schedule.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 일정 상세보기
	@GetMapping("/schedule/selectScheduleOne")
    @ResponseBody
    public ResponseEntity<Schedule> selectScheduleOne(@RequestParam(name="scheduleNo") int scheduleNo) {
		
		Schedule scheduleOne = scheduleService.selectScheduleOne(scheduleNo);
        return new ResponseEntity<>(scheduleOne, HttpStatus.OK);
	}
	
	// 일정 삭제
	@PostMapping("/schedule/removeSchedule")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> removeSchedule(
	        @RequestBody Schedule schedule) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        int deletedRows = scheduleService.removeSchedule(schedule);
	        if (deletedRows > 0) {
	            response.put("success", true);
	            return new ResponseEntity<>(response, HttpStatus.OK);
	        } else {
	            response.put("success", false);
	            response.put("message", "Failed to delete the schedule.");
	            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "An error occurred while deleting the schedule.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
	// 일정 수정
	@PostMapping("/schedule/modifySchedule")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> modifySchedule(
	        @RequestBody Schedule schedule) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 스케줄 업데이트 로직
	        scheduleService.modifySchedule(schedule);
	        response.put("success", true);
	        return new ResponseEntity<>(response, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "Failed to update the schedule.");
	        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}


}
