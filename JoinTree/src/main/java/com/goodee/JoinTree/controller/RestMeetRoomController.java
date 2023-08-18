package com.goodee.JoinTree.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/rest") //	requestMapping 경로 앞에 /rest
public class RestMeetRoomController {
	
	static final String Sona = "\u001B[34m";
	static final String RESET = "\u001B[0m";
	
	 @Autowired
	    private MeetRoomService meetRoomService;

	 	// 회의실 수정
	 	/*@PostMapping("/modifyMeetRoom")
	 	public MeetingRoom modifyMeetRoom(MeetingRoom meetingRoom){ // meetingroom 객체
			meetRoomService.modifyMeetRoom(meetingRoom);
			log.debug(Sona+"restMeetController.modiMR : "+meetingRoom.toString()+RESET);
        	return 
	 	}
	 	*/
	 
	    @PostMapping("/modifyMeetRoom") //ajax를 사용한 매핑(상대경로) - /rest/modifyMeetRoom
	    public ResponseEntity<String> modifyMeetRoom(@RequestBody MeetingRoom meetingRoom) {
	        meetRoomService.modifyMeetRoom(meetingRoom);
	        log.debug(Sona + "RestMeetRoomController.modifyMeetRoom : " + meetingRoom.toString() + RESET);
	        return ResponseEntity.ok("수정이 완료되었습니다");
	    }
	    
	    // 회의실 추가
	    @PostMapping("/addMeetRoom")
	    public ResponseEntity<String> addMeetRoom(@RequestBody MeetingRoom meetingRoom) {
	        // 임시 아이디값 설정 등의 로직은 이곳에서 처리 가능
	        String equipCategory = "E0101"; // 회의실 공통 코드 IN
	        meetingRoom.setEquipCategory(equipCategory);
	        meetRoomService.addMeetRoom(meetingRoom);
	        log.debug(Sona + "RestMeetRoomController.addMeetRoom : " + meetingRoom.toString() + RESET);
	        return ResponseEntity.ok("Meeting room added successfully.");
	    }
	
}
