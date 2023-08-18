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
	
	// 개인일정 출력
	public List<Schedule> selectPersonalSchedules(int empNo) {
       List<Schedule> personalScheduleList = scheduleMapper.selectPersonalSchedules(empNo);
		return personalScheduleList;
	}

	public void addSchedule(Schedule schedule) {
		// TODO Auto-generated method stub
		
	}

}
