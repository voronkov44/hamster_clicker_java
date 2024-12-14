<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Скины персонажей</title>
  <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/header.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/footer.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/skins.css">
</head>
<body>
<header>
  <nav>
    <ul>
      <li><a href="<%= request.getContextPath() %>/preview.jsp">Главная</a></li>
      <li><a href="<%= request.getContextPath() %>/skins.jsp">Персонажи</a></li>
      <li><a href="<%= request.getContextPath() %>/TopRecordsServlet">Рекорды</a></li>
    </ul>
  </nav>
</header>
<main>
  <h1>Выбери своего персонажа</h1>
  <div class="skin-container">
    <!-- Пример динамического вывода списка скинов -->
    <%
      // Пример данных о скинах
      String[][] skins = {
              {"/photo/hamster3.png", "Обычный хомяк", "index.jsp"},
              {"/photo/hamster_NY.png", "Новогодний хомяк", "indexNY.jsp"},
              {"/photo/hamster_Clown.png", "Цирковой хомяк", "indexClown.jsp"},
              {"/photo/hamster_Balls.png", "Веселый хомяк", "indexBalls.jsp"}
      };

      for (String[] skin : skins) {
    %>
    <a class="skin" href="<%= request.getContextPath() %>/<%= skin[2] %>">
      <img src="<%= request.getContextPath() %><%= skin[0] %>" alt="<%= skin[1] %>" />
      <p><%= skin[1] %></p>
    </a>
    <% } %>
  </div>
</main>
<footer>
  <p>&copy; 2024 HamsterClick. Все права защищены.</p>
  <p><a href="<%= request.getContextPath() %>/privacy.html">Политика конфиденциальности</a></p>
</footer>
</body>
</html>
