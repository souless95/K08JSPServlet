<%@page import="model1.board.BoardDTO"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* 목록에서 제목을 클릭하면 게시물의 일련번호를 ?num=99와 같이
받아온다. 따라서 내용보기를 위해 해당 파라미터를 받아온다. */
String num = request.getParameter("num");
//DAO 객체 생성을 통해 오라클에 연결한다. 
BoardDAO dao = new BoardDAO(application);
//게시물의 조회수 증가
dao.updateVisitCount(num);
//게시물의 내용을 인출하여 DTO로 반환받는다.
BoardDTO dto = dao.selectView(num);
//자원해제
dao.close();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
        crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">    
	<script>
	//게시물 삭제를 위한 Javascript 함수
	function deletePost() {
		//confirm() 함수는 대화창에서 "예"를 누를때 true가 반환된다.
	    var confirmed = confirm("정말로 삭제하겠습니까?"); 
	    if (confirmed) {
	    	//<form>의 name속성을 통해 DOM을 가져온다.
	        var form = document.writeFrm;      
	    	//전송방식과 폼값을 전송할 URL을 설정한다. 
	        form.method = "post"; 
	        form.action = "boardDeleteProcess.jsp"; 
	        //submit() 함수를 통해 폼값을 전송한다.
	        form.submit();  
	        //<form>태그 하위의 hidden박스에 설정된 일련번호가 전송된다.
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
            <h3>게시판 내용보기 - <small>자유게시판</small></h3>

            <form name="writeFrm" >
	            <input type="hidden" name="num" value="<%= num %>" />  
	            <table class="table table-bordered">
	            <colgroup>
	                <col width="20%"/>
	                <col width="30%"/>
	                <col width="20%"/>
	                <col width="*"/>
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th class="text-center" 
	                        style="vertical-align:middle;">번호</th>
	                    <td>
	                        <%= dto.getNum() %>
	                    </td>
	                    <th class="text-center" 
	                        style="vertical-align:middle;">작성자</th>
	                    <td>
	                        <%= dto.getName() %>
	                    </td>
	                </tr>
	                <tr>
	                    <th class="text-center" 
	                        style="vertical-align:middle;">작성일</th>
	                    <td>
	                        <%= dto.getPostdate() %>
	                    </td>
	                    <th class="text-center" 
	                        style="vertical-align:middle;">조회수</th>
	                    <td>
	                        <%= dto.getVisitcount() %>
	                    </td>
	                </tr>
	                <tr>
	                    <th class="text-center" 
	                        style="vertical-align:middle;">제목</th>
	                    <td colspan="3">
	                        <%= dto.getTitle() %>
	                    </td>
	                </tr>
	                <tr>
	                    <th class="text-center" 
	                        style="vertical-align:middle;">내용</th>
	                    <td colspan="3">
	                        <%= dto.getContent().replace("\r\n", "<br/>") %>
	                    </td>
	                </tr>
	                <tr>
	            </tbody>
	            </table>
	            <div class="row">
	                <div class="col d-flex justify-content-end mb-4">
	               		<%
		            	/*
		            	로그인이 된 상태에서, 세션영역에 저장된 아이디가 해당 게시물을
		            	작성한 아이디와 일치하면 수정, 삭제 버튼을 보이게 처리한다.
		            	즉, 작성자 본인이 해당 게시물을 조회했을때만 수정, 삭제 버튼이
		            	보이게 처리한다.
		            	*/
		            	if(session.getAttribute("UserId")!= null &&
		            	dto.getId().equals(session.getAttribute("UserId").toString())){
		            		
		            	%>
		                <button type="button" class="btn btn-secondary me-1" 
		                	onclick="location.href='boardEdit.jsp?num=<%=dto.getNum()%>';">
		                    수정하기</button>
		                <button type="button" class="btn btn-success me-1"
		                	onclick="deletePost();">
		                	삭제하기</button> 
		                <%
		            	}
		            	%>
		                <button type="button" class="btn btn-warning"
		                	onclick="location.href='boardList.jsp';">
		                    목록 보기
		                </button>
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