<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>立替金精算書</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/css/style.css">
<script src="${pageContext.request.contextPath}/static/js/reimbursement.js"></script>
<style>
.remove-btn {
    position: absolute;
    top: 1px;
    right: 1px;
    background: none;
    border: none;
    font-size: 1.5rem;
    color: #888;
    cursor: pointer;
    font-weight: bold;
}
.fileList {
    list-style-type: none;
    padding-left: 0;
    margin-top: 8px;
}
#reimbursement-template {
    display: none;
}
.file-delete-btn {
    background: none;
    padding: 4px;
    color: red;
    border: none;
    border-radius: 4px;
    text-decoration: none;
    font-size: 1.2rem;
    cursor: pointer;
    transition: background 0.3s;
    height: 36.8px;
}
.file-delete-btn:hover {
    background: none;
    transform: scale(1.2);
    opacity: 0.8;
}
</style>
</head>
<body>
<div class="page-container">
  <div class="content-container">
    <h2>立替金精算書</h2>
    <form action="<%=request.getContextPath()%>/reimbursement" method="post" enctype="multipart/form-data">
      <input type="hidden" id="filesToDelete" name="filesToDelete" value="">

      <div id="reimbursement-container" style="display: flex; flex-direction: column; gap: 10px">
        <c:forEach var="detail" items="${reimbursement.details}" varStatus="loop">
          <div class="form-section reimbursement-block" style="position: relative;">
            <button type="button" class="remove-btn" onclick="removeReimbursementBlock(this)">×</button>
            <div class="form-group"><label>日付</label><input required type="date" name="date[]" value="${detail.date}" ></div>
      <div class="form-group"><label>支払先</label><input required type="text" name="destinations[]" placeholder="例:○○道具店" /></div>
    
    <div class="form-group">
      <label>PJコード</label>
      <select name="projectCode[]">
        <option value="">選択してください</option>
        <c:forEach var="p" items="${projectList}">
          <option value="${p.id}">${p.id}：${p.name}</option>
        </c:forEach>
      </select>
    </div>
    
            
            <div class="form-group"><label>勘定科目</label><input required type="text" name="accountingItem[]" value="${detail.accountingItem}" /></div>
            <div class="form-group"><label>摘要(内容や目的)</label><textarea required name="abstractNote[]">${detail.abstractNote}</textarea></div>
            <div class="form-group"><label>金額</label><input type="number" name="amount[]" value="${detail.amount}" required></div>
           <div class="form-group"><label>備考</label><textarea required name="report[]">${detail.report}</textarea></div>
           
            <div class="form-group">
              <label>領収書添付</label>
              <input type="file" name="receipt_reimbursement_${loop.index}" multiple class="fileInput" onchange="handleFileSelection(this)">
              <ul class="fileList">
                <c:forEach var="file" items="${detail.temporaryFiles}">
                  <li data-file-type="existing" data-unique-name="${file.uniqueStoredName}">
                    <a href="${pageContext.request.contextPath}/uploads/${file.uniqueStoredName}" target="_blank">${file.originalFileName}</a>
                    <button type="button" class="file-delete-btn" onclick="deleteExistingFile(this)">×</button>
                  </li>
                </c:forEach>
              </ul>
            </div>
          </div>
        </c:forEach>
      </div>

      <div style="text-align: center; margin-top: 10px;">
        <button type="button" class="plus-btn" onclick="addReimbursementBlock()">＋</button>
      </div>

      <div class="btn-section">
        <button type="button" class="back-btn" onclick="window.location.href='<%=request.getContextPath()%>/home'">戻る</button>
        <button type="submit" class="next-btn">確認</button>
      </div>
    </form>
  </div>
</div>

<div class="footer">&copy; 2025  - All rights reserved.</div>

<template id="reimbursement-template">
  <div class="form-section reimbursement-block" style="position: relative;">
    <button type="button" class="remove-btn" onclick="removeReimbursementBlock(this)">×</button>
    <div class="form-group"><label>日付</label><input required type="date" name="date[]"></div>
    <div class="form-group"><label>支払先</label><input required type="text" name="destinations[]" placeholder="例:○○道具店" /></div>
    
    <div class="form-group">
      <label>PJコード</label>
      <select name="projectCode[]">
        <option value="">選択してください</option>
        <c:forEach var="p" items="${projectList}">
          <option value="${p.id}">${p.id}：${p.name}</option>
        </c:forEach>
      </select>
    </div>
    
   <!-- <div class="form-group"><label>報告書</label><textarea  name="report[]" placeholder="報告書を入力してください"></textarea></div> --> 
    <div class="form-group"><label>勘定科目</label><input required type="text" name="accountingItem[]" placeholder="例:道具代" /></div>
    <div class="form-group"><label>摘要(内容や目的)</label><textarea required name="abstractNote[]" placeholder="例:ボールペン 1個"></textarea></div>
    <div class="form-group"><label>金額</label><input required type="number" name="amount[]"></div>
    <div class="form-group"><label>備考</label><textarea  name="report[]" placeholder="備考欄(何もなければスキップ)"></textarea></div>
    <div class="form-group">
      <label>領収書添付</label>
      <input type="file" name="receipt_reimbursement_" multiple class="fileInput" onchange="handleFileSelection(this)">
      <ul class="fileList"></ul>
    </div>
  </div>
</template>

</body>
</html>
