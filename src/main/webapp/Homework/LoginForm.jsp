<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
	       integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
	    integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
	    crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">    
<title>Session</title>
</head>
<body>
<div class="container">
    <div class="row">
        <!-- 상단 네비게이션 인클루드 -->
        <%@ include file ="./inc/top.jsp" %>
    </div>
    <div class="row">
		<!-- 사이드바 인클루드 -->
		<%@ include file = "./inc/side.jsp" %>
        <div class="col-9 pt-3">
			<span style="color:red; font-size:1.2em;">
				<%=request.getAttribute("LoginErrMsg")==null?
				         "" : request.getAttribute("LoginErrMsg")%>
			</span>
			<%
			/* 세션영역에 UserId라는 속성값이 없는 경우, 즉 로그인 처리가
			되지 않은 상태에서는 로그인폼과 검증을 위한 JS를 웹브라우저에
			출력한다. */
			if(session.getAttribute("UserId")==null){ // 로그인 상태 확인
			   //로그아웃 상태
			%>
			<!-- 로그인 폼의 입력값을 검증하기 위한 함수로 빈값인지를
			확인한다. -->
			<script>
			function validateForm(form){
			 /*<form>태그 하위의 각 input 태그에 입력값이 있는지
			 확인하여 만약 빈값이라면 경고창, 포커스이동, 폼값전송취소
			 처리를 한다. */
			   if(!form.user_id.value){
			      alert("아이디를 입력하세요.");
			      form.user_id.focus();
			      return false;
			   }
			   if(form.user_pw.value == ""){
			      alert("패스워드를 입력하세요");
			      form.user_pw.focus();
			      return false;
			   }
			}
			</script>
			<!-- 
			폼값 전송을 위한 <form>태그로 전송할URL, 전송방식, 폼의 이름,
			submit 이벤트 리스너로 구성한다. 특히 폼값검증을 위한 
			validateForm() 함수 호출시 <form>태그의 DOM을 인수로 전달한다.
			 -->
			<form action="LoginProcess.jsp" method="post" name="loginFrm"
			   onsubmit="return validateForm(this);">
			    아이디 : <input type="text" name="user_id"> <br>
			    패스워드 : <input type="password" name="user_pw"><br>
			    <input type="submit" value="로그인하기">
			</form>
			<%
			}else{
			 /* session영역에 저장된 속성값이 있다면 로그인 된 상태이므로
			 회원정보 및 로그아웃 버튼을 화면에 출력한다. */
			%>
			   <%=session.getAttribute("UserName") %> 회원님, 로그인하셨습니다. <br>
			   <a href="Logout.jsp">[로그아웃]</a>
			<%
			}
			%>
        </div>
    </div>
    <div class="row border border-dark border-bottom-0 border-right-0 border-left-0"></div>
   	<!-- 바텀 인클루드 -->
	<%@ include file = "./inc/bottom.jsp" %>
</div>
</body>
</html>