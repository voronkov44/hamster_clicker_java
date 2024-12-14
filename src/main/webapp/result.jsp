<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Результаты</title>
    <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/result.css">
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

<h1>Результаты вашей игры</h1>

<div id="result">
    <%
        Integer clicks = (Integer) request.getAttribute("clicks");
        String message = (String) request.getAttribute("message");
        if (clicks != null) {
    %>
    Вы кликнули на хомяка: <%= clicks %> раз(а)!
    <%
    } else if (message != null) {
    %>
    <p><%= message %></p>
    <%
    } else {
    %>
    <p>Ошибка: результаты недоступны.</p>
    <%
        }
    %>
</div>

<a href="<%= request.getContextPath() %>/index.jsp" id="playButton">Играть снова</a>

<footer>
    <p>&copy; 2023 HamsterClick. Все права защищены.</p>
    <p><a href="<%= request.getContextPath() %>/privacy.html">Политика конфиденциальности</a></p>
</footer>
</body>
</html>
