package com.goodee.JoinTree.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.MeetRoomMapper;
import com.goodee.JoinTree.vo.MeetingRoom;

@Service
public class MeetRoomService {
	@Autowired
	private MeetRoomMapper meetRoomMapper;
	
	// 회의실 목록 조회 메서드
	public List<MeetingRoom> getMeetRoomList(Map<String, Object> map) {
        return meetRoomMapper.selectMeetRoomAll(map);
    }
}
