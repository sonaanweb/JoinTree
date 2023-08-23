package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.MeetRoomReservService;
import com.goodee.JoinTree.vo.Reservation;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class MeetReservController {
	static final String Sona = "\u001B[34m";
	static final String RESET = "\u001B[0m";
	
	@Autowired MeetRoomReservService meetRoomReservService;
	
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
	public String viewMeetCal() {
		return "/reservation/meetRoomReserv";
	}
	
    @GetMapping("/meetRoomReserv")
    @ResponseBody
    public List<Map<String, Object>> getMeetCal() {
        return meetRoomReservService.getMeetRoomReservCal();
    }
}
