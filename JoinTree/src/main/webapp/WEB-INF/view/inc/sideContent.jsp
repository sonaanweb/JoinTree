<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
	<!-- 왼쪽바 -->
	<nav class="sidebar sidebar-offcanvas" id="sidebar">
	<ul class="nav">
		<!-- 왼쪽 - 프로필 -->
		<li class="nav-item nav-profile">
			<a href="/empInfo/empInfo" class="nav-link">
				<div class="nav-profile-image">
					<img src="/JoinTree/empImg/tiger.png" alt="profile">
					<span class="login-status online"></span>
				</div>
				<div class="nav-profile-text d-flex flex-column">
					<span class="font-weight-bold mb-2">${empInfo.empName}</span>
					<span class="text-secondary text-small">${empInfo.dept}</span>
				</div>
				<i class="mdi mdi-bookmark-check text-success nav-profile-badge"></i>
			</a>
		</li>

		<!-- 왼쪽 - 홈 -->
		<li class="nav-item">
			<a class="nav-link" href="/JoinTree/home">
				<span class="menu-title">홈</span>
				<i class="mdi mdi-home menu-icon"></i>
			</a>
		</li>

		 <!-- 왼쪽 - 공지 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#notice" aria-expanded="false" aria-controls="general-pages">
				<span class="menu-title">공지</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-bullhorn menu-icon"></i>
			</a>
			<div class="collapse" id="notice">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href=""> 공지사항 </a></li>
					<li class="nav-item"> <a class="nav-link" href=""> 자료실 </a></li>
				</ul>
			</div>
		</li>

		<!-- 왼쪽 - 게시판 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#board" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">게시판</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-format-list-bulleted menu-icon"></i>
			</a>
			<div class="collapse" id="board">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/community/freeCommList">자유게시판</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/community/anonymousCommList">익명게시판</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/community/secondhandCommList">중고장터게시판</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/community/lifeEventCommList">경조사게시판</a></li>
				</ul>
			</div>
		</li>

		<!-- 왼쪽 - 프로젝트 -->
		<li class="nav-item">
			<a class="nav-link" href="/JoinTree/project/projectList">
				<span class="menu-title">프로젝트</span>
				<i class="mdi mdi-newspaper menu-icon"></i>
			</a>
		</li>

		<!-- 왼쪽 - 일정 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#calendarBar" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">일정</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-calendar-check menu-icon"></i>
			</a>
			<div class="collapse" id="calendarBar">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/schedule/companySchedule">전사일정</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/schedule/departmentSchedule">부서일정</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/schedule/personalSchedule">개인일정</a></li>
				</ul>
			</div>
		</li>

		<!-- 왼쪽 - 근태 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#commute" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">근태</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-clock-fast menu-icon"></i>
			</a>
			<div class="collapse" id="commute">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">일별 출퇴근 리스트</a></li>
					<li class="nav-item"> <a class="nav-link" href="">근로시간 통계</a></li>
				</ul>
			</div>
		</li>
    
		<!-- 왼쪽 - 전자결재 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#document" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">전자결재</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-clipboard-text menu-icon"></i>
			</a>
		 	<div class="collapse" id="document">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/document/document">결재하기</a></li>
					<li class="nav-item"> <a class="nav-link" href="">기안문서목록</a></li>
					<li class="nav-item"> <a class="nav-link" href="">결재함</a></li>
					<li class="nav-item"> <a class="nav-link" href="">개인문서함</a></li>
					<li class="nav-item"> <a class="nav-link" href="">팀별문서함</a></li>
				</ul>
			</div>
		</li>
   
		<!-- 왼쪽 - 주소록 -->
		<li class="nav-item">
			<a class="nav-link" href="">
				<span class="menu-title">주소록</span>
				<i class="mdi mdi-account-search menu-icon"></i>
			</a>
		</li>
		
		<%-- <c:if test="${loginMember == }></c:if> --%>
		
		<!-- 왼쪽 - 개발팀(공통코리 관리) -->
		<div class="line"></div>
		<li class="nav-item">
			<a class="nav-link" href="/JoinTree/code/codeList">
				<span class="menu-title">공통코드관리</span>
				<i class="mdi mdi mdi-server menu-icon"></i>
			</a>
		</li>
		
		<!-- 왼쪽 - 인사팀(인사관리) -->
		<div class="line"></div>
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#emp" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">인사관리</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi mdi-account-settings-variant menu-icon"></i>
			</a>
			<div class="collapse" id="emp">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/empManage/selectEmpList">사원관리</a></li>
					<li class="nav-item"> <a class="nav-link" href="">출퇴근관리</a></li>
					<li class="nav-item"> <a class="nav-link" href="">연가관리</a></li>
					<li class="nav-item"> <a class="nav-link" href="">연차관리</a></li>
				</ul>
			</div>
		</li>
		
		<!-- 왼쪽 - 경영개발팀 -->
		<div class="line"></div>
		<!-- 왼쪽 - 예약관리 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#reservation" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">예약관리</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi mdi-calendar-clock menu-icon"></i>
			</a>
			<div class="collapse" id="reservation">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">회의실</a></li>
					<li class="nav-item"> <a class="nav-link" href="">법인차량</a></li>
				</ul>
			</div>
		</li>
		<!-- 왼쪽 - 기자재관리 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#equipment" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">기자재관리</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi mdi-car menu-icon"></i>
			</a>
			<div class="collapse" id="equipment">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">회의실</a></li>
					<li class="nav-item"> <a class="nav-link" href="">법인차량</a></li>
				</ul>
			</div>
		</li>
	</ul>
	</nav><!-- 왼쪽바 끝 -->
	
	<!-- 사이드에 추가할 부분이 있으면 여기 아래로 작성해주세요 -->
	
</html>