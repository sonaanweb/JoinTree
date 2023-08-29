package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MeetRoomController {
	static final String AN = "\u001B[34m";
	static final String RE = "\u001B[0m";
	
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
		
		log.debug(AN+"MeetRoomController.meetRoomList : "+meetRoomList.toString()+RE);
		return "/equipment/meetRoomList"; // 뷰 이름 랜더링
	}
	// ------------------------------------------------
	
	// 회의실 추가
    @PostMapping("/addMeetRoom")
    public String addMeetRoom(HttpServletRequest request, MeetingRoom meetingRoom) {
    	
    	// 임시 아이디값 ---
    	int empNo = 11111111;
    	meetingRoom.setCreateId(empNo);
    	meetingRoom.setUpdateId(empNo);
    	
        String equipCategory = "E0101"; // 회의실 공통 코드 IN
        meetingRoom.setEquipCategory(equipCategory);
    	meetRoomService.addMeetRoom(meetingRoom);
        //meetRoomService.addMeetRoom(meetingRoom);
        
        log.debug(AN+"MeetRoomController.equipCategory : "+equipCategory.toString()+RE);
        log.debug(AN+"MeetRoomController.addmeetingRoom : "+meetingRoom.toString()+RE);
        
        return "redirect:/equipment/meetRoomList";
    }
    /*
    public Map<String, String> addMeetRoom(HttpServletRequest request,@RequestBody MeetingRoom meetingRoom) {
        Map<String, String> response = new HashMap<>();

        int createId = 1111;
        int updateId = 1111;
        meetingRoom.setCreateId(createId);
        meetingRoom.setUpdateId(updateId);

        String equipCategory = "E0101";
        meetingRoom.setEquipCategory(equipCategory);

        meetRoomService.addMeetRoom(meetingRoom);

        response.put("result", "success");
        return response;
    }*/
    // ------------------------------------------------
    
    // 회의실 수정 액션(post)
    @PostMapping("/equipment/modifyMeetRoom")
    public String updateMeetRoom(HttpSession session,MeetingRoom meetingRoom) {
        meetRoomService.modifyMeetRoom(meetingRoom);
        log.debug(AN+"MeetRoomController.modfiymeetingRoom : "+meetingRoom.toString()+RE);
        return "redirect:/equipment/meetRoomList";
    }
    // ------------------------------------------------
    
    // 회의실 수정시 불러올 정보(ajax)
    @PostMapping("/modifyMeetRoom")
    public @ResponseBody MeetingRoom meetingRoom(MeetingRoom meetingRoom) {
    	MeetingRoom modiMeetingRoom = meetRoomService.getMeetRoomNo(meetingRoom);
    	return modiMeetingRoom;
    }
    
    // 회의실 추가 & 수정시 회의실명 중복 검사
    @PostMapping("/cntRoomName")
    @ResponseBody
    public int checkRoomName(@RequestBody String roomName) {
    	MeetingRoom meetingRoom = new MeetingRoom();
    	meetingRoom.setRoomName(roomName);
        int cnt = meetRoomService.getRoomNameCnt(meetingRoom);
        log.debug(AN+"MeetRoomController.cnt: "+cnt+RE);
        return cnt;
    }
    
    // 회의실 삭제
    @PostMapping("/deleteMeetRoom")
    @ResponseBody
    public String deleteMeetRoom(int roomNo) {
    	MeetingRoom meetingRoom = new MeetingRoom();
    	meetingRoom.setRoomNo(roomNo);
    	//meetingRoom.setCreateId();
		int row = meetRoomService.removeMeetRoom(meetingRoom);
        if (row > 0) {
            return "success";
        } else {
            return "fail";
        }
    } 
	
}
