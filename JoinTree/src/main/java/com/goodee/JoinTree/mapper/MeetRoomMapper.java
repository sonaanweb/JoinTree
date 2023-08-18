package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.MeetingRoom;

@Mapper
public interface MeetRoomMapper {
	// List<vo name> 회의실 목록 메서드
	List<MeetingRoom> selectMeetRoomAll(Map<String,Object> map);
	
	// 전체 행의 수 (리스트 페이징)
	// int selectMeetRoomCount();
	
	// 회의실 추가 메서드
	int insertMeetRoom(MeetingRoom meetingRoom);
	
	// 회의실 삭제 메서드
	int deleteMeetRoom(MeetingRoom meetingRoom);
		
	// 회의실 수정 메서드
	void updateMeetRoom(MeetingRoom meetingRoom);
	
	// 회의실 이름 중복검사 메서드
	int cntRoomName(String roomName);
	
}
