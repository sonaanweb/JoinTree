package com.goodee.JoinTree.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.JoinTree.mapper.EmpManageMapper;
import com.goodee.JoinTree.vo.*;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class EmpManageService {

	@Autowired
	private EmpManageMapper empManageMapper;
	
	// 부서 조회
	public List<CommonCode> deptCodeList(){
		
		List<CommonCode> deptCodeList = empManageMapper.selectDeptCodeList();
		log.debug(deptCodeList+"<-- EmpManageService deptCodeList");
		
		return deptCodeList;
	};
	
	// 직급 조회
	public List<CommonCode> positionCodeList(){
		
		List<CommonCode> positionCodeList = empManageMapper.selectPositionCodeList();
		log.debug(positionCodeList+"<-- EmpManageService positionCodeList");
		return positionCodeList;
		
	};
	
	// 사원 상태 조회
	public List<CommonCode> activeCodeList() {
		
		List<CommonCode> activeCodeList = empManageMapper.selectActiveCodeList();
		log.debug(activeCodeList+"<-- EmpManageService activeCodeList");
		return activeCodeList;
	}
	
	// 사원정보 등록
	public int addEmpInfo(Map<String, Object> empInfo) {
		
		// 사번 생성(현재 연도 + 부서코드 + 부서별 입사순서) 총 8자리
		// 현재 연도
		Calendar calendar = Calendar.getInstance(); // Calendar API
		int currentYear = calendar.get(Calendar.YEAR); // 현재 연도
		int empNoYear = currentYear * 10000; // 자리 수를 맞추기 위해 * 10000
		log.debug(empNoYear+"<-- EmpManageService empNoYear");
		
		// 부서코드 번호
		String dept = (String)empInfo.get("dept"); // empInfo에 저장된 dept
		System.out.println(dept+"<-- dept");
		int deptNo = Integer.parseInt(dept.substring(dept.length() -1)) * 100; // 코드의 마지막 번호 추출. 자리 수를 맞추기 위해 * 100
		log.debug(deptNo+"<-- EmpManageService deptNo");
		
		// 현재 연도 부서별 입사순서
		Map<String, Object> currentYearDeptCnt = new HashMap<String, Object>(); // 요청 매개값 Map 저장
		currentYearDeptCnt.put("currentYear", currentYear); // 현재 연도
		currentYearDeptCnt.put("dept", dept); // 부서코드
		
		int deptEmpCnt = empManageMapper.selectDeptEmpCnt(currentYearDeptCnt) + 1; // 부서별 인원수 + 1
		log.debug(deptEmpCnt+"<-- EmpManageService deptEmpCnt");
		
		// deptEmpCnt 포멧한 문자열 담을 변수 초기화
		String formatDeptEmpCnt = null;
		if(deptEmpCnt <= 99) { // deptEmpCnt 범위 99이하 일 때
			// deptEmpCnt의 값을 두자리 문자열로 포멧. 1의 자리일 경우 앞자리를 0으로 채우도록 포멧한다
			formatDeptEmpCnt = String.format("%02d", deptEmpCnt);  
		} else {
			// 99를 초과하면 0 return
			return 0;
		}
		
		// 최종 사번
		int empNo = empNoYear + deptNo + Integer.parseInt(formatDeptEmpCnt);
		log.debug(empNo+"<-- EmpManageService empNo");
		
		// 주소
		String zip = (String)empInfo.get("zip");
		String add1 = (String)empInfo.get("add1");
		String add2 = (String)empInfo.get("add2");
		String add3 = (String)empInfo.get("add3");
		// 주소 합쳐서 저장
		String empAddress = String.join("-", zip, add1, add2, add3);
		log.debug(empAddress+"<-- EmpManageService empAddress");
		
		// 연락처
		String empPhone1 = (String)empInfo.get("empPhone1");
		String empPhone2 = (String)empInfo.get("empPhone2");
		String empPhone3 = (String)empInfo.get("empPhone3");
		// 연락처 합쳐서 저장
		String empPhone = String.join("-", empPhone1, empPhone2, empPhone3);
		log.debug(empPhone+"<-- EmpManageService empPhone");
		
		// 주민번호
		String empJuminNo1 = (String)empInfo.get("empJuminNo1");
		String empJuminNo2 = (String)empInfo.get("empJuminNo2");
		// 주민번호 합쳐서 저장
		String empJuminNo = String.join("-", empJuminNo1, empJuminNo2);
		log.debug(empJuminNo+"<-- EmpManageService empJuminNo");
		
		// empInfo 값 저장(사번, 주소, 연락처, 주민번호)
		empInfo.put("empNo", empNo);
		empInfo.put("empAddress", empAddress);
		empInfo.put("empPhone", empPhone);
		empInfo.put("empJuminNo", empJuminNo);
		
		
		// 사원정보 등록
		int addEmpInfoRow = empManageMapper.addEmpInfo(empInfo);
		log.debug(addEmpInfoRow+"<-- EmpManageService addEmpInfoRow");
		
		// vo AccountList 값 저장
		AccountList accountList = new AccountList();
		accountList.setEmpNo(empNo);
		accountList.setCreateId((Integer)empInfo.get("createId"));
		accountList.setUpdateId((Integer)empInfo.get("updateId"));
		
		// vo ReshuffleHistory 값 저장
		ReshuffleHistory reshuffleHistory = new ReshuffleHistory();
		reshuffleHistory.setEmpNo(empNo);
		reshuffleHistory.setDepartNo(dept);
		reshuffleHistory.setPosition((String)empInfo.get("position"));
		reshuffleHistory.setCreateId((Integer)empInfo.get("createId"));
		reshuffleHistory.setUpdateId((Integer)empInfo.get("updateId"));
		
		// addEmpInfoRow 값의 따른 분기
		if(addEmpInfoRow == 0) {
			log.debug(addEmpInfoRow+"<-- EmpManageService addEmpInfoRow 회원 등록 실패");
		} else if(addEmpInfoRow == 1) {
			System.out.println(addEmpInfoRow + "<-- EmpManageService addEmpInfoRow 회원 등록 성공");
			
			// 계정 등록
			int addAccountRow = empManageMapper.addAccount(accountList);
			if(addAccountRow == 0) {
				log.debug(addAccountRow+"<-- EmpManageService addAccountRow 계정 등록 실패");
			} else if(addAccountRow == 1) {
				log.debug(addAccountRow+"<-- EmpManageService addAccountRow 계정 등록 성공");
			} else {
				log.debug(addAccountRow+"<-- EmpManageService error addAccountRow");
			}
			
			// 인사이동 이력 등록
			int addreshuffleHistoryRow = empManageMapper.addReshuffleHistory(reshuffleHistory);
			if(addreshuffleHistoryRow == 0) {
				log.debug(addreshuffleHistoryRow+"<-- EmpManageService addreshuffleHistoryRow 인사이동이력 등록 실패");
			} else if(addreshuffleHistoryRow == 1) {
				log.debug(addreshuffleHistoryRow+"<-- EmpManageService addreshuffleHistoryRow 인사이동이력 등록 성공");
			} else {
				log.debug(addreshuffleHistoryRow+"<-- EmpManageService error addreshuffleHistoryRow");
			}
			
		} else {
			log.debug(addEmpInfoRow+"<-- EmpManageService error addEmpInfoRow");
		}
		
		return addEmpInfoRow;
	}
	
	// 사원 목록 조회
	public Map<String, Object> searchEmpList(Map<String, Object> searchEmpListMap, Map<String, Integer> pagingMap) {
		
		// 사번(empNo) 형 변환
		String empNoStr = String.valueOf(searchEmpListMap.get("empNo"));
		int empNo = 0;
		if(empNoStr != null && !empNoStr.isEmpty()) {
			empNo = Integer.parseInt(empNoStr);
		}
		
		// 반환값1 (검색 조건 별 행의 수)
		int searchEmpListCnt = empManageMapper.searchEmpListCnt(searchEmpListMap);
		log.debug(searchEmpListCnt+"<-- EmpManageService searchEmpListCnt");
		
		// 페이징
		int currentPage = (int) pagingMap.get("currentPage");
		int rowPerPage = (int) pagingMap.get("rowPerPage");
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = searchEmpListCnt / rowPerPage;
		if(searchEmpListCnt % rowPerPage !=0) {
			lastPage +=1;
		}
		
		// 페이지 블럭
		int currentblock = 0; // 현제 페이지 블럭(currentPage / pageLength)
		int pageLength = 10; // 현제 페이지 블럭의 들어갈 페이지 수
		if(currentPage % pageLength == 0) {
			currentblock = currentPage / pageLength;
		} else {
			currentblock = (currentPage / pageLength) +1;
		}
		
		int startPage = (currentblock -1) * pageLength +1; // 블럭의 시작페이지
		int endPage = startPage + pageLength -1; // 블럭의 마지막 페이지
		if(endPage > lastPage) {
			endPage = lastPage;
		}
		
		// searchEmpList Map에 값 저장
		searchEmpListMap.put("empNo", empNo);
		searchEmpListMap.put("beginRow", beginRow);
		searchEmpListMap.put("rowPerPage", rowPerPage);
		
		// 반환값2 (검색 조건 별 리스트)
		List<Map<String, Object>> searchEmpListByPage = empManageMapper.searchEmpList(searchEmpListMap);
		log.debug(searchEmpListByPage+"<-- EmpManageService searchEmpListByPage");
		
		HashMap<String, Object> searchEmpListResult = new HashMap<>();
		searchEmpListResult.put("searchEmpListByPage", searchEmpListByPage);
		searchEmpListResult.put("startPage", startPage);
		searchEmpListResult.put("endPage", endPage);
		searchEmpListResult.put("lastPage", lastPage);
		searchEmpListResult.put("pageLength", pageLength);
		
		return searchEmpListResult;
	}
	
	// 사원정보 상세조회
	public Map<String, Object> selectEmpOne(int empNo) {
		
		Map<String, Object> selectEmpOne = empManageMapper.selectEmpOne(empNo);
		log.debug(selectEmpOne+"<-- EmpManageService selectEmpOne");
		return selectEmpOne;
	}

}
