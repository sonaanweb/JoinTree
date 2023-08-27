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

}
