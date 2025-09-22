<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bean.PositionBean"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
ArrayList<PositionBean> positionList = (ArrayList<PositionBean>) session.getAttribute("position_list");
if (positionList == null)
	positionList = new ArrayList<>();
request.setAttribute("positionList", positionList); // JSTLで使うため
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>役職一覧 - 管理画面</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/static/css/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
<style>
table {
	width: 500px;
}

@media ( max-width : 768px) {
	table {
		width: 300px;
	}
}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="page-container">
  <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
  <div class="content-container-form">
    <h2>役職一覧</h2>
    <form class="info_table" action="positionControl" method="post">
      <table>
        <thead>
          <tr>
            <th class="th-action-toolbar" colspan="100" style="text-align: right;">
              <div class="action-toolbar">
               <!--   <button type="button"
                  onclick="location.href='positionControl?action=add'">＋ 新規追加</button> -->
                <button type="submit" name="action" value="edit" id="editBtn" disabled>編集</button>
                <!--  <button type="submit" name="action" value="delete" id="deleteBtn" disabled
                  onclick="return confirm('本当に削除しますか？')">削除</button>-->
              </div>
            </th>
          </tr>
          <tr>
            <th>選択</th>
            <th>役職ID</th>
            <th>役職名</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="pos" items="${positionList}">
            <tr>
              <td>
                <input type="checkbox" name="position_id" value="${pos.position_id}" class="row-check"
                  <c:if test="${pos.delete_flag == 9}">disabled</c:if>>
              </td>
              <td>${pos.position_id}</td>
              <td>
                ${pos.position_name}
                <c:if test="${pos.delete_flag == 9}">
                  <span style="color: gray;">（削除不可）</span>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </form>
  </div>
</div>


	<script>
	const checkboxes = document.querySelectorAll('.row-check');
	const editBtn = document.getElementById('editBtn');
	const deleteBtn = document.getElementById('deleteBtn');

	checkboxes.forEach(cb => {
		cb.addEventListener('change', () => {
			const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;
			editBtn.disabled = checkedCount !== 1;
			deleteBtn.disabled = checkedCount === 0;
		});
	});
	</script>

	<%
	String method = request.getMethod();
	String successMsg = (String) request.getAttribute("successMsg");
	String errorMsg = (String) request.getAttribute("errorMsg");
	session.removeAttribute("successMsg");
	session.removeAttribute("errorMsg");

	if ("POST".equalsIgnoreCase(method)) {
		if (successMsg != null) {
	%>
	<script>alert("<%=successMsg%>");</script>
	<%
	} else if (errorMsg != null) {
	%>
	<script>alert("<%=errorMsg%>");</script>
	<%
	}
	}
	%>
</body>
</html>
