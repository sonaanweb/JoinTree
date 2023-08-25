package com.goodee.JoinTree.service;

import java.util.ArrayList;
import java.util.HashMap;
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
   public List<Map<String, Object>> getMeetRoomReservCal(int roomNo) {
        List<Map<String, Object>> eventList = new ArrayList<>();
        
        List<Reservation> reservationList = meetRoomReservMapper.selectMeetCalList(roomNo);
        for (Reservation reservation : reservationList) {
            Map<String, Object> event = new HashMap<>();
            event.put("title", reservation.getRevReason()); //회의실 이름이 와야 한다
            event.put("start", reservation.getRevStartTime());
            event.put("end", reservation.getRevEndTime());
            eventList.add(event);
            System.out.print(reservationList);
        }
        
        return eventList;
    }
}