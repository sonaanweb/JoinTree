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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.ScheduleService;
import com.goodee.JoinTree.vo.Schedule;
import com.fasterxml.jackson.databind.ObjectMapper; // Jackson 라이브러리 추가

@Controller
public class ScheduleController {
	
	@Autowired
    private ScheduleService scheduleService;
	
	// 전사 일정 출력 페이지
		@GetMapping("schedule/companySchedule")
	    public String companySchedulePage(Model model, HttpSession session) {
			List<Schedule> schedules = scheduleService.selectCompanySchedules();
			model.addAttribute("schedules", schedules);
			return "schedule/companySchedule";
	    }
	
	// 전사 일정 데이터를 JSON 형태로 반환
		@GetMapping("/schedule/getCompanySchedules")
	    @ResponseBody
	    public ResponseEntity<List<Map<String, Object>>> getCompanySchedules(HttpSession session) {
	        // MyBatis를 사용하여 데이터베이스에서 일정 데이터 가져오기
	        List<Schedule> schedules = scheduleService.selectCompanySchedules();
	        
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
		
		
	// 개인 일정 출력 페이지
	@GetMapping("schedule/personalSchedule")
    public String personalSchedulePage(Model model, HttpSession session) {
		int empNo = 11111111; // 임시값 -> 추후 세션값으로 변경예정
		List<Schedule> schedules = scheduleService.selectPersonalSchedules(empNo);
		model.addAttribute("schedules", schedules);
		model.addAttribute("empNo", empNo);
		return "schedule/personalSchedule";
    }
	
	// 개인 일정 데이터를 JSON 형태로 반환
	@GetMapping("/schedule/getPersonalSchedules")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getPersonalSchedules(HttpSession session) {
        // MyBatis를 사용하여 데이터베이스에서 일정 데이터 가져오기
		int empNo = 11111111; // 임시값 -> 추후 세션값으로 변경예정
        List<Schedule> schedules = scheduleService.selectPersonalSchedules(empNo);
        
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
	
	
	// 개인 일정 추가
	@PostMapping("/schedule/add")
    public String addSchedule(Schedule schedule) {
        // 받아온 스케줄 정보를 DB에 저장하는 로직
        scheduleService.addSchedule(schedule);
        return "redirect:/schedule/personalSchedule"; // 추가 후 리다이렉트
    }
	
	// 일정 상세보기
	@GetMapping("/schedule/selectScheduleOne")
    @ResponseBody
    public Schedule selectScheduleOne(@RequestParam int scheduleNo) {
        Schedule schedule = scheduleService.selectScheduleOne(scheduleNo);
        return schedule;
    }


}
