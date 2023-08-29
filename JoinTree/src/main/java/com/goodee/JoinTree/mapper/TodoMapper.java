package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Todo;

@Mapper
public interface TodoMapper {

	// todo 출력
	List<Todo> selectTodo(int empNo);
	
	// todo 추가
	int addTodo(Todo todo);
	
	// todo 상태 업데이트
	int updateTodoStatus(Map<String, Object> paramMap);
	
	// todo 삭제
	int removeTodo(int todoNo);
	
}
