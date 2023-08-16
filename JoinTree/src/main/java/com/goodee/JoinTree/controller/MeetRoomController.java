package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MeetRoomController {
	@Autowired
	private MeetRoomService meetRoomService;
	
	@GetMapping("/equipment/meetRoomList")
	public String meetRoomList(Model model, 
			@RequestParam(name="equip_category",defaultValue = "E0101") String equipCategory,
			@RequestParam(name="yn_status",defaultValue = "A0401") String ynStatus){
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
        paramMap.put("ynStatus", ynStatus);
		
		List<MeetingRoom> resultList = meetRoomService.getMeetRoomList(paramMap);
		model.addAttribute("resultList", resultList);
		
		return "/equipment/meetRoomList"; // 뷰 이름 랜더링
	}
}
