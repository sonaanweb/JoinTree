package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
	
	// 회의실 목록 조회
	@GetMapping("/equipment/meetRoomList")
	public String meetRoomList(Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
		
		Map<String, Object> paramMap = new HashMap<>();
		List<MeetingRoom> meetRoomList = meetRoomService.getMeetRoomList(paramMap);
		model.addAttribute("meetRoomList", meetRoomList); //view ${}
		
		log.debug(AN+"MeetRoomController.meetRoomList : "+meetRoomList.toString()+RE);
		return "/equipment/meetRoomList"; // 뷰 이름 랜더링
	}
	// ------------------------------------------------
	
	// 회의실 추가
	@PostMapping("/addMeetRoom")
	@ResponseBody
	public Map<String, String> addMeetRoom(@ModelAttribute MeetingRoom meetingRoom,
			HttpSession session,HttpServletRequest request) {
	    		
		String path = request.getServletContext().getRealPath("/roomImg/");
		
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");	
		int empNo = loginAccount.getEmpNo();
	    meetingRoom.setEmpNo(empNo);
	    
	    String equipCategory = "E0101"; // 회의실 공통 코드 IN
	    meetingRoom.setEquipCategory(equipCategory);

	    log.debug(AN + "MeetRoomController.equipCategory : " + equipCategory.toString() + RE);
	    log.debug(AN + "MeetRoomController.addmeetingRoom : " + meetingRoom.toString() + RE);
	    
	    Map<String, String> response = new HashMap<>();
	    try {
	        meetRoomService.addMeetRoom(meetingRoom,path);
	        response.put("status", "success");
	    } catch (Exception e) {
	        response.put("status", "error");
	        response.put("message", e.getMessage());
	    }

	    return response;
	}
    
	// 회의실 수정 액션
	@PostMapping("/equipment/modifyMeetRoom")
	@ResponseBody
	public String updateMeetRoom(@ModelAttribute MeetingRoom meetingRoom, HttpSession session, HttpServletRequest request) {
	    try {
	        AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");	
	        int empNo = loginAccount.getEmpNo();
	        meetingRoom.setEmpNo(empNo);
	        
	        // 파일 저장 경로 설정
	        String path = request.getServletContext().getRealPath("/roomImg/");
	        
	        meetRoomService.modifyMeetRoom(meetingRoom, path);
	        
	        log.debug(AN + "MeetRoomController.modfiymeetingRoom : " + meetingRoom.toString() + RE);
	        
	        return "success"; // 성공적으로 수정된 경우
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error"; // 수정 중 오류가 발생한 경우
	    }
	}
    // ------------------------------------------------
    
    // 회의실 수정시 불러올 정보(ajax)
	@GetMapping("/modifyMeetRoom")
	public @ResponseBody MeetingRoom meetingRoom(MeetingRoom meetingRoom, Model model) {
	    MeetingRoom modiMeetingRoom = meetRoomService.getMeetRoomNo(meetingRoom);

	    MultipartFile multipartFile = meetingRoom.getMultipartFile();
	    modiMeetingRoom.setMultipartFile(multipartFile);

	    log.debug(AN + "modiMeetingRoom: 정보:" + modiMeetingRoom + RE);
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
    public String deleteMeetRoom(int roomNo, String path,HttpServletRequest request) {
    	
    	path = request.getServletContext().getRealPath("/roomImg/");
    	MeetingRoom meetingRoom = new MeetingRoom();
    	meetingRoom.setRoomNo(roomNo);
    	//meetingRoom.setCreateId();
		int row = meetRoomService.removeMeetRoom(meetingRoom,path);
        if (row > 0) {
            return "success";
        } else {
            return "fail";
        }
    } 
    
    // 회의실 이름 검색
    @GetMapping("/equipment/searchMeetRoom")
    @ResponseBody
    public ResponseEntity<List<MeetingRoom>> searchMeetRoom(
    		@RequestParam(name = "roomName", required = false) String roomName) {
    	Map<String, Object> paramMap = new HashMap<>();
    	paramMap.put("roomName", roomName);
        List<MeetingRoom> searchResults = meetRoomService.searchMeetRoom(paramMap);
        log.debug(AN+"회의실 이름 searchResults: "+paramMap+RE);
        return new ResponseEntity<>(searchResults, HttpStatus.OK);
    }
    
    // --------------------------------------------------------------------------------------
 
}
