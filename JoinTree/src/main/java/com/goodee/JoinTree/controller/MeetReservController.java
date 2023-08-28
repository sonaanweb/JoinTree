package com.goodee.JoinTree.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.goodee.JoinTree.service.MeetRoomReservService;
import com.goodee.JoinTree.service.MeetRoomService;
import com.goodee.JoinTree.vo.MeetingRoom;
import com.goodee.JoinTree.vo.Reservation;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class MeetReservController {
	static final String AN = "\u001B[34m";
	static final String RE = "\u001B[0m";
	
	@Autowired MeetRoomReservService meetRoomReservService;	
	@Autowired MeetRoomService meetRoomService;
	
	// 예약 가능한 회의실 List(클릭시 캘린더)
	@GetMapping("/reservation/empMeetRoomList")
	public String meetRoomList(Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
		
		List<MeetingRoom> meetRoomList = meetRoomService.getMeetRoomList(paramMap);
		model.addAttribute("meetRoomList", meetRoomList); //view ${}
		
		log.debug(AN+"MeetRoomReSERVController.meetRoomList : "+meetRoomList.toString()+RE);
		return "/reservation/empMeetRoomList"; // 뷰 이름 랜더링
	}
	
	// 특정 회의실 예약 현황
	@GetMapping("/reservation/meetRoomReserv")
	public String viewMeetCal(@RequestParam(name = "roomNo") int roomNo, Model model) {
		model.addAttribute("roomNo", roomNo);
		log.debug(AN+"Room No: " + roomNo+RE); // 값 정상
		return "/reservation/meetRoomReserv";
	}
	
	// 풀캘린더 사용하는 ajax url
    @GetMapping("/meetRoomReserv")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getMeetCal(@RequestParam(name = "roomNo") int roomNo) {
        List<Map<String, Object>> eventList = new ArrayList<>();
        List<Reservation> reservationList = meetRoomReservService.getMeetRoomReservCal(roomNo);
        for (Reservation reservation : reservationList) {
            Map<String, Object> event = new HashMap<>();
            event.put("title", reservation.getRevReason()); // 예약 사유를 같이 띄워주기 위함
            event.put("start", reservation.getRevStartTime());
            event.put("end", reservation.getRevEndTime());
            eventList.add(event);
            System.out.print(reservationList);
        }
        return new ResponseEntity<>(eventList, HttpStatus.OK);//ResponseEntity를 통한 반환
    }
    
    
    // 요구사항 : 겹치는 시간 예약 불가능, select내에 현재 시간 이전이나 이미 예약 된 시간은 회색표시로 선택 불가능
    // + 동시성 (같은 시간대에 같은 시간대 예약을 했을 시 alert창으로 제어
    // 캘린더에 표시될 content는 모달창에서 요구한 메모내용이 같이 띄어짐
    // 예약 취소는 삭제가 되는 게 아니라 상태가 변하는 것. 예약완료인 예약건만 캘린더에 띄움 A0302(예약완료 기본값) A0303(예약취소)

    // 회의실 예약 추가
    @PostMapping("/addReservation")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addReservation(HttpSession session, @RequestBody Reservation reservation) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            int empNo = 11111111;
            String equipCategory = "E0101"; // 회의실 공통 코드 IN
            reservation.setEmpNo(empNo);
            reservation.setEquipCategory(equipCategory);
            reservation.setRevStatus("A0302"); // 예약 완료 상태로 바로
            reservation.setEquipNo(reservation.getEquipNo()); //equipNo = roomNo 할당
            meetRoomReservService.addMeetRoomCal(reservation);
            response.put("success", true);
            response.put("message", "Reservation added successfully.");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Failed to add reservation.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}

