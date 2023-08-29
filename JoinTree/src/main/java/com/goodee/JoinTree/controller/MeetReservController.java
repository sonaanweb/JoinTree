package com.goodee.JoinTree.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
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
@EnableScheduling // 스케줄링 활성화
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
            System.out.print("reservationList"+reservationList);
        }
        return new ResponseEntity<>(eventList, HttpStatus.OK);//ResponseEntity를 통한 반환
    }
    
    // + 동시성 (같은 시간대에 같은 시간대 예약을 했을 시...?)

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
            response.put("message", "controller 예약 성공");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "controller 예약 실패");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // (emp) 예약한 회의실 조회(예약 취소 가능)
    @GetMapping("reservation/empMeetRoomReservedList")
	public String empMeetReserved(HttpSession session, Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
    	
    	//AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
 		//int empNo = loginAccount.getEmpNo();
 		int empNo = 11111111;
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
		paramMap.put("empNo", empNo);
			
		List<Reservation> empMeetReserved = meetRoomReservService.getReservations(paramMap);
		model.addAttribute("empMeetReserved", empMeetReserved); //view ${}
		
		log.debug(AN+"empMeetReserved.empMeetReserved : "+empMeetReserved.toString()+RE);
		return "/reservation/empMeetRoomReservedList";
	}
    
    // (emp) 예약 취소 메서드
    @PostMapping("/cancelReserved") // ajax url
    @ResponseBody
    public String cancelReserved(HttpSession session, @RequestBody Reservation reservation) {
        try {
            int empNo = 11111111; // 임시 --> 회의실 조회 그대로
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("equipCategory", "E0101");
            paramMap.put("empNo", empNo);
            
            List<Reservation> empMeetReserved = meetRoomReservService.getReservations(paramMap);
            
            Reservation Reserved = empMeetReserved.stream() // revNo를 가져오는 메서드가 따로 없으니, filter를 통한 검사
                    .filter(r -> r.getRevNo() == reservation.getRevNo()) // R
                    .findFirst() // 일치하는 예약 찾기
                    .orElse(null); // error = null 반환

            if (Reserved != null && Reserved.getRevStatus().equals("A0302")) { // null 값도 아니고 예약 완료 상태라면
            	Reserved.setRevStatus("A0303"); // 취소 상태로 SET
                int result = meetRoomReservService.modifyMeetRoomCal(Reserved);

                if (result > 0) { // 메세지 확인용
                    return "예약취소 완료";
                } else {
                    return "예약취소 신청 오류";
                }
            } else {
                return "예약취소가 불가능한 상태입니다";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
    
    // 현재시간 기준 예약 종료시간 이후면 사용완료로 변경하기 위한 메서드
    /*@Scheduled(cron = "10 * * * * *") // 임시 - 10초마다 실행
    public void updateReservStatus() {
        //log.debug("스케줄 메서드 실행");
        List<MeetingRoom> meetRoomList = meetRoomService.getMeetRoomList(new HashMap<>());

        for (MeetingRoom meetRoom : meetRoomList) {
            int roomNo = meetRoom.getRoomNo();//회의실 별 예약된 내역을 조회해서 데려옴
            List<Reservation> reservations = meetRoomReservService.getMeetRoomReservCal(roomNo);

            LocalDateTime currentTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");//date 시간 타입

            for (Reservation reservation : reservations) {
                LocalDateTime endTime = LocalDateTime.parse(reservation.getRevEndTime(), formatter);
                LocalDateTime currentDateTime = currentTime;

                if (endTime.isBefore(currentDateTime)) { // 현재 시간이 종료시간 이후면
                    if (reservation.getRevStatus().equals("A0302")) {
                        reservation.setRevStatus("A0304"); // 사용완료 상태로 변경
                        meetRoomReservService.modifyMeetRoomCal(reservation);
                    }
                }
            }
        }
    }*/
}
