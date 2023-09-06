package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.*;

@Mapper
public interface EmpManageMapper {

	// 부서 코드 조회
	List<CommonCode> selectDeptCodeList();
	
	// 현재 연도 부서별 사원 수 조회
	int selectDeptEmpCnt(Map<String, Object> currentYearDeptCnt);
	
	// 직급 코드 조회
	List<CommonCode> selectPositionCodeList();
	
	// 사원 상태 코드 조회
	List<CommonCode> selectActiveCodeList();
	
	// 연가 코드 조회
	List<CommonCode> selectLeaveCodeList();
	
	// 사원정보 등록
	int addEmpInfo(Map<String, Object> empInfo);
	
	// 계정 등록
	int addAccount(AccountList accountList);
	
	// 인사이동 이력 등록
	int addReshuffleHistory(ReshuffleHistory reshuffleHistory);
	
	// 검색별 사원 조회
	List<Map<String, Object>> searchEmpList(Map<String, Object> searchEmpList);
	
	// 검색 조건별 행의 수
	int searchEmpListCnt(Map<String, Object> searchEmpList);
	
	// 사원 상세정보 조회
	Map<String, Object> selectEmpOne(int empNo);
	
	// 인사이동이력 조회
	List<ReshuffleHistory> selectReshuffleHistory(int empNo);
	
	// 사원 활성화 여부 수정
	int modifyEmpActive(Map<String, Object> modifyActive);
	
	// 사원 정보 수정
	int modifyEmpInfo(Map<String, Object> modifyEmpOneMap);

	int getEmpCnt(); // 재직 사원 수 조회
	
	
	
	
	
	

	
}
