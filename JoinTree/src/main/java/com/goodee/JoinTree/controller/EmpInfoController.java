package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.server.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.EmpInfoService;
import com.goodee.JoinTree.service.LoginService;
import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpInfoController {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	String msg = "";
	@Autowired 
	private EmpInfoService empInfoService;
	
	// 비밀번호 변경 페이지로 이동
	@GetMapping("/empInfo/modifyPw")
	public String modifyPw() {
	    return "/empInfo/modifyPw"; 
	}
	
	// 비밀번호 변경 액션
	@PostMapping("/empInfo/modifyPw")
	public String modifyPw(HttpSession session, @RequestParam("empPw") String empPw, 
			@RequestParam("newPw") String newPw) throws UnsupportedEncodingException {
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 비밀번호 변경 로직 호출
		AccountList account = new AccountList();
		account.setEmpNo(empNo);
		account.setEmpPw(empPw);
		account.setNewPw(newPw);
		account.setUpdateId(empNo);
		
		int row = empInfoService.modifyPw(account);
		log.debug(CYAN + row + " <-- row(EmpInfoController-modifyPw)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("비밀번호가 변경되었습니다. 다시 로그인 후 이용 가능합니다.", "UTF-8");
			session.setAttribute("pwChangeMessage", msg); // 메시지를 세션에 저장
			
			return "redirect:/logout?msg=" + msg;
		} else {
			msg = URLEncoder.encode("비밀번호 변경 실패. 현재 비밀번호를 확인해주세요.", "UTF-8");
			return "redirect:/empInfo/modifyPw?msg=" + msg;
		}
	}
	
	@GetMapping("/empInfo/empInfo")
	public String empInfo() {
	    return "/empInfo/empInfo"; // 나의 정보 페이지로 이동
	}
	
	@GetMapping("/empInfo/checkPw")
	public String checkPw() {
	    return "/empInfo/checkPw"; // 나의 정보 수정 전 비밀번호 체크 페이지
	}
	
	@PostMapping("/empInfo/checkPw")
	public String checkPw(HttpSession session, @RequestParam("empPw") String empPw) throws UnsupportedEncodingException {
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		int row = empInfoService.selectCheckPw(empNo, empPw);
		log.debug(CYAN + row + " <-- row(EmpInfoController-checkPw)" + RESET);
		
		if (row == 1) { // 비밀번호 일치
			return "/empInfo/modifyEmp";
		} else {
			msg = URLEncoder.encode("비밀번호가 일치하지 않습니다.", "UTF-8");
			return "redirect:/empInfo/checkPw?msg=" + msg;
		}
	}
	
	@GetMapping("/empInfo/modifyEmp")
	public String modifyEmp() {
	    return "/empInfo/checkPw"; // 나의 정보 수정 페이지로 이동
	}
	
	/*
	@PostMapping("/extendSession")
	@ResponseBody // 메소드 반환값을 HTTP응답 본문으로 사용
	public String extendSession(HttpSession httpSession) {
		// HttpSession에서 현재 세션 ID 가져오기
		String sessionId = httpSession.getId();
		
		// 세션 Repository를 통해 세션을 가져오기
		Session session = sessionRepository.findById(sessionId);
		
        if (session != null) {
            // 세션의 만료 시간을 연장하고 저장합니다. (예: 30분 추가)
            session.setMaxInactiveIntervalInSeconds(session.getMaxInactiveIntervalInSeconds() + 1800);
            sessionRepository.save(session);

            return "success";
        } else {
            return "failure";
        }
	}
	*/
}