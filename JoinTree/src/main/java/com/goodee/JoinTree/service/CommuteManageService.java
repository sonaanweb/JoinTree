package com.goodee.JoinTree.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.CommuteManageMapper;
import com.goodee.JoinTree.mapper.CommuteMapper;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.EmpInfo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CommuteManageService {
	
	@Autowired
	private CommuteManageMapper commuteManageMapper;
	@Autowired 
	private CommuteMapper commuteMapper;
	
	// 검색별 연차 목록 조회
	public Map<String, Object> searchAnnualLeaveList(Map<String, Object> searchAnnualLeaveList) {
		
		// 반환값1 (검색 조건 별 행의 수)
		int searchAnnualLeaveListCnt = commuteManageMapper.searchAnnualLeaveListCnt(searchAnnualLeaveList);
		log.debug(searchAnnualLeaveListCnt+"<-- CommuteService searchAnnualLeaveListCnt");
		
		// 페이징
		int currentPage = Integer.parseInt((String) searchAnnualLeaveList.get("currentPage")); // 현재 페이지
		int rowPerPage = Integer.parseInt((String) searchAnnualLeaveList.get("rowPerPage")); // 페이지당 행의 수
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = searchAnnualLeaveListCnt / rowPerPage;
		if(searchAnnualLeaveListCnt % rowPerPage !=0) {
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
		
		// searchAnnualLeaveList Map에 값 저장
		searchAnnualLeaveList.put("beginRow", beginRow);
		searchAnnualLeaveList.put("rowPerPage", rowPerPage);
		
		// 반환값2 (검색 조건 별 목록)
		List<Map<String, Object>> searchAnnualLeaveListByPage = commuteManageMapper.searchAnnualLeaveList(searchAnnualLeaveList);
		log.debug(searchAnnualLeaveListByPage+"<-- CommuteService searchAnnualLeaveList");
		
		Map<String, Object> searchAnnualLeaveListResult = new HashMap<>();
		searchAnnualLeaveListResult.put("searchAnnualLeaveListByPage", searchAnnualLeaveListByPage);
		searchAnnualLeaveListResult.put("startPage", startPage);
		searchAnnualLeaveListResult.put("endPage", endPage);
		searchAnnualLeaveListResult.put("lastPage", lastPage);
		searchAnnualLeaveListResult.put("pageLength", pageLength);
		searchAnnualLeaveListResult.put("currentPage", currentPage);
		
		return searchAnnualLeaveListResult;
	}
	
	// 검색별 연가 목록 조회
	public Map<String, Object> searchLeaveRecodeList(Map<String, Object> searchLeaveRecodeList) {
		
		// 반환값1 (검색 조건 별 행의 수)
		int searchLeaveRecodeListCnt = commuteManageMapper.searchLeaveRecodeListCnt(searchLeaveRecodeList);
		log.debug(searchLeaveRecodeListCnt+"<-- CommuteService searchLeaveRecodeListCnt");
		
		// 페이징
		int currentPage = Integer.parseInt((String) searchLeaveRecodeList.get("currentPage")); // 현재 페이지
		int rowPerPage = Integer.parseInt((String) searchLeaveRecodeList.get("rowPerPage")); // 페이지당 행의 수
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = searchLeaveRecodeListCnt / rowPerPage;
		if(searchLeaveRecodeListCnt % rowPerPage !=0) {
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
		
		// searchLeaveRecodeList Map에 값 저장
		searchLeaveRecodeList.put("beginRow", beginRow);
		searchLeaveRecodeList.put("rowPerPage", rowPerPage);
		
		// 반환값2 (검색 조건 별 목록)
		List<Map<String, Object>> searchLeaveRecodeListByPage = commuteManageMapper.searchLeaveRecodeList(searchLeaveRecodeList);
		log.debug(searchLeaveRecodeListByPage+"<-- CommuteService searchLeaveRecodeListByPage");
		
		Map<String, Object> searchLeaveRecodeListResult = new HashMap<>();
		searchLeaveRecodeListResult.put("searchLeaveRecodeListByPage", searchLeaveRecodeListByPage);
		searchLeaveRecodeListResult.put("startPage", startPage);
		searchLeaveRecodeListResult.put("endPage", endPage);
		searchLeaveRecodeListResult.put("lastPage", lastPage);
		searchLeaveRecodeListResult.put("pageLength", pageLength);
		searchLeaveRecodeListResult.put("currentPage", currentPage);
		
		return searchLeaveRecodeListResult;
	}
	
	// 검색별 전직원 출퇴근 목록 조회
	public Map<String, Object> searchCommuteFullList(Map<String, Object> searchCommuteFullList) {
		
		// 반환값1 (검색 조건 별 행의 수)
		int searchCommuteFullListCnt = commuteManageMapper.searchCommuteFullListCnt(searchCommuteFullList);
		log.debug(searchCommuteFullListCnt+"<-- CommuteService searchCommuteFullListCnt");
		
		// 페이징
		int currentPage = Integer.parseInt((String) searchCommuteFullList.get("currentPage")); // 현재 페이지
		int rowPerPage = Integer.parseInt((String) searchCommuteFullList.get("rowPerPage")); // 페이지당 행의 수
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = searchCommuteFullListCnt / rowPerPage;
		if(searchCommuteFullListCnt % rowPerPage !=0) {
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
		
		// searchLeaveRecodeList Map에 값 저장
		searchCommuteFullList.put("beginRow", beginRow);
		searchCommuteFullList.put("rowPerPage", rowPerPage);
		
		// 반환값2 (검색 조건 별 목록)
		List<Map<String, Object>> searchCommuteFullListByPage = commuteManageMapper.searchCommuteFullList(searchCommuteFullList);
		log.debug(searchCommuteFullListByPage+"<-- CommuteService searchCommuteFullListByPage");
		
		Map<String, Object> searchCommuteFullListResult = new HashMap<>();
		searchCommuteFullListResult.put("searchCommuteFullListByPage", searchCommuteFullListByPage);
		searchCommuteFullListResult.put("startPage", startPage);
		searchCommuteFullListResult.put("endPage", endPage);
		searchCommuteFullListResult.put("lastPage", lastPage);
		searchCommuteFullListResult.put("pageLength", pageLength);
		searchCommuteFullListResult.put("currentPage", currentPage);
		
		return searchCommuteFullListResult;
	}
	
	// 연가 기록 등록
	public int addLeaveRecode(int empNo, int docEmpNo, Map<String, Object> documentLeave) {
		
		// commuteManageMapper에 전달 할 값 Map에 저장
		Map<String, Object> addLeaveRecodeMap = new HashMap<>();
		addLeaveRecodeMap.put("docEmpNo", docEmpNo); // 연차 문서 작성 사번
		addLeaveRecodeMap.put("empNo", empNo); // 생성자, 수정자
		addLeaveRecodeMap.put("docNo", documentLeave.get("docNo")); // 문서번호
		addLeaveRecodeMap.put("leaveStartDate", documentLeave.get("docLeaveStartDate")); // 시작일
		addLeaveRecodeMap.put("leaveEndDate", documentLeave.get("docLeaveEndDate")); // 종료일
		addLeaveRecodeMap.put("leavePeriodDate", documentLeave.get("docLeavePeriodDate")); // 연가 사용일 수
		addLeaveRecodeMap.put("leaveType", documentLeave.get("leaveCategory")); // 연가 구분
		
		int addLeaveRecodeRow = commuteManageMapper.addLeaveRecode(addLeaveRecodeMap);
		log.debug(addLeaveRecodeRow + "<-- CommuteService addLeaveRecodeRow");
		return addLeaveRecodeRow;
	}
	
	// 사원 근로일 수 조회
	public Map<String, Object> getWorkDay(int empNo) {
		
		// 사원 정보 조회
		EmpInfo empInfo = commuteMapper.getEmpHireDate(empNo);
		String empHireDate = empInfo.getEmpHireDate(); // 입사일
		String empName = empInfo.getEmpName(); // 사원명
		
		// 입사일 LocalDate로 변환
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd"); // 사용하는 날짜 형식에 맞게 포맷 설정
		LocalDate hireDate = LocalDate.parse((CharSequence) empHireDate, formatter);
		
		// 현재 날짜 조회
		LocalDate currentDate = LocalDate.now();
		
		// 근로일 수 계산
	    int getWorkDay = 0;
	    while (hireDate.isBefore(currentDate)) {
	        if (hireDate.getDayOfWeek() != DayOfWeek.SATURDAY && hireDate.getDayOfWeek() != DayOfWeek.SUNDAY) {
	            // 주말이 아닌 경우에만 근로일로 간주
	        	getWorkDay++;
	        }
	        hireDate = hireDate.plusDays(1); // 다음 날짜로 이동
	    }
	    
	    Map<String, Object> annualInfo = new HashMap<>();
	    annualInfo.put("empHireDate", empHireDate);
	    annualInfo.put("empName", empName);
	    annualInfo.put("getWorkDay", getWorkDay);
		
		return annualInfo;
	}

}
