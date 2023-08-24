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
	public List<Schedule> selectDepartmentSchedules(String scheduleCategory) {
       List<Schedule> personalScheduleList = scheduleMapper.selectDepartmentSchedules(scheduleCategory);
       return personalScheduleList;
	}
		
	// 개인 일정 출력
	public List<Schedule> selectPersonalSchedules(int empNo, String scheduleCategory) {
       List<Schedule> personalScheduleList = scheduleMapper.selectPersonalSchedules(empNo, scheduleCategory);
       return personalScheduleList;
	}
	
	// 개인 일정 추가
	public int addPersonalSchedule(Schedule schedule) {
		return scheduleMapper.addPersonalSchedule(schedule);
		
	}
	
	// 일정 상세보기
	 public Schedule selectScheduleOne(int scheduleNo) {
		 Schedule scheduleOne = scheduleMapper.selectScheduleOne(scheduleNo);
		 return scheduleOne;
    }


}
