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
	
	// todo 출력페이지
	@GetMapping("/todo/todoList")
	@ResponseBody
	public List<Todo> getTodos(HttpSession session, Model model) {
		
		// 세션에서 empNo 추출
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		int empNo = loginAccount.getEmpNo();
		
		List<Todo> todoList = todoService.selectTodo(empNo);
		
		model.addAttribute("todoList", todoList);
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
	        return "Todo added successfully.";
	    } else {
	        return "Failed to add todo.";
	    }
	}
	
	// todo 상태 업데이트
	@PostMapping("/todo/updateTodoStatus")
    public void updateTodoStatus(@RequestBody Map<String, Object> paramMap) {
        int todoNo = (int) paramMap.get("todoId");
        boolean isChecked = (boolean) paramMap.get("isChecked");
        String todoStatus = isChecked ? "Y" : "N";
        todoService.updateTodoStatus(todoNo, todoStatus);
    }
	    
}
