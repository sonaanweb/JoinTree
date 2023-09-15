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
import com.goodee.JoinTree.vo.AccountList;
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
		
		List<MeetingRoom> meetRoomList = meetRoomReservService.getMeetRoomList(paramMap);
		model.addAttribute("meetRoomList", meetRoomList); //view ${} 모델에 담아 보냄
		log.debug(AN+"예약가능한 회의실 목록.meetRoomListReservCont : "+meetRoomList+RE);
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
            event.put("title", reservation.getEmpNo());
            event.put("start", reservation.getRevStartTime());
            event.put("end", reservation.getRevEndTime());
            eventList.add(event);
            System.out.print("reservationList"+reservationList);
        }
        return new ResponseEntity<>(eventList, HttpStatus.OK);//ResponseEntity를 통한 반환
    }
    
    // + 예약추가 동시성 - 컨트롤단에서 중복검사 (예외처리)

    // 회의실 예약 추가
    @PostMapping("/addReservation")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addReservation(HttpSession session, @RequestBody Reservation reservation) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");    
            int empNo = loginAccount.getEmpNo();
            String equipCategory = "E0101"; // 회의실 공통 코드 IN
            reservation.setEmpNo(empNo);
            reservation.setEquipCategory(equipCategory);
            reservation.setRevStatus("A0301"); // 예약 완료 상태로 바로
            
            // 중복 예약 검사 - 시간대가 겹치면
            if (isOverLapping(reservation)) { // isOverLapping(중복검사 메서드) ----
            									// 아래(true(중복),false(예약완료))기본 순서가 true false, 헷갈려서 바꾸려면 !연산자 사용
                response.put("success", false);
                response.put("message", "중복된 예약이 있습니다.");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }
            
            // 안 겹칠 시 예약 완료
            reservation.setEquipNo(reservation.getEquipNo()); // equipNo = roomNo 할당
            meetRoomReservService.addMeetRoomCal(reservation);
            response.put("success", true);
            response.put("message", "controller 예약 성공");
            return new ResponseEntity<>(response, HttpStatus.OK);
            
        } catch (Exception e) { //또 다른 예외 메세지
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "controller 예약 실패");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // 회의실 캘린더 내 중복 예약 확인 메서드 (new ---)
    private boolean isOverLapping(Reservation newReservation) {
        // 새로운 예약의 시작 시간과 종료 시간
        LocalDateTime newStartTime = newReservation.getRevStartTime();
        LocalDateTime newEndTime = newReservation.getRevEndTime();
        
        log.debug(AN+"newStartTime:"+newStartTime+RE);
        log.debug(AN+"newEndTime:"+newEndTime+RE);
        
        
        // 해당 roomNo 기존 예약 정보 조회
        List<Reservation> existingReservations = meetRoomReservService.getMeetRoomReservCal(newReservation.getEquipNo());
        
        for (Reservation existingReservation : existingReservations) {
            LocalDateTime existingStartTime = existingReservation.getRevStartTime();
            LocalDateTime existingEndTime = existingReservation.getRevEndTime();
            
            // 시간대가 겹치면 중복으로 처리(true)
            if (newStartTime.isBefore(existingEndTime) && newEndTime.isAfter(existingStartTime)) {
                return true;
            }
        }
        
        return false;
    }
    
    
    
    // (emp) 예약한 회의실 조회(예약 취소 가능)
    @GetMapping("/reservation/empMeetRoomReservedList")
	public String empMeetReserved(HttpSession session, Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
    	
    	AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
 		int empNo = loginAccount.getEmpNo();
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
		paramMap.put("empNo", empNo);
			
		List<Reservation> empMeetReserved = meetRoomReservService.getReservations(paramMap);
		model.addAttribute("empMeetReserved", empMeetReserved); //view ${}
		
		log.debug(AN+"empMeetReserved.empMeetReserved : "+empMeetReserved.toString()+RE);
		return "/reservation/empMeetRoomReservedList";
	}
    
    // (emp&admin) 예약 취소 메서드 A0301 예약완료 A0302 예약취소 A0303 사용완료
    @PostMapping("/cancelReserved")
    @ResponseBody
    public String cancelReserved(HttpSession session, @RequestBody Reservation reservation) {
        try {
            AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
            int empNo = loginAccount.getEmpNo();
            String empName = (String)session.getAttribute("empName");
            log.debug(AN+"경영지원 예약 관리페이지 접속자 이름: "+empName+RE);
            
            // 사용자 확인(부서기준)
            String userDept = (String)session.getAttribute("dept");
            log.debug(AN+"경영지원 예약 관리페이지 접속자 사번, 부서: "+empNo+userDept.toString()+RE);
            
            boolean isAdmin = "D0202".equals(userDept); // 경영지원팀

            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("equipCategory", "E0101");
            paramMap.put("empNo",empNo);
            
            int revCancel = reservation.getRevNo();
            List<Reservation> allMeetReserved = meetRoomReservService.getAllReservations(paramMap); //예약건 모두 조회

            Reservation Reserved = allMeetReserved.stream()
                    .filter(r -> r.getRevNo() == revCancel) //revNo만을 가져오는 메서드가 없어서 모든예약조회 메서드에서 Reserved로 따로 필터링
                    .findFirst()
                    .orElse(null);

            if (Reserved != null && Reserved.getRevStatus().equals("A0301")) {
                // 사용자의 역할에 따라 분기하여 처리합니다.
                if (isAdmin) {
                    // 경영지원팀인 경우 모든 예약 건을 취소할 수 있도록 처리
                    Reserved.setRevStatus("A0302");
                    Reserved.setUpdateId(empNo);
                    Reserved.setUpdateName(empName);
                } else if (Reserved.getEmpNo() == empNo) {
                    // 다른 사용자의 경우 자신의 예약 건만 취소 가능하도록 처리
                    Reserved.setRevStatus("A0302");
                    Reserved.setUpdateId(empNo);
                    Reserved.setUpdateName(empName);
                } else {
                    return "다른 사용자의 예약은 취소할 수 없습니다"; // 페이지 분기가 되어있지만 서버측에서 한 번 더 막음
                }
                
                int result = meetRoomReservService.modifyMeetRoomCal(Reserved);

                if (result > 0) {
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

    // 경영지원팀의 모든 예약 조회
    @GetMapping("/reservation/adminMeetRoomReservList")
	public String empAllMeetReserved(HttpSession session, Model model, 
			@RequestParam(name="equip_category", defaultValue = "E0101") String equipCategory){
 
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("equipCategory", equipCategory);
			
		List<Reservation> empAllMeetReserved = meetRoomReservService.getAllReservations(paramMap);
		model.addAttribute("empAllMeetReserved", empAllMeetReserved);
		
		log.debug(AN+"reservController 경영지원팀 list : "+empAllMeetReserved.toString()+RE);
		
		return "/reservation/adminMeetRoomReservList";
	}
    
    // 경영지원팀 회의실 예약 관리 검색 메서드
    @GetMapping("/reservation/search") //ajax url
    @ResponseBody
    public ResponseEntity<List<Reservation>> searchReservation(
    		@RequestParam(name = "empName", required = false) String empName,
            @RequestParam(name = "revStatus", required = false) String revStatus,
            @RequestParam(name = "revStartTime", required = false) String revStartTime,
            @RequestParam(name = "revEndTime", required = false) String revEndTime) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("empName", empName);
        paramMap.put("revStatus", revStatus);
        paramMap.put("revStartTime", revStartTime);
        paramMap.put("revEndTime", revEndTime);
        log.debug(AN+"reservController 경영지원팀 예약 : "+paramMap.toString()+RE);
        List<Reservation> searchResult = meetRoomReservService.searchReservation(paramMap);

        // JSON 형식으로 데이터 반환
        return new ResponseEntity<>(searchResult, HttpStatus.OK);
    }
    
    
    // 사원 회의실 예약 일자 관리 검색 메서드
    @GetMapping("/reservation/empSearch")
    @ResponseBody
    public ResponseEntity<List<Reservation>> searchEmpReservation(
    		@RequestParam(name = "empNo") int empNo,
            @RequestParam(name = "revStartTime", required = false) String revStartTime,
            @RequestParam(name = "revEndTime", required = false) String revEndTime) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("revStartTime", revStartTime);
        paramMap.put("revEndTime", revEndTime);
        paramMap.put("empNo", empNo);
        List<Reservation> searchEmpResult = meetRoomReservService.searchEmpReservation(paramMap);
        log.debug(AN+"reservController 사원 예약일자 : "+searchEmpResult+RE);

        // JSON 형식으로 데이터 반환
        return new ResponseEntity<>(searchEmpResult, HttpStatus.OK);
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
            	LocalDateTime endTime = reservation.getRevEndTime(); // 이미 LocalDateTime 객체를 반환
                LocalDateTime currentDateTime = currentTime;

                if (endTime.isBefore(currentDateTime)) { // 현재 시간이 종료시간 이후면
                    if (reservation.getRevStatus().equals("A0301")) {
                        reservation.setRevStatus("A0303"); // 사용완료 상태로 변경
                        meetRoomReservService.modifyMeetRoomCal(reservation);
                    }
                }
            }
        }
    }*/
}
