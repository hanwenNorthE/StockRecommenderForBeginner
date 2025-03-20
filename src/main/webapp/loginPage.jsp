<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>Login / Sign Up</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <style>
      body {
        padding-top: 20px;
        background-color: #F5F5F5; /* 浅灰色背景 */
        color: #333333; /* 深灰色文本 */
    }

    .container {
        max-width: 500px;
        margin: 0 auto;
    }

    .auth-form {
        background-color: #003366; /* 深蓝色背景 */
        color: #C0C0C0; /* 亮银色文本 */
        padding: 30px;
        border-radius: 8px;
        margin-top: 20px;
    }

    .auth-form h2 {
        color: #C0C0C0; /* 亮银色标题 */
    }

    .auth-form input[type="text"],
    .auth-form input[type="password"] {
        width: 100%;
        padding: 12px;
        margin: 10px 0;
        border: 1px solid #C0C0C0; /* 亮银色边框 */
        border-radius: 5px;
        background-color: #F5F5F5; /* 输入框背景色 */
        color: #333333; /* 输入框文本颜色 */
    }

    .auth-form button {
        background-color: #1E90FF; /* 电光蓝按钮 */
        color: white;
        border: none;
        padding: 12px;
        border-radius: 5px;
        width: 100%;
        cursor: pointer;
    }

    .auth-form button:hover {
        background-color: #32CD32; /* 悬浮时使用翠绿色 */
    }

   </style>
</head>
<body>
   <div class="container">
      <!-- 导航选项卡 -->
      <ul class="nav nav-tabs" id="authTab" role="tablist">
         <li class="nav-item" role="presentation">
             <button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true">Login</button>
         </li>
         <li class="nav-item" role="presentation">
             <button class="nav-link" id="register-tab" data-bs-toggle="tab" data-bs-target="#register" type="button" role="tab" aria-controls="register" aria-selected="false">Sign Up</button>
         </li>
      </ul>

      <div class="tab-content" id="authTabContent">
         <!-- 登录表单 -->
         <div class="tab-pane fade show active auth-form" id="login" role="tabpanel" aria-labelledby="login-tab">
             <h2 class="text-center">Log In</h2>
             <!-- 如果有错误信息则显示 -->
             <c:if test="${not empty loginError}">
                <div class="alert alert-danger" role="alert">
                  ${loginError}
                </div>
             </c:if>
             <!-- 修改 action 地址为 /users/login -->
             <form action="${pageContext.request.contextPath}/users/login" method="post">
                 <div class="mb-3">
                     <label for="loginEmail" class="form-label">E-mail</label>
                     <input type="email" class="form-control" id="loginEmail" name="email" placeholder="Please enter e-mail" required>
                 </div>
                 <div class="mb-3">
                     <label for="loginPassword" class="form-label">Password</label>
                     <input type="password" class="form-control" id="loginPassword" name="password" placeholder="Please enter password" required>
                 </div>
                 <button type="submit" class="btn btn-primary w-100">Login</button>
             </form>
         </div>

         <!-- 注册表单 -->
         <div class="tab-pane fade auth-form" id="register" role="tabpanel" aria-labelledby="register-tab">
            <h2 class="text-center">Sign Up</h2>
            <c:if test="${not empty registerError}">
              <div class="alert alert-danger" role="alert">
                  ${registerError}
              </div>
            </c:if>
            <!-- 修改 action 地址为 /users/register -->
            <form action="${pageContext.request.contextPath}/users/register" method="post">
                <div class="mb-3">
                    <label for="registerEmail" class="form-label">E-mail</label>
                    <input type="email" class="form-control" id="registerEmail" name="email" placeholder="Please enter e-mail" required>
                </div>
                <div class="mb-3">
                    <label for="registerPassword" class="form-label">Password</label>
                    <input type="password" class="form-control" id="registerPassword" name="password" placeholder="Please enter password" required>
                </div>
                <div class="mb-3">
                    <label for="registerConfirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="registerConfirmPassword" name="confirmPassword" placeholder="Please re-enter password" required>
                </div>
                <!-- 姓名信息 -->
                <div class="mb-3">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" placeholder="First Name" required>
                </div>
                <div class="mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Last Name" required>
                </div>
                <div class="mb-3">
                    <label for="middleName" class="form-label">Middle Name</label>
                    <input type="text" class="form-control" id="middleName" name="middleName" placeholder="Middle Name(optional)">
                </div>
                <button type="submit" class="btn btn-primary w-100">Register</button>
            </form>
         </div>
      </div>
   </div>

   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
