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
		public List<Schedule> selectCompanySchedules() {
	       List<Schedule> companyScheduleList = scheduleMapper.selectCompanySchedules();
			return companyScheduleList;
		}
		
	// 부서 일정 출력
		public List<Schedule> selectDepartmentSchedule() {
	       List<Schedule> personalScheduleList = scheduleMapper.selectDepartmentSchedules();
			return personalScheduleList;
		}
		
	// 개인 일정 출력
	public List<Schedule> selectPersonalSchedules(int empNo) {
       List<Schedule> personalScheduleList = scheduleMapper.selectPersonalSchedules(empNo);
		return personalScheduleList;
	}
	
	
	// 개인 일정 추가
	public void addSchedule(Schedule schedule) {
		// TODO Auto-generated method stub
		
	}
	
	// 일정 상세보기
	 public Schedule selectScheduleOne(int scheduleNo) {
	        return scheduleMapper.selectScheduleOne(scheduleNo);
	    }


}
