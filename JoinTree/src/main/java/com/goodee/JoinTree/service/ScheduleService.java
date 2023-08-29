package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.ScheduleMapper;
import com.goodee.JoinTree.vo.Schedule;

@Service
public class ScheduleService {
	@Autowired
	private ScheduleMapper scheduleMapper;
	
	// 전사 일정 출력
	public List<Schedule> selectCompanySchedules(String scheduleCategory) {
       List<Schedule> companyScheduleList = scheduleMapper.selectCompanySchedules(scheduleCategory);
       return companyScheduleList;
	}
		
	// 부서 일정 출력
	public List<Schedule> selectDepartmentSchedules(String dept, String scheduleCategory) {
       List<Schedule> departmentScheduleList = scheduleMapper.selectDepartmentSchedules(dept, scheduleCategory);
       return departmentScheduleList;
	}
		
	// 개인 일정 출력
	public List<Schedule> selectPersonalSchedules(int empNo, String scheduleCategory) {
       List<Schedule> personalScheduleList = scheduleMapper.selectPersonalSchedules(empNo, scheduleCategory);
       return personalScheduleList;
	}
	
	// 오늘의 일정 출력
	public List<Schedule> selectTodaySchedules(String dept, int empNo) {
       List<Schedule> todayScheduleList = scheduleMapper.selectTodaySchedules(dept, empNo);
       return todayScheduleList;
	}
	
	// 일정 추가
	public int addSchedule(Schedule schedule) {
		return scheduleMapper.addSchedule(schedule);
	}
	
	// 일정 상세보기
	public Schedule selectScheduleOne(int scheduleNo) {
		Schedule scheduleOne = scheduleMapper.selectScheduleOne(scheduleNo);
		return scheduleOne;
    }
	
	// 일정 삭제
	public int removeSchedule(Schedule schedule) {
		return scheduleMapper.removeSchedule(schedule);
	}
	
	// 일정 수정
	public int modifySchedule(Schedule schedule) {
		return scheduleMapper.modifySchedule(schedule);
	}
	
	 
	 
	 
	 
	


}
