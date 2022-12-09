<%@page import="utils.JSFunction"%>
<%@page import="model1.board.BoardDTO"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 수정페이지로 진입시 로그인을 확인한다. -->
<%@ include file="./IsLoggedIn.jsp" %>

<%
//수정할 게시물의 일련번호를 파라미터로 받아온다.
String num = request.getParameter("num");
//DAO 객체 생성
BoardDAO dao = new BoardDAO(application);
//기존 게시물의 내용을 읽어온다.
BoardDTO dto = dao.selectView(num);
//세션영역에 저장된 회원 아이디를 가져와서 문자열로 변환한다.
String userId = session.getAttribute("UserId").toString();
//로그인한 회원이 작성자인지 판단한다.
if(!userId.equals(dto.getId())){
	//작성자가 아니라면 진입할 수 없도록 뒤로 이동한다.
	JSFunction.alertBack("작성자 본인만 수정할 수 있습니다.", out);
	return;
}
/*
URL의 패턴을 파악하면 내가 작성한 게시물이 아니어도 얼마든지
수정페이지로 진입할 수 있다. 따라서 수정페이지 자체에서도 작성자
본인이 맞는지 확인하는 절차가 필요하다.
*/
//자원해제
dao.close();
%>
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
<title>회원제 게시판</title>
<script type="text/javascript">
function validateForm(form){
	if(form.title.value =="") {
		alert("제목을 입력하세요.");
		form.title.focus();
		return false;
	}
	if(form.content.value =="") {
		alert("내용을 입력하세요.");
		form.content.focus();
		return false;
	}
}
</script>
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
            <h3>게시판 작성 - <small>자유게시판</small></h3>

            <form name="writeFrm" method="post" action="boardEditProcess.jsp"
      				onsubmit="return validateForm(this);">
      			<!-- 
				게시물의 일련번호를 서버로 전송하기 위해서 hidden타입의 input이
				반드시 필요하다.
				-->
				<input type="hidden" name="num" value="<%= dto.getNum() %>" />	
                <table class="table table-bordered">
                <colgroup>
                    <col width="20%"/>
                    <col width="*"/>
                </colgroup>
                <tbody>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">작성자</th>
                        <td>
                            <input type="text" class="form-control" 
                                style="width:100px;" value="<%= userId %>" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center"
                            style="vertical-align:middle;">제목</th>
                        <td>
                            <input type="text" class="form-control"  name="title" 
                            	value="<%=dto.getTitle() %>"/>
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center" 
                            style="vertical-align:middle;">내용</th>
                        <td>
                            <textarea rows="5" class="form-control" name="content" >
                            <%=dto.getContent() %></textarea>
                        </td>
                    </tr>
                </tbody>
                </table>
                
                <div class="row">
                    <div class="col d-flex justify-content-end mb-4">
                        <!-- 각종 버튼 부분 -->
                        <button type="submit" class="btn btn-danger me-1">작성완료</button>
                        <button type="reset" class="btn btn-dark me-1">다시입력</button>
                        <button type="button" class="btn btn-warning" onclick="location.href='boardList.jsp';" >목록이동</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="row border border-dark border-bottom-0 border-right-0 border-left-0"></div>
   	<!-- 바텀 인클루드 -->
	<%@ include file = "./inc/bottom.jsp" %>
</div>
</body>
</html>