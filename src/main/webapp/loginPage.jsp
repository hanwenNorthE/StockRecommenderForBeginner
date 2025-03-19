<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>登录 / 注册 - 股票推荐系统</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <style>
      body {
         padding-top: 20px;
      }
      .container {
         max-width: 500px;
      }
      .auth-form {
         background-color: #f8f9fa;
         padding: 30px;
         border-radius: 8px;
         margin-top: 20px;
      }
   </style>
</head>
<body>
   <div class="container">
      <ul class="nav nav-tabs" id="authTab" role="tablist">
         <li class="nav-item" role="presentation">
             <button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true">登录</button>
         </li>
         <li class="nav-item" role="presentation">
             <button class="nav-link" id="register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false">注册</button>
         </li>
      </ul>
      <div class="tab-content" id="authTabContent">
         <!-- 登录表单 -->
         <div class="tab-pane fade show active auth-form" id="login" role="tabpanel" aria-labelledby="login-tab">
             <h2 class="text-center">用户登录</h2>
             <!-- 如果有错误信息则显示 -->
             <c:if test="${not empty loginError}">
                <div class="alert alert-danger" role="alert">
                  ${loginError}
                </div>
             </c:if>
             <form action="loginUser" method="post">
                 <div class="mb-3">
                     <label for="loginEmail" class="form-label">邮箱</label>
                     <input type="email" class="form-control" id="loginEmail" name="email" placeholder="请输入邮箱" required>
                 </div>
                 <div class="mb-3">
                     <label for="loginPassword" class="form-label">密码</label>
                     <input type="password" class="form-control" id="loginPassword" name="password" placeholder="请输入密码" required>
                 </div>
                 <button type="submit" class="btn btn-primary w-100">登录</button>
             </form>
         </div>
         <!-- 注册表单（此处可根据需要修改） -->
         <div class="tab-pane fade auth-form" id="register" role="tabpanel" aria-labelledby="register-tab">
             <h2 class="text-center">用户注册</h2>
             <c:if test="${not empty registerError}">
                <div class="alert alert-danger" role="alert">
                  ${registerError}
                </div>
             </c:if>
             <form action="registerUser" method="post">
                 <div class="mb-3">
                     <label for="registerEmail" class="form-label">邮箱</label>
                     <input type="email" class="form-control" id="registerEmail" name="email" placeholder="请输入邮箱" required>
                 </div>
                 <div class="mb-3">
                     <label for="registerPassword" class="form-label">密码</label>
                     <input type="password" class="form-control" id="registerPassword" name="password" placeholder="请输入密码" required>
                 </div>
                 <div class="mb-3">
                     <label for="registerConfirmPassword" class="form-label">确认密码</label>
                     <input type="password" class="form-control" id="registerConfirmPassword" name="confirmPassword" placeholder="请确认密码" required>
                 </div>
                 <button type="submit" class="btn btn-primary w-100">注册</button>
             </form>
         </div>
      </div>
   </div>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
