package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.CodeService;
import com.goodee.JoinTree.service.LoginService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
//@SessionAttributes(names = "") // 모델 생명 주기 -> 세션
public class LoginController {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	String msg = "";
	@Autowired 
	private LoginService loginService;
	@Autowired 
	private CodeService codeService;
	
	// 로그인 페이지로 이동
	@GetMapping("/login/login")
	public String login(HttpServletRequest request) {
		// loginId(쿠키)가 있는지 확인하여 그 값을 request 속성에 저장
		Cookie[] cookies = request.getCookies();
		
		if (cookies != null) {
			for (Cookie c : cookies) {
				if (c.getName().equals("loginId") == true) {
					request.setAttribute("loginId", c.getValue());
				}
			}
		}
		
		return "/login/login";
	}
	
	// 로그인 액션
	@PostMapping("/login/login")

	public String login(HttpSession session, HttpServletRequest request,
				  HttpServletResponse response,
				  @RequestParam(name="empNo") int empNo,
				  @RequestParam(name="empPw") String empPw,
				  @RequestParam(name="saveId", required = false) String saveId // required = false: 요청값이 넘어오지 않아도 오류 발생 X
			) throws UnsupportedEncodingException {
		// sevice(empNo, empPw) -> mapper -> 로그인 성공 유무 반환
		
		AccountList account = new AccountList();
		account.setEmpNo(empNo);
		account.setEmpPw(empPw);
		
		AccountList loginAccount = loginService.login(account);
        
		// 로그인 성공 시 
		if (loginAccount != null) {
			String empName = loginService.getEmpName(empNo);
			String dept = loginService.getEmpDept(empNo);
			String empImg = loginService.getEmpImg(empNo);
			String signImg = loginService.getSignImg(empNo);

			// 사이드바 내용을 위해 리스트도 함께 추가
			String upCode = null;
			List<CommonCode> childCodeList = codeService.selectChildCode(upCode);
			
			log.debug(CYAN + empName + " <-- empName(LoginController)"+ RESET); // 디버그 로그
			log.debug(CYAN + dept + " <-- dept(LoginController)"+ RESET);
			log.debug(CYAN + empImg + " <-- empImg(LoginController)"+ RESET);
			log.debug(CYAN + signImg + " <-- signImg(LoginController)"+ RESET);
			
			session.setAttribute("childCodeList", childCodeList);
			session.setAttribute("loginAccount", loginAccount);
			session.setAttribute("empName", empName);
			session.setAttribute("dept", dept);
			session.setAttribute("empImg", empImg);
			session.setAttribute("signImg", signImg);
			
	        // 세션의 만료 시간 설정 (30분)
	        int sessionTimeout = 30 * 60; // 30분 (초 단위)
	        session.setMaxInactiveInterval(sessionTimeout);
			
			// saveId 체크박스가 선택되었을 경우, 사용자 아이디를 쿠키에 저장
			// saveId != null && saveId.equals("y")
			if (saveId != null) {
				log.debug(CYAN + "아이디 저장" + RESET); // 디버그 로그
				Cookie loginIdCookie = new Cookie("loginId", String.valueOf(empNo));
				loginIdCookie.setMaxAge(60 * 60 * 24 * 30); // 초단위 // 60 * 60 * 24 * 30 -> 30일  
				response.addCookie(loginIdCookie);
			} else {
				// saveId가 null이거나 "y"가 아니라면 쿠키 삭제
			    Cookie loginIdCookie = new Cookie("loginId", "");
			    loginIdCookie.setMaxAge(0); // 즉시 삭제
			    response.addCookie(loginIdCookie);
			}
			
			// 최초 로그인 시 비밀번호 변경 여부 확인
			if (empPw.equals("1234")) {
				msg = URLEncoder.encode(empName + "님, 환영합니다. 비밀번호 변경 후 이용 가능합니다.", "UTF-8");
				
				return "redirect:/empInfo/modifyPw?msg=" + msg; // 비밀번호 변경 페이지로 이동
			} 
			
			// 로그인 성공 시 메시지를 URL 매개변수로 전달
			msg = URLEncoder.encode(empName + "님, 환영합니다.", "UTF-8");
				return "redirect:/home?msg=" + msg; // 사용자가 로그인 페이지의 URL을 유지하지 않도록 리다이렉트
				
		} else {
			msg = URLEncoder.encode("아이디 또는 비밀번호를 확인해주세요.", "UTF-8");
			return "redirect:/login/login?msg="+ msg; // 로그인 실패 시 로그인 페이지로 이동
		}
	}

	@GetMapping("/logout")
	public String logout (HttpSession session) throws UnsupportedEncodingException {
		String msg = URLEncoder.encode("로그아웃 되었습니다.", "UTF-8");
		
		String msgParam = (String) session.getAttribute("msgParam");
		
		if (msgParam != null && !msgParam.isEmpty()) {
			msg = msgParam;
		}
		
		session.invalidate();
		
		return "redirect:/login/login?msg=" + msg; // login.jsp로 이동
	}
	
	// 비밀번호 분실 - 재설정 페이지로 이동
	@GetMapping("/login/resetPw")
	public String resetPw() {
		
		return "login/resetPw";
	}
	
	// 사번, 주민번호 체크
	@PostMapping("/login/resetPw")
	@ResponseBody // 메소드 반환값을 HTTP응답 본문으로 사용
	public String checkEmpNoJumin(@RequestParam("empNo") int empNo, @RequestParam("juminNo") String juminNo) throws UnsupportedEncodingException { 
		int row = loginService.selectEmpNoJumin(empNo, juminNo);
		log.debug(CYAN + row + " <-- row(LoginController-resetPw)" + RESET);
		
		if (row == 1) { // 사번, 주민번호 일치
			return "success";
		} else {
			return "fail";
		}
	}
	
	// 사번, 주민번호 체크 후 비밀번호 변경
    @PostMapping("/login/resetPw/reset")
    public String resetPassword(@RequestParam("empNo") int empNo, @RequestParam("newPw") String newPw) throws UnsupportedEncodingException {
    	int row = loginService.modifyForgetPw(empNo, newPw);
    	log.debug(CYAN + row + " <-- row(LoginController-modifyForgetPw)" + RESET);
    	
    	if (row == 1) {
    		msg = URLEncoder.encode("비밀번호가 변경되었습니다. 다시 로그인 후 이용 가능합니다.", "UTF-8");
    		return "redirect:/login/login?msg=" + msg;
    		
    	} else {
    		msg = URLEncoder.encode("비밀번호 변경 실패. 관리자에게 문의해주세요.", "UTF-8");
    		return "redirect:/login/resetPw?msg=" + msg;
    	}
    }
    
	@PostMapping("/extendSession")
	@ResponseBody // 메소드 반환값을 HTTP응답 본문으로 사용
	public String extendSession(HttpSession session) {
	    try {
	    	// 현재 세션의 만료 시간을 가져와 연장할 만큼 추가
		    int currentMaxInactiveInterval = session.getMaxInactiveInterval();
		    int extendedMaxInactiveInterval = currentMaxInactiveInterval + 1800; // 30분 (초 단위)
		    session.setMaxInactiveInterval(extendedMaxInactiveInterval);
		    log.debug(CYAN + "세션 연장 성공(LoginController)" + RESET);
		    
		    return "success";
	    } catch (Exception e) {
	    	log.debug(CYAN + "세션 연장 실패(LoginController)" + RESET);
	    	
	        return "fail"; // 실패 시 오류 메시지 반환
	    }
	}
}