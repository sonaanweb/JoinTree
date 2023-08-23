package com.goodee.JoinTree.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.CommuteMapper;
import com.goodee.JoinTree.vo.Commute;

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
	
	// 출퇴근 시간 조회
	public Commute selectCommute(int empNo) {
		
		Commute commute = commuteMapper.selectCommute(empNo); 
		return commute;
	}

}
