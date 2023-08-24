package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.MeetRoomReservService;
import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class MeetReservController {
	static final String Sona = "\u001B[34m";
	static final String RESET = "\u001B[0m";
	
	@Autowired MeetRoomReservService meetRoomReservService;	
	@Autowired MeetRoomService meetRoomService;
	
	// 예약 가능한 회의실 List(클릭시 캘린더로 넘어가야 함)
	@GetMapping("/reservation/meetRoomList")
	public String meetRoomList(Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
		
		List<MeetingRoom> meetRoomList = meetRoomService.getMeetRoomList(paramMap);
		model.addAttribute("meetRoomList", meetRoomList); //view ${}
		
		log.debug(Sona+"MeetRoomReSERVController.meetRoomList : "+meetRoomList.toString()+RESET);
		return "/reservation/meetRoomList"; // 뷰 이름 랜더링
	}
	
	
	// 회의실 예약 현황 페이지
	/*@GetMapping("/reservation/meetRoomReserv")
	@ResponseBody
	public String meetRoomReserv(HttpSession session,Model model) {
		List<Reservation> meetCalList = meetRoomReservService.getMeetRoomReservCal(new HashMap<>());
		model.addAttribute("meetCalList",meetCalList);
		// 왜 출력 안 되지 
		log.debug(Sona+"meetReservController.meetCalList:"+meetCalList+RESET);
		return "/reservation/meetRoomReserv";
	}*/
	
	@GetMapping("/reservation/meetRoomReserv")
	public String viewMeetCal(@RequestParam(name = "roomNo") int roomNo, Model model) {
		model.addAttribute("roomNo", roomNo);
		log.debug(Sona+"Room No: " + roomNo+RESET); // 값 정상
		return "/reservation/meetRoomReserv";
	}
	
    @GetMapping("/meetRoomReserv")
    @ResponseBody
    public List<Map<String, Object>> getMeetCal(@RequestParam(name = "roomNo") int roomNo) {
        return meetRoomReservService.getMeetRoomReservCal(roomNo);
    }
}
