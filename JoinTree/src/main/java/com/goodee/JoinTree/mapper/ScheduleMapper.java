package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Schedule;

@Mapper
public interface ScheduleMapper {
	// 개인 일정 출력
	List<Schedule> selectPersonalSchedules(int empNo);


}
