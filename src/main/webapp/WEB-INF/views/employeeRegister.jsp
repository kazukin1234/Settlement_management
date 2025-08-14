<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員登録</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/static/css/style.css">
<style>
.form-group input, .form-group select {
	width: 100%;
	padding: 8px;
	font-size: 1rem;
}

.btn-section {
	text-align: center;
	margin-top: 20px;
}

h2 {
	text-align: center;
	color: #2c7be5;
}

.page-container {
	max-width: 700px;
	margin: 30px auto;
	background-color: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
</style>
</head>
<body>
	<div class="page-container">
		<h2>${pageTitle}</h2>

		<%-- Hiển thị lỗi nếu có --%>

		<form action="<%=request.getContextPath()%>/employeeRegisterPage"
			method="post">
			<input type="hidden" name="action" value="confirm">

			<div class="form-section">
				<div class="form-group">
					<label>社員ID</label> <input type="text" name="employeeId"
						<c:if test="${not empty employeeId}">readonly</c:if> maxlength="5"
						value="${employeeId}">
				</div>
				<div class="form-group">
					<label>氏名</label> <input type="text" name="fullName" required
						maxlength="20" value="${fullName}">
				</div>
				<div class="form-group">
					<label>ふりがな</label> <input type="text" name="furigana" required
						maxlength="20" value="${furigana}">
				</div>
				<div class="form-group">
					<label>生年月日</label> <input type="date" name="birthDate" required
						value="${birthDateStr}">
				</div>
				<div class="form-group">
					<label>住所</label> <input type="text" name="address" maxlength="50"
						value="${address}">
				</div>
				<div class="form-group">
					<label>入社日</label> <input type="date" name="joinDate" required
						value="${joinDateStr}">
				</div>
				<div class="form-group">
					<label>パスワード</label> <input type="text" name="password" required
						maxlength="8" value="${password}">
				</div>
				<div class="form-group">
					<label>パスワード確認</label> <input type="text" name="confirmPassword"
						required maxlength="8" value="${confirmPassword}">
				</div>
				<div class="form-group">
					<label>部署ID</label> <input type="text" name="departmentId" 
						maxlength="5" value="${departmentId}">
				</div>
				<div class="form-group">
					<label>役職ID</label> <input type="text" name="positionId" 
						maxlength="5" value="${positionId}">
				</div>
			</div>

			<div class="btn-section">
				<button type="button" onclick="location.href='<%= request.getContextPath() %>/employeeList'">戻る</button>
				<button type="submit">確認</button>

			</div>
		</form>
	</div>
	<script type="text/javascript">
	function goBack() {
    if (confirm('本当に戻りますか？')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '<%=request.getContextPath()%>
		/employeeRegisterPage';

				const hidden = document.createElement('input');
				hidden.type = 'hidden';
				hidden.name = 'action';
				hidden.value = 'cancel';

				form.appendChild(hidden);
				document.body.appendChild(form);
				form.submit();
			}
		}
	</script>
	<c:if test="${not empty error}">
		<script>
			alert("${error}");
		</script>
	</c:if>
</body>
</html>
