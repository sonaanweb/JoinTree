package com.goodee.JoinTree;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@WebFilter(urlPatterns = {"/home", "/board/*", "/community/*", "/code/*",  "/document/*", "/commute/*", "/commuteManage/*", 
		"/empInfo/*", "/empManage/*", "/empTel/*", "/equipment/*", "/schedule/*", "/reservation/*", "/project/*", "/todo/*"})
public class SessionFilter extends HttpFilter implements Filter {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
    // "/document/*", "", "
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
	  
        System.out.println("세션 확인 필터");
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI(); // requestURI 변수 할당
        
        // 세션 가져오기
        HttpSession session = httpRequest.getSession();
        Object loginAccount = session.getAttribute("loginAccount");

        String msg = "";
        if (!requestURI.endsWith("/login") && (loginAccount == null || loginAccount.equals(""))) {
            msg = URLEncoder.encode("로그인 후 이용 가능합니다.", "UTF-8");
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login/login?msg=" + msg);
            return;
        }

        httpRequest.setAttribute("loginAccount", loginAccount);

        log.debug(CYAN + "로그인 상태 -> empNo: " + ((AccountList) loginAccount).getEmpNo() + RESET);
        // System.out.println("로그인성공");

        chain.doFilter(request, response);
    }
}