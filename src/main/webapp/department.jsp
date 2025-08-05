<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bean.DepartmentBean"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
ArrayList<DepartmentBean> departmentList = (ArrayList<DepartmentBean>) session.getAttribute("department_list");
if (departmentList == null)
	departmentList = new ArrayList<>();
request.setAttribute("departmentList", departmentList); // JSTL用

String successMsg = (String) session.getAttribute("successMsg");
String errorMsg = (String) session.getAttribute("errorMsg");
session.removeAttribute("successMsg");
session.removeAttribute("errorMsg");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>部署一覧 - 管理画面</title>
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
			<h2>部署一覧</h2>
			<form class="info_table" action="department" method="post">
				<table>
					<thead>
						<tr>
							<th class="th-action-toolbar" colspan="100"
								style="text-align: right;">
								<div class="action-toolbar">
									<div class="spacer"></div>
									<button type="button"
										onclick="location.href='department?action=add'">＋
										新規追加</button>
									<button type="submit" name="action" value="edit" id="editBtn"
										disabled>編集</button>
									<button type="submit" name="action" value="delete"
										id="deleteBtn" disabled onclick="return confirm('本当に削除しますか？')">削除</button>
								</div>
							</th>
						</tr>
						<tr>
							<th>選択</th>
							<th>部署ID</th>
							<th>部署名</th>
						</tr>
					</thead>
					<c:forEach var="dep" items="${departmentList}">
						<tr>
							<td><input type="checkbox" name="department_id"
								value="${dep.department_id}" class="row-check"
								<c:if test="${dep.delete_flag == 9}">disabled style="cursor:not-allowed;"</c:if>>
							</td>
							<td>${dep.department_id}</td>
							<td>${dep.department_name}<c:if
									test="${dep.delete_flag == 9}">
									<span style="color: gray;">（削除不可）</span>
								</c:if>
							</td>
						</tr>
					</c:forEach>
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
	<script>
<%if (successMsg != null) {%>
    alert("<%=successMsg.replaceAll("\"", "\\\\\"")%>");
<%} else if (errorMsg != null) {%>
    alert("<%=errorMsg.replaceAll("\"", "\\\\\"")%>");
<%}%>
</script>
</body>
</html>

