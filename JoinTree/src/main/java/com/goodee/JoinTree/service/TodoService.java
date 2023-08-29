package com.goodee.JoinTree.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.TodoMapper;
import com.goodee.JoinTree.vo.Todo;

@Service
public class TodoService {
	@Autowired
	private TodoMapper todoMapper;
	
	// todo 출력
	public List<Todo> selectTodo(int empNo){
		List<Todo> todoList = todoMapper.selectTodo(empNo);
		return todoList;
	}
	
	// todo 추가
	public int addTodo(Todo todo) {
		return todoMapper.addTodo(todo);
	}
	
	// todo 상태 업데이트
	public int updateTodoStatus(int todoNo, String todoStatus) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("todoNo", todoNo);
	    paramMap.put("todoStatus", todoStatus);
	    return todoMapper.updateTodoStatus(paramMap);
	}
		
	// todo 삭제
	public int removeTodo(int todoNo) {
		return todoMapper.removeTodo(todoNo);
	}

}
