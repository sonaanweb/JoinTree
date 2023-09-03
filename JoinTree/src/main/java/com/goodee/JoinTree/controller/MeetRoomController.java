package com.goodee.JoinTree.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.MeetRoomFile;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MeetRoomController {
	static final String AN = "\u001B[34m";
	static final String RE = "\u001B[0m";
	
	@Autowired
	private MeetRoomService meetRoomService;
//	@Autowired
//	private MeetRoomMapper meetRoomMapper;
	
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
	@ResponseBody
	public Map<String, String> addMeetRoom(@RequestBody MeetingRoom meetingRoom, HttpSession session) {
	    
	    // 임시 아이디값 ---
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");	
		int empNo = loginAccount.getEmpNo();
		// empNo를 schedule에 설정
	    meetingRoom.setEmpNo(empNo);
	    
	    String equipCategory = "E0101"; // 회의실 공통 코드 IN
	    meetingRoom.setEquipCategory(equipCategory);

	    log.debug(AN + "MeetRoomController.equipCategory : " + equipCategory.toString() + RE);
	    log.debug(AN + "MeetRoomController.addmeetingRoom : " + meetingRoom.toString() + RE);
	    
	    Map<String, String> response = new HashMap<>();
	    try {
	        meetRoomService.addMeetRoom(meetingRoom);
	        response.put("status", "success");
	    } catch (Exception e) {
	        response.put("status", "error");
	        response.put("message", e.getMessage()); // 에러 메시지 추가
	    }

	    return response;
	}
    
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
    
    // 회의실 이름 검색
    @GetMapping("/equipment/searchMeetRoom")
    @ResponseBody
    public ResponseEntity<List<MeetingRoom>> searchMeetRoom(
    		@RequestParam(name = "roomName", required = false) String roomName) {
    	Map<String, Object> paramMap = new HashMap<>();
    	paramMap.put("roomName", roomName);
        List<MeetingRoom> searchResults = meetRoomService.searchMeetRoom(paramMap);
        log.debug(AN+"searchResults: "+paramMap+RE);
        return new ResponseEntity<>(searchResults, HttpStatus.OK);
    }
    
    
	/*
	 * // 회의실 이미지 추가 (AJAX)
	 * 
	 * @PostMapping("/addMeetRoomFiles")
	 * 
	 * @ResponseBody public String addMeetRoomFiles(@RequestParam("meetRoomFiles")
	 * List<MultipartFile> meetRoomFiles, HttpServletRequest
	 * request, @RequestParam("roomNo") int roomNo) { try { if (meetRoomFiles !=
	 * null && !meetRoomFiles.isEmpty()) { String path =
	 * request.getServletContext().getRealPath("/roomImg/"); // 경로
	 * 
	 * List<MeetRoomFile> roomFileList = new ArrayList<>();
	 * 
	 * for (MultipartFile meetRoomFile : meetRoomFiles) { String filename =
	 * saveFile(meetRoomFile, path);
	 * 
	 * if (filename != null) { MeetRoomFile roomFile = new MeetRoomFile();
	 * roomFile.setRoomNo(roomNo);
	 * roomFile.setRoomOriginFilename(meetRoomFile.getOriginalFilename());
	 * roomFile.setRoomSaveFilename(filename);
	 * roomFile.setRoomFiletype(meetRoomFile.getContentType());
	 * roomFile.setRoomFilesize(meetRoomFile.getSize());
	 * 
	 * roomFileList.add(roomFile); } }
	 * 
	 * int row = meetRoomService.addMeetRoomFiles(roomFileList);
	 * 
	 * if (row == roomFileList.size()) { return "success"; } } } catch (Exception e)
	 * { e.printStackTrace(); } return "error"; }
	 * 
	 * // UUID private String saveFile(MultipartFile file, String path) { String
	 * filename = null; try { // 파일 저장 경로에 저장 if (!file.isEmpty()) { filename =
	 * UUID.randomUUID().toString() + "_" + file.getOriginalFilename(); byte[] bytes
	 * = file.getBytes(); Path filePath = Paths.get(path + filename);
	 * Files.write(filePath, bytes); } } catch (IOException e) {
	 * e.printStackTrace(); } return filename; }
	 */
}
