package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.MeetingRoom;

@Mapper
public interface MeetRoomMapper {
	// List<vo name>
	List<MeetingRoom> selectMeetRoomAll(Map<String,Object> map);
	
	// 전체 행의 수 (리스트 페이징)
	// int selectMeetRoomCount();
}
