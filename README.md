# 🖥️ JoinTree
문서 결재, 일정 관리, 사원 관리, 예약 및 예약관리, 프로젝트 관리와 같은 협업 및 개인 업무를 효율적으로 지원하는 그룹웨어 애플리케이션
<br>

### 기술 스택
<div align=left> 
  <img src="https://img.shields.io/badge/java 17-007396?style=for-the-badge&logo=java&logoColor=white"> 
  <img src="https://img.shields.io/badge/spring boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white"> 
  <img src="https://img.shields.io/badge/mybatis-ED8B00?style=for-the-badge&logo=mybatis&logoColor=white"> </div>

<div align=left> 
  <img src="https://img.shields.io/badge/html-E34F26?style=for-the-badge&logo=html5&logoColor=white"> 
  <img src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white"> 
  <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=white"> 
  <img src="https://img.shields.io/badge/jsp-007396?style=for-the-badge&logo=jsp&logoColor=white"> </div>

<div align=left>
  <img src="https://img.shields.io/badge/mariaDB-4479A1?style=for-the-badge&logo=mariaDB&logoColor=white"> 
  <img src="https://img.shields.io/badge/heidi sql-4479A1?style=for-the-badge&logo=heidisql&logoColor=white"> </div>

<div align=left> 
  <img src="https://img.shields.io/badge/spring tool suite4-6DB33F?style=for-the-badge&logo=spring&logoColor=white"> 
  <img src="https://img.shields.io/badge/git-000000?style=for-the-badge&logo=git&logoColor=white"> </div>
<div align=left>
  <img src="https://img.shields.io/badge/aws-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white">
</div>

### 프로젝트 기간 및 설계
**🗓️ 기간: 2023-07-24 ~ 2023-09-15** <br>
**🖱️ Website: [Jointree](http://3.37.94.201/JoinTree/login/login) [배포종료]**

### 프로젝트 세부 일정
<img src=https://github.com/user-attachments/assets/42cc741a-92a6-4ff4-a4c9-8943b0a1cbca>

### ERD
<img src=https://github.com/user-attachments/assets/69c56fe8-b58a-48a3-b62f-a4cd75da324e>


### 👩🏻‍💻 팀 구성

| 이름  | 담당                                    |
|-----|-----------------------------------------|
| 양희주 | 일정관리, Todo, 문서결재(기안) |
| 송예지 | 게시판, 인사 및 근태관리, 문서결재(문서함 리스트 및 상세출력)  |
| 신정음 | 메인 화면, 공통코드 관리, 문서결재(결재선, 기안)|
| 안소나 | 회의실 및 회의실 예약 관리, 문서결재(서명 및 결재) |
| 오다빈 | 로그인/로그아웃, 회원정보, 커뮤니티 게시판, 문서결재(서명 및 결재)|

---

#### 📃 기능: 회의실 및 예약 관리, 문서결재(서명 - 결재) (담당: 안소나)

### 1. 회의실 관리
`경영 지원팀`은 회의실 관리에서 회의실을 추가하고 수정 및 삭제가 가능합니다.
<img src=https://github.com/user-attachments/assets/67a6dce1-ae00-4386-a407-52986a27133a width="700">

**구현 의도** <br>
`회의실 생성`: 회의실명에 대한 중복 검사를 실행하며, 사용자에게 직관적인 UI를 제공하기 위해 회의실 사진을 첨부할 수 있도록 구현했습니다. <br>
사진을 추가하지 않은 경우, 기본 이미지가 표시됩니다.<br>
`회의실 수정`: JavaScript - Ajax를 활용하여 서버로부터 회의실 정보를 가져옵니다. 사용자가 선택한 회의실의 이름을 저장하는 변수를 추가하여, 기존 회의실 이름은 중복 검사 예외처리를 하도록 구현하였습니다.

<details>
    <summary>구현 코드</summary>
    <div>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/webapp/resource/js/equipment/meetRoomList.js" target="_blank">회의실 리스트 js </a></br>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/java/com/goodee/JoinTree/service/MeetRoomService.java" target="_blank">회의실 Service </a></br>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/java/com/goodee/JoinTree/mapper/MeetRoomMapper.xml" target="_blank">회의실 xml </a></br>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/java/com/goodee/JoinTree/controller/MeetRoomController.java" target="_blank">회의실 Controller</a></br>
    </div>
</details>

### 2. 예약 관리
<img src=https://github.com/user-attachments/assets/68647a02-ec49-4886-a2ac-74796f2f998b width="700">

**구현 의도** <br>
`공통 회의실 예약`: fullCalendar, moment.js, sweetAlert2 라이브러리 추가로 사용자 예약 환경을 개선하였습니다.<br>
이 때 30분 시간 단위로 `예약 시작, 종료 시간`을 설정하고, 이미 예약됐거나 지난 시간에는 예약할 수 없도록 비활성화처리 하였습니다.<br>
`예약 관리`: @Scheduled 메서드와 LocalDateTime 클래스를 활용하여 예약상태(예약 완료→사용 완료) 자동 변경이 되도록 구현하였습니다. (사용 완료 시 예약취소 불가능)<br>
`예약 조회`: 예약자, 예약 상태, 예약 날짜 비동기 검색 기능 구현

<details>
    <summary>구현 코드</summary>
    <div>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/java/com/goodee/JoinTree/controller/MeetReservController.java" target="_blank">예약 controller </a></br>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/java/com/goodee/JoinTree/mapper/MeetRoomReservMapper.xml" target="_blank">예약 xml </a></br>
        <a href="https://github.com/sonaanweb/JoinTree/tree/main/JoinTree/src/main/webapp/WEB-INF/view/reservation" target="_blank">예약 관련 js 패키지 </a></br>
        <a href="https://github.com/sonaanweb/JoinTree/blob/main/JoinTree/src/main/java/com/goodee/JoinTree/service/MeetRoomReservService.java" target="_blank">예약 service</a></br>
    </div>
</details>
