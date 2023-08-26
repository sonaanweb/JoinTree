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
	
	// 회의실 리스트 (사원)
	public List<MeetingRoom> getMeetRoomList(Map<String, Object> map) {
        return meetRoomMapper.selectMeetRoomAll(map);
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
	public void modifyMeetRoomCal(Reservation reservation) {
		meetRoomReservMapper.insertMeetCal(reservation);
	}
	
	/*
	 * // 회의실 수정 객체 public MeetingRoom getMeetRoomNo(MeetingRoom meetingRoom) {
	 * MeetingRoom modiMeetingRoom = meetRoomMapper.selectMeetRoomOne(meetingRoom);
	 * return modiMeetingRoom; }
	 */
}