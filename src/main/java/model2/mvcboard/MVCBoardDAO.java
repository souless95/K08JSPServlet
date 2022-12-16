package model2.mvcboard;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

import common.DBConnPool;
import common.JDBConnect;

public class MVCBoardDAO extends DBConnPool {
	
	//생성자에서 DBCP(커넥션풀)를 통해 오라클에 연결한다.
	public MVCBoardDAO() {
		super();
	}
	
	//게시물의 갯수를 카운트한다.
	public int selectCount(Map<String, Object> map) {
		int totalCount = 0;
		//만약 검색어가 있다면 조건에 맞는 게시물을 카운트해야하므로
		//조건부(where)로 쿼리문을 추가한다.
		String query = "SELECT COUNT(*) FROM mvcboard";
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
					+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			rs.next();
			totalCount = rs.getInt(1);
		} 
		catch (Exception e) {
			System.out.println("게시물 수를 구하는 중 예외 발생");
			e.printStackTrace();
		}
		
		return totalCount;
	}
	
	/*
	모델1 방식에서는 board테이블 및 BoardDTO클래스를 사용했지만
	모델2 방식에서는 mvcboard테이블 및 MVCBoardDTO를 사용하므로
	해당 코드만 수정하면 된다.
	*/
	//조건에 맞는 게시물을 목록에 출력하기 위한 쿼리문을 실행한다.
	public List<MVCBoardDTO> selectListPage(Map<String, Object> map) {
		List<MVCBoardDTO> board = new Vector<MVCBoardDTO>();
		
		String query = " "
					+ "SELECT * FROM ( "
					+ "    SELECT Tb.*, ROWNUM rNum FROM ( "
					+ " SELECT * FROM mvcboard ";
		
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
					+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		query += "ORDER BY idx DESC "
				+ "    ) Tb "
				+ " ) "
				+ " WHERE rNum BETWEEN ? AND ?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, map.get("start").toString());
			psmt.setString(2, map.get("end").toString());
			rs = psmt.executeQuery();
			
			while(rs.next()) {
				MVCBoardDTO dto = new MVCBoardDTO();
				
				dto.setIdx(rs.getString(1));
				dto.setName(rs.getString(2));
				dto.setTitle(rs.getString(3));
				dto.setContent(rs.getString(4));
				dto.setPostdate(rs.getDate(5));
				dto.setOfile(rs.getString(6));
				dto.setSfile(rs.getString(7));
				dto.setDowncount(rs.getInt(8));
				dto.setPass(rs.getString(9));
				dto.setVisitcount(rs.getInt(10));
				
				//List컬렉션에 DTO객체를 추가한다. 
				board.add(dto);
			}

		} 
		catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		
		return board;
	}
	
	//글쓰기 처리시 첨부파일까지 함께 입력한다.
	public int insertWrite(MVCBoardDTO dto) {
		int result=0;
		try {
			/*
			ofile : 원본파일명
			sfile : 서버에 저장된 파일명
			pass : 비회원제 게시판이므로 수정, 삭제를 위한 인증에
			 사용되는 비밀번호
			*/
			String query = "INSERT INTO mvcboard ( "
					+ " idx, name, title, content, ofile, sfile, pass) "
					+ " VALUES ( "
					+ " seq_board_num.NEXTVAL,?,?,?,?,?,?) ";
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getName());
			psmt.setString(2, dto.getTitle());
			psmt.setString(3, dto.getContent());
			psmt.setString(4, dto.getOfile());
			psmt.setString(5, dto.getSfile());
			psmt.setString(6, dto.getPass());
			result = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("게시물 입력 중 예외 발생");
			e.printStackTrace();
		}
		return result;
	}
	
}
