package com.goodee.JoinTree.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.MeetRoomMapper;
import com.goodee.JoinTree.mapper.MeetRoomReservMapper;
import com.goodee.JoinTree.vo.MeetingRoom;
import com.goodee.JoinTree.vo.Reservation;

@Service
public class MeetRoomReservService {
	@Autowired
	MeetRoomReservMapper meetRoomReservMapper;
	@Autowired
	MeetRoomMapper meetRoomMapper;
	
	// 예약 가능한 회의실 목록 (사원)
	public List<MeetingRoom> getMeetRoomList(Map<String, Object> map) {
        return meetRoomReservMapper.empselectMeetRoomAll(map);
    }
	
	// 회의실 예약 현황 조회
   public List<Reservation> getMeetRoomReservCal(int roomNo) {
	   return meetRoomReservMapper.selectMeetCalList(roomNo);
   }
    
	// 회의실 예약 추가 메서드
	public int addMeetRoomCal(Reservation reservation) {
       return meetRoomReservMapper.insertMeetCal(reservation);
   }
	
	// 회의실 예약 상태 수정 메서드
	public int modifyMeetRoomCal(Reservation reservation) {
		return meetRoomReservMapper.updateMeetCal(reservation);
	}
	
	// 회의실 예약 목록 조회 (사원)
	public List<Reservation> getReservations(Map<String, Object> map){
		return meetRoomReservMapper.selectMeetReserved(map);
	}
	
	// 회의실 예약 목록 조회 (경영지원팀)
	public List<Reservation> getAllReservations(Map<String, Object> map){
		return meetRoomReservMapper.selectAllMeetReserved(map);
	}
	
	// 회의실 예약 목록 검색
	public List<Reservation> searchReservation(Map<String, Object> map){
		return meetRoomReservMapper.getSearchReservation(map);
	}
	
	// 회의실 예약 일자 검색(사원)
	public List<Reservation> searchEmpReservation(Map<String, Object> map){
		return meetRoomReservMapper.getEmpSearchReservation(map);
	}
	
}