package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Commute;
import com.goodee.JoinTree.vo.EmpInfo;
import com.goodee.JoinTree.vo.LeaveRecode;

@Mapper
public interface CommuteMapper {
	
	// 출근시간 등록
	int addCommute(Commute commute);
	
	// 퇴근시간 업데이트
	int modifyCommute(Commute commute);
	
	// 출퇴근 시간 조회
	Commute selectCommute(int empNo);
	
	// 금일 출퇴근 여부 조회
	int currentCommuteCnt(Map<String, Object> currentOnTimeMap);
	
	// 사원별 월 출퇴근 시간 조회
	List<Commute> getCommuteTimeList(Map<String, Object> paramMap);
	
	// 사원별 입사일 조회
	EmpInfo getEmpHireDate (int empNo);
	
	// 월 별 근로시간 통계 조회
	List<Map<String, Object>> getMonthWorkTimeDate(Map<String, Object> monthWorkTimeDataMap);
	
	// 주 별 근로시간 통계 조회
	List<Map<String, Object>> getWeekWorkTimeDate(Map<String, Object> weekWorkTimeDataMap);
	
	// 사원별 월 연가 조회
	List<LeaveRecode> getLeaveRecodeList(Map<String, Object> paramMap);
	
}
