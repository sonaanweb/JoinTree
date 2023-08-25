package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Commute;

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
	List<Commute> getCommuteTimeList(Map<String, Object> commuteTimeListMap);

}
