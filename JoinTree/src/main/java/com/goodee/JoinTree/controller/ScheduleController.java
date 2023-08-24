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
	
	// 전사 일정 출력 페이지
		@GetMapping("schedule/companySchedule")
	    public String companySchedulePage(Model model,
	    		@RequestParam(name="scheduleCategory", defaultValue = "S0101") String scheduleCategory) {
			
			List<Schedule> schedules = scheduleService.selectCompanySchedules(scheduleCategory);
			model.addAttribute("scheduleCategory", scheduleCategory);
			model.addAttribute("schedules", schedules);
			return "schedule/companySchedule";
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
	            eventData.put("title", schedule.getScheduleTitle());
	            eventData.put("start", schedule.getScheduleStart());
	            eventData.put("end", schedule.getScheduleEnd());
	            eventData.put("allDay", false); // 현재 데이터에 allDay 정보가 없으므로 기본값으로 설정
	            eventDataList.add(eventData);
	        }
	        
	        // JSON 형식의 데이터를 ResponseEntity에 넣어서 반환
	        return new ResponseEntity<>(eventDataList, HttpStatus.OK);
	    }
		
	// 부서 일정 출력 페이지
		
		
	// 부서 일정 데이터를 JSON 형태로 반환
		
	// 개인 일정 출력 페이지
	@GetMapping("schedule/personalSchedule")
    public String personalSchedulePage(Model model, HttpSession session,
    		@RequestParam(name="scheduleCategory", defaultValue = "S0103") String scheduleCategory) {
		
		// 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		// 일정 분류 코드
		
		List<Schedule> schedules = scheduleService.selectPersonalSchedules(empNo, scheduleCategory);
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("schedules", schedules);
		
		return "schedule/personalSchedule";
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
            eventData.put("title", schedule.getScheduleTitle());
            eventData.put("start", schedule.getScheduleStart());
            eventData.put("end", schedule.getScheduleEnd());
            eventData.put("allDay", false); // 현재 데이터에 allDay 정보가 없으므로 기본값으로 설정
            eventDataList.add(eventData);
        }
        
        // JSON 형식의 데이터를 ResponseEntity에 넣어서 반환
        return new ResponseEntity<>(eventDataList, HttpStatus.OK);
    }
	// 전사 일정 추가
	// 부서 일정 추가
	
	// 개인 일정 추가
	@PostMapping("/schedule/addPersonalSchedule")
	public ResponseEntity<Map<String, Object>> addPersonalSchedule(@RequestBody Schedule schedule, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    
	    // 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
	    
		String scheduleCategory = "S0103";
	    // empNo를 schedule에 설정
	    schedule.setEmpNo(empNo);
	    schedule.setScheduleCategory(scheduleCategory);
	//    schedule.setCreateId(empNo);
	   // schedule.setUpdateId(empNo);
	    
	    log.debug(scheduleCategory);
	    
	    // 스케줄 추가 로직
	    try {
	        scheduleService.addPersonalSchedule(schedule);
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
	
	

}
