<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Вход</title>
  <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/login.css">
</head>
<body>
<main>
  <!-- Сообщение о результате аутентификации -->
  <h1><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Вход в игру" %></h1>

  <!-- Форма для ввода данных -->
  <form id="loginForm" action="<%= request.getContextPath() %>/login" method="POST">
    <div>
      <label for="nickname">Никнейм:</label>
      <input type="text" id="nickname" name="nickname" placeholder="nickname" required>
    </div>
    <div>
      <label for="password">Пароль:</label>
      <input type="password" id="password" name="password" placeholder="Пароль" autocomplete="off" required>
    </div>
    <button type="submit" id="loginButton">Войти</button>
  </form>

  <!-- Ссылка на регистрацию -->
  <p id="registerPrompt">Не зарегистрирован? <a href="<%= request.getContextPath() %>/registerLogin.jsp" id="registerButton">Зарегистрироваться</a></p>
</main>
</body>
</html>
