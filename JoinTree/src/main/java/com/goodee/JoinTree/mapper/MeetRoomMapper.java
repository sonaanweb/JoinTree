package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.MeetRoomFile;
import com.goodee.JoinTree.vo.MeetingRoom;

@Mapper
public interface MeetRoomMapper {
	// List<vo name> 회의실 목록 메서드
	List<MeetingRoom> selectMeetRoomAll(Map<String,Object> map);
	
	// 회의실 추가 메서드
	int insertMeetRoom(MeetingRoom meetingRoom);
	
	// 회의실 삭제 메서드
	int deleteMeetRoom(MeetingRoom meetingRoom);
		
	// 회의실 수정 메서드
	int updateMeetRoom(MeetingRoom meetingRoom);
	
	// 회의실 이름 중복검사 메서드
	int selectRoomName(MeetingRoom meetingRoom);
	
	// 회의실 상세
	MeetingRoom selectMeetRoomOne(MeetingRoom meetingRoom);
	
	// 회의실 이름 검색
	List<MeetingRoom> searchMeetRoom(Map<String,Object> map);
	
	// ------------------------------------------------------
	
	// 회의실 이미지 추가 메서드 (파일)
	int insertMeetRoomFile(MeetRoomFile meetRoomFile);
	
	// 회의실 이미지 상세 조회 메서드
	MeetRoomFile selectMeetRoomFile(int roomNo);
	
	// 회의실 이미지 삭제 메서드
	int removeMeetRoomFile(int roomNo);
	
	// 첨부파일 개수 cnt
	int selectMeetRoomFileCnt(int roomNo);

}
