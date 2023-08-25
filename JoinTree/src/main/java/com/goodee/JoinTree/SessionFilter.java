package com.goodee.JoinTree;

import java.io.IOException;
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

import lombok.extern.slf4j.Slf4j;

@Slf4j
@WebFilter("/*")
public class SessionFilter extends HttpFilter implements Filter {
   
	private static final long serialVersionUID = 1L;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // 세션 가져오기
        HttpSession session = httpRequest.getSession();
        log.debug("로그인 성공");
        System.out.println("로그인성공");

        if(session.getAttribute("loginAccount") == null || session.getAttribute("loginAccount").equals("")) {
        	httpResponse.sendRedirect(httpRequest.getContextPath() + "/login/login");
			return;
		}
		
		chain.doFilter(request, response);
	}
}