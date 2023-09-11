package com.goodee.JoinTree.controller;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.TodoService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Todo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TodoController {

	@Autowired
	private TodoService todoService;
	
	// todo 출력
	@GetMapping("/todo/todoList")
	@ResponseBody
	public List<Todo> getTodos(HttpSession session) {
		
		// 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		
		List<Todo> todoList = todoService.selectTodo(empNo);
		
		log.debug(todoList.toString());
		
		return todoList;
	}
	
	// todo 추가
	@PostMapping("/todo/addTodo")
	@ResponseBody
	public String addTodo(@RequestBody Todo newTodo, HttpSession session) {
		
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
	    int empNo = loginAccount.getEmpNo();

	    newTodo.setEmpNo(empNo);

	    int add = todoService.addTodo(newTodo);
	    
	    if (add > 0) {
	        return "success";
	    } else {
	        return "failure";
	    }
	}
	
	// todo 상태 업데이트
	@PostMapping("/todo/updateTodoStatus")
    public String updateTodoStatus(@RequestBody Map<String, Object> paramMap) {
        int todoNo = (int) paramMap.get("todoNo");
        boolean isChecked = (boolean) paramMap.get("isChecked");
        String todoStatus = isChecked ? "1" : "0";
        int update = todoService.updateTodoStatus(todoNo, todoStatus);
        
        if (update > 0) {
	        return "redirect:/home";
	    } else {
	        return "failure";
	    }
    }
	
	// todo 삭제
	@PostMapping("/todo/removeTodo")
	public String removeTodo(@RequestBody Map<String, Integer> requestBody) {
	    int todoNo = requestBody.get("todoNo");
	    int delete = todoService.removeTodo(todoNo);
	    
	    if (delete > 0) {
	        return "success";
	    } else {
	        return "failure";
	    }
	}
	    
}
