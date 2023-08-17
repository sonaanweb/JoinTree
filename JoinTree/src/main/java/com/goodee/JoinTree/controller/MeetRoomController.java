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
import org.springframework.web.bind.annotation.RequestParam;

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
	
	// 회의실 목록 Controller ----------------------------
	@GetMapping("/equipment/meetRoomList")
	public String meetRoomList(Model model, 
			@RequestParam(name="equip_category",defaultValue = "E0101") String equipCategory){
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
		
		List<MeetingRoom> meetRoomList = meetRoomService.getMeetRoomList(paramMap);
		model.addAttribute("meetRoomList", meetRoomList); //view ${}
		
		log.debug(Sona+"MeetRoomController.meetRoomList : "+meetRoomList.toString()+RESET);
		return "/equipment/meetRoomList"; // 뷰 이름 랜더링
	}
	// ------------------------------------------------
	
	// 회의실 추가 Controller ----------------------------
	
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
    
    // 회의실 수정 Cotroller --------------------------------
    
    @PostMapping("/equipment/meetRoomList")
    public String updateMeetRoom(MeetingRoom meetingRoom) {
        // 서비스 계층을 통해 데이터베이스에서 해당 레코드 업데이트 수행
        meetRoomService.modifyMeetRoom(meetingRoom);

        // 업데이트 후 리다이렉트 또는 다른 작업 수행
        return "redirect:/equipment/meetRoomList";
    }
	
}
