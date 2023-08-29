package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Schedule;

@Mapper
public interface ScheduleMapper {
	
	// 전사 일정 출력
	List<Schedule> selectCompanySchedules(String scheduleCategory);
	
	// 부서 일정 출력
	List<Schedule> selectDepartmentSchedules(String dept, String scheduleCategory);
	
	// 개인 일정 출력
	List<Schedule> selectPersonalSchedules(int empNo, String scheduleCategory);
	
	// 홈 - 오늘의 일정 출력
	List<Schedule> selectTodaySchedules(String dept, int empNo);
	
	
	// 일정 추가
	int addSchedule(Schedule schedule);
	
	
	// 일정 상세보기
	Schedule selectScheduleOne(int scheduleNo);
	
	
	// 일정 삭제
	int removeSchedule(Schedule schedule);
	
	
	// 일정 수정
	int modifySchedule(Schedule schedule);
	


}
