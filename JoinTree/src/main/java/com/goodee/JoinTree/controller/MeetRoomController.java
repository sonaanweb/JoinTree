package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MeetRoomController {
	static final String Sona = "\u001B[34m";
	static final String RESET = "\u001B[0m";
	
	@Autowired
	private MeetRoomService meetRoomService;
	
	// 아이디 세션 검사 추후 추가 예정
	// 회의실 목록 조회
	@GetMapping("/equipment/meetRoomList")
	public String meetRoomList(Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
		
		List<MeetingRoom> meetRoomList = meetRoomService.getMeetRoomList(paramMap);
		model.addAttribute("meetRoomList", meetRoomList); //view ${}
		
		log.debug(Sona+"MeetRoomController.meetRoomList : "+meetRoomList.toString()+RESET);
		return "/equipment/meetRoomList"; // 뷰 이름 랜더링
	}
	// ------------------------------------------------
	
	// 회의실 추가
    @GetMapping("/equipment/addMeetRoom")
    public String addMeetRoom() {
        return "/equipment/addMeetRoom";
    }

    @PostMapping("/equipment/addMeetRoom")
    public String addMeetRoom(HttpServletRequest request, MeetingRoom meetingRoom) {
    	
    	// 임시 아이디값 ---
    	int createId = Integer.parseInt(request.getParameter("createId"));
    	int updateId = Integer.parseInt(request.getParameter("updateId"));
    	meetingRoom.setCreateId(createId);
    	meetingRoom.setUpdateId(updateId);
    	
        String equipCategory = "E0101"; // 회의실 공통 코드 IN
        
        meetingRoom.setEquipCategory(equipCategory);
        meetRoomService.addMeetRoom(meetingRoom);
        
        log.debug(Sona+"MeetRoomController.equipCategory : "+equipCategory.toString()+RESET);
        log.debug(Sona+"MeetRoomController.addmeetingRoom : "+meetingRoom.toString()+RESET);
        
        return "redirect:/equipment/meetRoomList";
    }
    // ------------------------------------------------
    
    // 회의실 수정 액션(post)
    @PostMapping("/equipment/meetRoomList")
    public String updateMeetRoom(MeetingRoom meetingRoom) { // 회의실 객체 그대로
        meetRoomService.modifyMeetRoom(meetingRoom);
        log.debug(Sona+"MeetRoomController.modfiymeetingRoom : "+meetingRoom.toString()+RESET);
        return "redirect:/equipment/meetRoomList";
    }
    // ------------------------------------------------
    
    // 회의실 추가 & 수정시 회의실명 중복 검사
    @PostMapping("/equipment/cntRoomName")
    public @ResponseBody int checkRoomName(@RequestBody String roomName) {
    	MeetingRoom meetingRoom = new MeetingRoom();
    	meetingRoom.setRoomName(roomName);
        int cnt = meetRoomService.getRoomNameCnt(meetingRoom);
        log.debug(Sona+"MeetRoomController.cnt: "+cnt+RESET);
        return cnt;
    }
    
    // 회의실 삭제
	
}
