package com.goodee.JoinTree.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MeetReservController {
	@GetMapping("/reservation/meetRoomReserv")
	public String meetRoomReserv() {
		return "/reservation/meetRoomReserv";
	}
}
