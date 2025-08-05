<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>社員登録</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/style.css">
  <style>
    .form-group input, .form-group select {
      width: 100%;
      padding: 8px;
      font-size: 1rem;
    }
  </style>
</head>
<body>
  <div class="page-container">
    <h2>社員登録フォーム</h2>
    <form action="<%= request.getContextPath() %>/employeeRegisterPage" method="post">
      <div class="form-section">
        <div class="form-group">
          <label>社員ID</label>
          <input type="text" name="employee_id" required maxlength="5">
        </div>
        <div class="form-group">
          <label>氏名</label>
          <input type="text" name="full_name" required maxlength="20">
        </div>
        <div class="form-group">
          <label>ふりがな</label>
          <input type="text" name="furigana" required maxlength="20">
        </div>
        <div class="form-group">
          <label>生年月日</label>
          <input type="date" name="birth_date" required>
        </div>
        <div class="form-group">
          <label>住所</label>
          <input type="text" name="address" maxlength="50">
        </div>
        <div class="form-group">
          <label>入社日</label>
          <input type="date" name="join_date" required>
        </div>
        <div class="form-group">
          <label>ログインID</label>
          <input type="text" name="login_id" required maxlength="5">
        </div>
        <div class="form-group">
          <label>パスワード</label>
          <input type="password" name="password" required maxlength="5">
        </div>
        <div class="form-group">
          <label>パスワード確認</label>
          <input type="password" name="confirmPassword" required maxlength="5">
        </div>
        <div class="form-group">
          <label>部署ID</label>
          <input type="text" name="department_id" required maxlength="5">
        </div>
        <div class="form-group">
          <label>役職ID</label>
          <input type="text" name="position_id" required maxlength="5">
        </div>
      </div>
      
      <div class="btn-section">
        <button type="submit">登録</button>
        <button type="reset">リセット</button>
      </div>
    </form>
    
    
  </div>
</body>
</html>
