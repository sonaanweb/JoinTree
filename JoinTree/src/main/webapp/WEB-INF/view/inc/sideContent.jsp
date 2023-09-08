<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<script>
	$(document).ready(function() {
		function updateElectronicApprovalMenu() {
		$.ajax({
			url: '/JoinTree/sideContectWithDoc',
			type: 'GET',
			success: function(data) {
				console.log("data",data);
				$('#draftCnt').text(data.daftDocCnt);
				$('#approvalCnt').text(data.approvalDocCnt);
				if(data.daftDocCnt > 0 || data.approvalDocCnt) {
					$('#doc').addClass("doc-cnt");
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				console.error('오류 발생:', textStatus, errorThrown);
			}
			});
		}
		
		// 페이지 로드 후 초기 업데이트 실행
		updateElectronicApprovalMenu();
	});
</script>
	<!-- 왼쪽바 -->
	<nav class="sidebar sidebar-offcanvas" id="sidebar">
	<ul class="nav">
		<!-- 왼쪽 - 프로필 -->
		<li class="nav-item nav-profile">
			<a href="/JoinTree/empInfo/empInfo" class="nav-link">
				<div class="nav-profile-image">
					<c:choose>
						<c:when test="${empty empImg or empImg eq null}">
							<img src="${pageContext.request.contextPath}/empImg/JoinTree.png" alt="profile">
						</c:when>
						<c:otherwise>
							<img src="${pageContext.request.contextPath}/empImg/${empImg}">
						</c:otherwise>
					</c:choose>
					<span class="login-status online"></span>
				</div>
				<div class="nav-profile-text d-flex flex-column">
					<span class="font-weight-bold mb-2">${empName}</span>
					<c:forEach var="child" items="${sessionScope.childCodeList}">
						<c:if test="${child.code == dept && child.status == '1'}">
					
							<span class="text-secondary text-small">${child.codeName}</span>
						</c:if>
					</c:forEach>
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
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0101' && child.status == '1'}">
					<a class="nav-link" data-toggle="collapse" href="#notice" aria-expanded="false" aria-controls="general-pages">
						<span class="menu-title">공지</span>
						<i class="menu-arrow"></i>
						<i class="mdi mdi-bullhorn menu-icon"></i>
					</a>
				</c:if>
			</c:forEach>
			<div class="collapse" id="notice">
				<ul class="nav flex-column sub-menu">
					<c:forEach var="child" items="${sessionScope.childCodeList}">
						<c:if test="${child.upCode == 'B01' && child.status == '1'}">
							<c:choose>
								<c:when test="${child.codeName == '공지사항'}">
									<li class="nav-item"><a class="nav-link" href="/JoinTree/board/noticeList">공지사항</a></li>
								</c:when>
								<c:when test="${child.codeName == '자료실'}">
									<li class="nav-item"><a class="nav-link" href="/JoinTree/board/libraryList">자료실</a></li>
								</c:when>
							</c:choose>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</li>
		
		<!-- 왼쪽 - 게시판 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#board" aria-expanded="false" aria-controls="ui-basic">
				<c:forEach var="child" items="${sessionScope.childCodeList}">
					<c:if test="${child.code == 'M0102' && child.status == '1'}">
						<span class="menu-title">게시판</span>
						<i class="menu-arrow"></i>
						<i class="mdi mdi-format-list-bulleted menu-icon"></i>
					</c:if>
				</c:forEach>
			</a>
			<div class="collapse" id="board">
				<ul class="nav flex-column sub-menu">
					<c:forEach var="child" items="${sessionScope.childCodeList}">
						<c:if test="${child.upCode == 'B01' && child.status == '1'}">
							<c:choose>
								<c:when test="${child.codeName == '자유게시판'}">
									<li class="nav-item"><a class="nav-link" href="/JoinTree/community/freeCommList">자유게시판</a></li>
								</c:when>
								<c:when test="${child.codeName == '익명게시판'}">
									<li class="nav-item"><a class="nav-link" href="/JoinTree/community/anonymousCommList">익명게시판</a></li>
								</c:when>
								<c:when test="${child.codeName == '중고장터게시판'}">
									<li class="nav-item"><a class="nav-link" href="/JoinTree/community/secondhandCommList">중고장터게시판</a></li>
								</c:when>
								<c:when test="${child.codeName == '경조사게시판'}">
									<li class="nav-item"><a class="nav-link" href="/JoinTree/community/lifeEventCommList">경조사게시판</a></li>
								</c:when>
							</c:choose>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</li>
				
		<!-- 왼쪽 - 프로젝트 -->
		<li class="nav-item">
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0103' && child.status == '1'}">
					<a class="nav-link" href="/JoinTree/project/projectList">
						<span class="menu-title">프로젝트</span>
						<i class="mdi mdi-newspaper menu-icon"></i>
					</a>
				</c:if>
			</c:forEach>
		</li>
	
		<!-- 왼쪽 - 일정 -->
		<li class="nav-item">
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0104' && child.status == '1'}">
					<a class="nav-link" data-toggle="collapse" href="#calendarBar" aria-expanded="false" aria-controls="ui-basic">
						<span class="menu-title">일정</span>
						<i class="menu-arrow"></i>
						<i class="mdi mdi-calendar-check menu-icon"></i>
					</a>
				</c:if>
			</c:forEach>	
			<div class="collapse" id="calendarBar">
				<ul class="nav flex-column sub-menu">
					<c:forEach var="child" items="${sessionScope.childCodeList}">
						<c:if test="${child.upCode == 'S01' && child.status == '1'}">
							<c:choose>
								<c:when test="${child.codeName == '전사일정'}">
									<li class="nav-item"> <a class="nav-link" href="/JoinTree/schedule/companySchedule">전사일정</a></li>									
								</c:when>
								<c:when test="${child.codeName == '부서일정'}">
									<li class="nav-item"> <a class="nav-link" href="/JoinTree/schedule/departmentSchedule">부서일정</a></li>	
								</c:when>
								<c:when test="${child.codeName == '개인일정'}">
									<li class="nav-item"> <a class="nav-link" href="/JoinTree/schedule/personalSchedule">개인일정</a></li>									
								</c:when>	
							</c:choose>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</li>
		
		<!-- 왼쪽 - 예약 -->
		<li class="nav-item">
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0112' && child.status == '1'}">
				<a class="nav-link" data-toggle="collapse" href="#reservation" aria-expanded="false" aria-controls="ui-basic">
					<span class="menu-title">회의실예약</span>
					<i class="menu-arrow"></i>
					<i class="mdi mdi mdi-calendar-clock menu-icon"></i>
				</a>
				</c:if>
			</c:forEach>
			<div class="collapse" id="reservation">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/reservation/empMeetRoomList">회의실 예약</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/reservation/empMeetRoomReservedList">예약 조회</a></li>																		
				</ul>
			</div>
		</li>

		<!-- 왼쪽 - 근태 -->
		<li class="nav-item">
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0105' && child.status == '1'}">
				<a class="nav-link" data-toggle="collapse" href="#commute" aria-expanded="false" aria-controls="ui-basic">
					<span class="menu-title">근태</span>
					<i class="menu-arrow"></i>
					<i class="mdi mdi-clock-fast menu-icon"></i>
				</a>
				</c:if>
			</c:forEach>
			<div class="collapse" id="commute">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/commute/commuteList">출근부</a></li>									
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/commute/commuteChart">근로시간 통계</a></li>									
				</ul>
			</div>
		</li>
    
		<!-- 왼쪽 - 전자결재 -->
		<li class="nav-item">
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0106' && child.status == '1'}">
						<a class="nav-link" data-toggle="collapse" href="#document" aria-expanded="false" aria-controls="ui-basic">
							<span class="menu-title">전자결재<span id="doc"></span></span>
							<i class="menu-arrow"></i>
							<i class="mdi mdi-clipboard-text menu-icon"></i>
						</a>
				</c:if>
			</c:forEach>
		 	<div class="collapse" id="document">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/document/documentDraft">기안하기</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/document/draftDocList">기안문서목록(<span id="draftCnt"></span>)</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/document/approvalDocList">결재함(<span id="approvalCnt"></span>)</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/document/individualDocList">개인문서함</a></li>
					<li class="nav-item"> <a class="nav-link" href="/JoinTree/document/teamDocList">팀별문서함</a></li>
				</ul>
			</div>
		</li>
   
		<!-- 왼쪽 - 주소록 -->
		<li class="nav-item">
			<c:forEach var="child" items="${sessionScope.childCodeList}">
				<c:if test="${child.code == 'M0107' && child.status == '1'}">
					<a class="nav-link" href="/JoinTree/empTel/empTelList">
						<span class="menu-title">주소록</span>
						<i class="mdi mdi-account-search menu-icon"></i>
					</a>
				</c:if>
			</c:forEach>	
		</li>
		
		<c:if test="${dept == 'D0203' || loginAccount.empNo == '11111111'}">
			<!-- 왼쪽 - 개발팀(공통코리 관리) -->
			<div class="line"></div>
			<li class="nav-item">
				<c:forEach var="child" items="${sessionScope.childCodeList}">
					<c:if test="${child.code == 'M0108' && child.status == '1'}">
						<a class="nav-link" href="/JoinTree/code/codeList">
							<span class="menu-title">공통코드관리</span>
							<i class="mdi mdi mdi-server menu-icon"></i>
						</a>
					</c:if>
				</c:forEach>	
			</li>
		</c:if>
		
		<!-- 왼쪽 - 인사팀(인사관리) -->
		<c:if test="${dept == 'D0201' || loginAccount.empNo == '11111111'}">
			<div class="line"></div>
			<li class="nav-item">
				<c:forEach var="child" items="${sessionScope.childCodeList}">
					<c:if test="${child.code == 'M0109' && child.status == '1'}">
						<a class="nav-link" data-toggle="collapse" href="#emp" aria-expanded="false" aria-controls="ui-basic">
							<span class="menu-title">인사관리</span>
							<i class="menu-arrow"></i>
							<i class="mdi mdi mdi-account-settings-variant menu-icon"></i>
						</a>
					</c:if>
				</c:forEach>		
				<div class="collapse" id="emp">
					<ul class="nav flex-column sub-menu">
						<li class="nav-item"> <a class="nav-link" href="/JoinTree/empManage/selectEmpList">사원관리</a></li>
						<li class="nav-item"> <a class="nav-link" href="/JoinTree/commuteManage/commuteFullList">출퇴근관리</a></li>
						<li class="nav-item"> <a class="nav-link" href="/JoinTree/commuteManage/leaveList">연가관리</a></li>
						<li class="nav-item"> <a class="nav-link" href="/JoinTree/commuteManage/annualLeaveList">연차관리</a></li>
					</ul>
				</div>
			</li>
		</c:if>
		
		<!-- 왼쪽 - 경영개발팀 -->
		<c:if test="${dept == 'D0202' || loginAccount.empNo == '11111111'}">
			<div class="line"></div>
			<!-- 왼쪽 - 예약관리 -->
			<li class="nav-item">
				<c:forEach var="child" items="${sessionScope.childCodeList}">
					<c:if test="${child.code == 'M0110' && child.status == '1'}">
						<a class="nav-link" data-toggle="collapse" href="#reservationAdmin" aria-expanded="false" aria-controls="ui-basic">
							<span class="menu-title">회의실관리</span>
							<i class="menu-arrow"></i>
							<i class="mdi mdi mdi-calendar-clock menu-icon"></i>
						</a>
					</c:if>
				</c:forEach>
				<div class="collapse" id="reservationAdmin">
					<ul class="nav flex-column sub-menu">
						<li class="nav-item"> <a class="nav-link" href="/JoinTree/reservation/adminMeetRoomReservList">예약 관리</a></li>
						<li class="nav-item"> <a class="nav-link" href="/JoinTree/equipment/meetRoomList">회의실 관리</a></li>
					</ul>
				</div>
			</li>
		</c:if>
	</ul>
	</nav><!-- 왼쪽바 끝 -->
	
	<!-- 사이드에 추가할 부분이 있으면 여기 아래로 작성해주세요 -->
	
</html>