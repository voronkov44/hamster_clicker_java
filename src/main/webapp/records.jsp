<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.TopRecordsServlet.Record" %>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Рекорды кликов</title>
  <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/records.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/header.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/footer.css">
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
  <h1>Рекорды кликов</h1>
  <div class="record-container">
    <%
      // Получаем список рекордов из атрибута, переданного серверлетом
      List<Record> topRecords = (List<Record>) request.getAttribute("topRecords");

      if (topRecords != null && !topRecords.isEmpty()) {
        int place = 1;
        for (Record record : topRecords) {
    %>
    <div class="record">
      <h2>Место <%= place++ %>: <%= record.getNickname() %></h2>
      <p>Клики: <%= record.getClickCount() %></p>
    </div>
    <%
      }
    } else {
    %>
    <p>Рекорды пока не зарегистрированы.</p>
    <%
      }
    %>
  </div>
</main>

<footer>
  <p>&copy; 2024 HamsterClick. Все права защищены.</p>
  <p><a href="<%= request.getContextPath() %>/privacy.html">Политика конфиденциальности</a></p>
</footer>
</body>
</html>
