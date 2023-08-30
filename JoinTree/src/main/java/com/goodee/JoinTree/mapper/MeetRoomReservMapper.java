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
	
	// 회의실 예약 일정 추가
	int insertMeetCal(Reservation reservation);
	
	// 회의실 예약 상태 수정 메서드
	int updateMeetCal(Reservation reservation);
	
	// 회의실 예약 조회(emp)
	List<Reservation> selectMeetReserved(Map<String, Object> map);
	
	// 경영지원팀 예약 관리 리스트 조회(dept -- 구분을 위한 메서드)
	List<Reservation> selectAllMeetReserved(Map<String, Object> map);
	
	// 예약 목록 검색 메서드
	List<Reservation> getSearchReservation(Map<String, Object> SearchReservations);
}
