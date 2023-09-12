package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommuteManageMapper {
	
	// 연차 목록 조회
	List<Map<String, Object>> searchAnnualLeaveList(Map<String, Object> searchAnnualLeaveList);
	
	// 검색 조건별 행의 수 (연차 목록)
	int searchAnnualLeaveListCnt(Map<String, Object> searchAnnualLeaveList);
	
	// 연가 목록 조회
	int searchLeaveRecodeListCnt(Map<String, Object> searchLeaveRecodeList);
	
	// 검색 조건별 행의 수 (연가 목록)
	List<Map<String, Object>> searchLeaveRecodeList(Map<String, Object> searchLeaveRecodeList);
	
	// 전체사원 출퇴근 목록 조회
	List<Map<String, Object>> searchCommuteFullList(Map<String, Object> searchCommuteFullList);

	// 검색 조건별 행의 수 (출퇴근 목록)
	int searchCommuteFullListCnt(Map<String, Object> searchCommuteFullList);
	
	// 연가 기록 등록
	int addLeaveRecode(Map<String, Object> addLeaveRecodeMap);
	
	// 사원별 연차 정보 조회
	Map<String, Object> getEmpAnnualLeaveInfo(int empNo);
	
	// 잔여연차, 사용연차 조회
	Map<String, Object> getAnnualLeaveCnt(int empNo);
	
	// 사원별 근속일수 조회
	Map<String, Object> getWorkDays(int empNo);
	
	// 사원별 연차 테이블 count 조회
	int getEmpAnnualLeaveCnt(int empNo);
	
	// 발생 연차 등록
	int addAnnualLeave(Map<String, Object> annualInfo);
}
