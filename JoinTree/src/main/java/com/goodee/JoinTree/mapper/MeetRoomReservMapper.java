package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.MeetingRoom;
import com.goodee.JoinTree.vo.Reservation;
@Mapper
public interface MeetRoomReservMapper {
	
	// 회의실 리스트
	List<MeetingRoom> selectMeetRoomAll(Map<String,Object> map);
	
	// 예약 캘린더 데이터 출력
	// List<vo name> 회의실 예약 목록 메서드
	List<Reservation> selectMeetCalList(int roomNo);
}
