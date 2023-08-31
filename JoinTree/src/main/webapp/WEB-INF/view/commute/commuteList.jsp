<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<style>
    .saturday {
        background-color: lightblue;
    }
    
    .sunday {
        background-color: lightpink;
    }
</style>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<div>
				<h1>${targetYear}년 ${targetMonth+1}월</h1>
			</div>
			
			<!-- 월 이동 버튼 -->
			<div>
				<a href="${pageContext.request.contextPath}/commute/commuteList?targetYear=${targetYear}&targetMonth=${targetMonth-1}">이전달</a>
				<a href="${pageContext.request.contextPath}/commute/commuteList?targetYear=${targetYear}&targetMonth=${targetMonth+1}">다음달</a>
			</div>
			
			<!-- 월별 출퇴근 리스트 출력 -->
			<div>
				<table class="table table-sm">
					<tr>
						<th style="width:100px">날짜</th>
						<th style="width:80px">요일</th>
						<th>출근시간</th>
						<th>퇴근시간</th>
					</tr>
					
					<!-- 월이 1의 자리이면 앞자리에 0 붙여서 저장-->
					<c:choose>
					    <c:when test="${targetMonth+1 < 10}">
					        <c:set var="formattedMonth" value='0${targetMonth+1}' />
					    </c:when>
					    <c:otherwise>
					        <c:set var="formattedMonth" value='${targetMonth+1}' />
					    </c:otherwise>
					</c:choose>
					
					<c:forEach begin="1" end="${daysInMonth}" varStatus="loop">
					    <!-- 출퇴근 시간 값 확인 -->
						<c:set var="commuteDateFound" value="false"/>
					    
					    <!-- 일이 1의 자리이면 앞자리에 0 붙여서 저장-->
					    <c:set var="day" value="${loop.index}" />
						<c:choose>
						    <c:when test="${day < 10}">
						        <c:set var="formattedDay" value='0${day}' />
						    </c:when>
						    <c:otherwise>
						        <c:set var="formattedDay" value='${day}' />
						    </c:otherwise>
						</c:choose>
						
						<c:set var="currentDate" value="${targetYear}-${formattedMonth}-${formattedDay}" />
					    
					    <tr class="${(loop.index + firstDayOfWeek -2) % 7 == 0 ? 'sunday' : ((loop.index + firstDayOfWeek -2) % 7 == 6 ? 'saturday' : '')}">
					        <td>${targetMonth+1}월 ${loop.index}일</td>
					        <td>${daysOfWeek[(loop.index + firstDayOfWeek - 2) % 7]}</td>
					        
					        <c:forEach var="commute" items="${commuteTimeList}">
					            <c:if test="${commute.empOnOffDate == currentDate}">
					                <c:set var="commuteDateFound" value="true"/>
					                <td>${commute.empOnTime}</td>
					                <td>${commute.empOffTime}</td>
					            </c:if>
					        </c:forEach>
					        
					        <!-- 해당 일자의 데이터가 없을 경우 -->
					        <c:choose>
							    <c:when test="${empty commuteTimeList or (not commuteDateFound and not fn:contains(commute.empOnOffDate, currentDate))}">
							        <td>&#45;</td>
							        <td>&#45;</td>
							    </c:when>
							</c:choose>
					    </tr>
					</c:forEach>
				</table>
			</div>
			
		</div>
	</div>	
</html>