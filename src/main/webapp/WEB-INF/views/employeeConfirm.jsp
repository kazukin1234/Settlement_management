<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="bean.Employee"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
Employee emp = (Employee) session.getAttribute("employeeTemp");
if (emp == null) {
	response.sendRedirect(request.getContextPath() + "/employeeRegisterPage");
	return;
}

String editId = (String) session.getAttribute("editEmployeeId");
String actionType = (editId != null) ? "update" : "register";
String buttonLabel = (editId != null) ? "更新" : "確認";
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員登録確認</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/css/style.css">
<style>
.page-container {
	max-width: 700px;
	margin: 40px auto;
	background-color: white;
	border-radius: 10px;
	padding: 30px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
}

th, td {
	padding: 10px;
	border: 1px solid #ccc;
	text-align: left;
}

th {
	background-color: #e6f0fa;
	width: 30%;
}

.btn-section {
	text-align: center;
}

.btn-section button {
	margin: 0 10px;
	padding: 10px 25px;
	background-color: #00A9B7;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 1rem;
}

.btn-section button:hover {
	opacity: 0.85;
}
</style>
</head>
<body>
	<div class="page-container">
		<h2 style="text-align: center; color: #00A9B7;">登録内容の確認</h2>
		<table>
			<tr><th>社員ID</th><td><%=emp.getEmployeeId()%></td></tr>
			<tr><th>氏名</th><td><%=emp.getFullName()%></td></tr>
			<tr><th>ふりがな</th><td><%=emp.getFurigana()%></td></tr>
			<!--  <tr><th>生年月日</th><td><%=emp.getBirthDate()%></td></tr>
			<tr><th>住所</th><td><%=emp.getAddress()%></td></tr>-->
			<tr><th>入社日</th><td><%=emp.getJoinDate()%></td></tr>
			<tr><th>部署ID</th><td><%=emp.getDepartmentId()%></td></tr>
			<tr><th>役職ID</th><td><%=emp.getPositionId()%></td></tr>
		</table>

		<div class="btn-section">
			<!-- 戻るボタン -->
			<form action="<%=request.getContextPath()%>/employeeRegisterPage"
				method="post" style="display: inline;">
				<input type="hidden" name="action" value="back">
				<input type="hidden" name="employeeId" value="<%=emp.getEmployeeId()%>">
				<input type="hidden" name="fullName" value="<%=emp.getFullName()%>">
				<input type="hidden" name="furigana" value="<%=emp.getFurigana()%>">
				<!-- 
				<input type="hidden" name="birthDate" value="<%=emp.getBirthDate()%>">
				<input type="hidden" name="address" value="<%=emp.getAddress()%>"> 
				-->
				<input type="hidden" name="joinDate" value="<%=emp.getJoinDate()%>">
				<input type="hidden" name="password" value="<%=emp.getPassword()%>">
				<input type="hidden" name="confirmPassword" value="<%=emp.getPassword()%>">
				<input type="hidden" name="departmentId" value="<%=emp.getDepartmentId()%>">
				<input type="hidden" name="positionId" value="<%=emp.getPositionId()%>">
				<button type="submit">戻る</button>
			</form>

			<!-- 確認または更新ボタン -->
			<form action="<%=request.getContextPath()%>/employeeRegisterPage"
				method="post" style="display: inline;">
				<input type="hidden" name="action" value="<%=actionType%>">
				<button type="submit"><%=buttonLabel%></button>
			</form>
		</div>
	</div>

	<c:if test="${not empty error}">
		<script>
			alert("${error}");
		</script>
	</c:if>
</body>
</html>
