package com.goodee.JoinTree.service;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.CommuteMapper;
import com.goodee.JoinTree.vo.Commute;
import com.goodee.JoinTree.vo.EmpInfo;
import com.goodee.JoinTree.vo.LeaveRecode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CommuteService {
	
	@Autowired
	CommuteMapper commuteMapper;
	
	// 출근시간 등록
	public int addCommute(Commute commute) {
		
		// 사번, 출퇴근 타입 저장
		int empNo = commute.getEmpNo();
		String commuteCode = "emp_on_time";
		
		// 사번, 출퇴근 타입 Map에 저장
		Map<String, Object> currentOnTimeMap = new HashMap<>();
		currentOnTimeMap.put("empNo", empNo);
		currentOnTimeMap.put("commuteCode", commuteCode);
		
		// 금일 출근기록 조회 후 값의 따른 분기
		int currentOnTime = commuteMapper.currentCommuteCnt(currentOnTimeMap);
		
		// 출근시간 반환 값 저장 변수
		int addCommuteResult = 0;
		
		if(currentOnTime == 0) { // 금일 출근기록이 없을 경우
			// 출근시간 등록
			addCommuteResult = commuteMapper.addCommute(commute);
			
			// addCommute 값에 따른 분기
			if(addCommuteResult == 0) {
				log.debug(addCommuteResult + "<-- CommuteService addCommuteResult 출근시간 등록 실패");
			} else if(addCommuteResult == 1) {
				log.debug(addCommuteResult + "<-- CommuteService addCommuteResult 출근시간 등록 성공");
				
			} else {
				log.debug(addCommuteResult + "<-- CommuteService addCommuteResult error");
			}
		} else {
			log.debug(currentOnTime + "<-- CommuteService currentOnTime 출근시간 기록 유");
		}
		
		return addCommuteResult;
	}
	
	// 퇴근시간 업데이트
	public int modifyCommute(Commute commute) {
		
		// 사번, 출퇴근 타입 저장
		int empNo = commute.getEmpNo();
		String commuteCode = "emp_off_time";
		
		// 사번, 출퇴근 타입 Map에 저장
		Map<String, Object> currentOffTimeMap = new HashMap<>();
		currentOffTimeMap.put("empNo", empNo);
		currentOffTimeMap.put("commuteCode", commuteCode);
		
		// 금일 퇴근기록 조회 후 값의 따른 분기
		int currentOffTime = commuteMapper.currentCommuteCnt(currentOffTimeMap);
		
		// 퇴근시간 반환 값 저장 변수
		int modifyCommuteResult = 0;
		
		if(currentOffTime == 0) {
			
			// 퇴근시간 업데이트
			modifyCommuteResult = commuteMapper.modifyCommute(commute);
			
			// modifyCommuteResult 값에 따른 분기
			if(modifyCommuteResult == 0) {
				log.debug(modifyCommuteResult + "<-- CommuteService modifyCommuteResult 퇴근시간 등록 실패");
			} else if(modifyCommuteResult == 1) {
				log.debug(modifyCommuteResult + "<-- CommuteService modifyCommuteResult 퇴근시간 등록 성공");
			} else {
				log.debug(modifyCommuteResult + "<-- CommuteService modifyCommuteResult 퇴근시간 error");
			}
		} else {
			log.debug(currentOffTime + "<-- CommuteService currentOffTime 퇴근시간 기록 유");
		}
		
		
		return modifyCommuteResult;
	}
	
	// 일별 출퇴근 시간 조회
	public Commute selectCommute(int empNo) {
		
		Commute commute = commuteMapper.selectCommute(empNo); 
		return commute;
	}
	
	// 월별 출퇴근 시간 조회
	public Map<String, Object> getCommuteTimeList(int empNo, Integer targetYear, Integer targetMonth) {
		
		Calendar firstDay = Calendar.getInstance();
		
		// 첫번째 날짜 설정
		firstDay.set(Calendar.DATE, 1);
		
		// 원하는 년/월이 요청 매개값으로 넘어 왔다면
		if(targetYear != null && targetMonth != null) {
			firstDay.set(Calendar.YEAR, targetYear);
			// API애서 자동 분기 12입력 -> 0, 년은 +1, -1이 입력되면 11이 되고 년 -1
			firstDay.set(Calendar.MONTH, targetMonth); 
		}
		
		// 바뀐 년도와 월 정보를 다시 셋팅
        targetYear = firstDay.get(Calendar.YEAR);
        targetMonth = firstDay.get(Calendar.MONTH);
        
        int daysInMonth = firstDay.getActualMaximum(Calendar.DAY_OF_MONTH); // 해당 월의 일수
        
        // 요일 배열 
        String[] daysOfWeek = {"일", "월", "화", "수", "목", "금", "토"};
        
        // 해당 월의 1일의 요일
        int firstDayOfWeek = firstDay.get(Calendar.DAY_OF_WEEK);
 		
		// 사원별 월 출퇴근 시간 목록
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("empNo", empNo);
        paramMap.put("targetYear", targetYear);
        paramMap.put("targetMonth", targetMonth+1);
        
        // 출퇴근 리스트 조회
        List<Commute> commuteTimeList = commuteMapper.getCommuteTimeList(paramMap);
        
        // 연가 리스트 조회
        List<LeaveRecode> leaveRecodeList = commuteMapper.getLeaveRecodeList(paramMap);
        
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("targetYear", targetYear);
        resultMap.put("targetMonth", targetMonth);
        resultMap.put("daysInMonth", daysInMonth);
        resultMap.put("daysOfWeek", daysOfWeek);
        resultMap.put("firstDayOfWeek", firstDayOfWeek);
        resultMap.put("commuteTimeList", commuteTimeList);
        resultMap.put("leaveRecodeList", leaveRecodeList);
        
        log.debug(resultMap.toString() + "<-- CommuteService resultMap");
		
		return resultMap;
	}
	
	// 사원별 입사일 조회
	public EmpInfo getEmpHireDate(int empNo) {
		
		EmpInfo empHireDate = commuteMapper.getEmpHireDate(empNo);
		return empHireDate;
	}
	
	// 월 별 근로시간 통계 조회
	public List<Map<String, Object>> getMonthWorkTimeData(Map<String, Object> monthWorkTimeDataMap) {
		
		List<Map<String, Object>> monthWorkTimeDataResult = commuteMapper.getMonthWorkTimeDate(monthWorkTimeDataMap);
		log.debug(monthWorkTimeDataResult.toString() + "<-- CommuteService monthWorkTimeDataResult");
		return monthWorkTimeDataResult;
	}
	
	// 주 별 근로시간 통계 조회
	public List<Map<String, Object>> getWeekWorkTimeData(Map<String, Object> weekWorkTimeDataMap) {
		
		List<Map<String, Object>> weekWorkTimeDataResult = commuteMapper.getWeekWorkTimeDate(weekWorkTimeDataMap);
		log.debug(weekWorkTimeDataResult.toString() + "<-- CommuteService weekWorkTimeDataResult");
		return weekWorkTimeDataResult;
	}

}
