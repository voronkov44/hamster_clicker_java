<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>preview</title>
    <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/preview.css">
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
    <h1>Добро пожаловать в HamsterClick!</h1>
    <div id="description">Приготовьтесь к увлекательной игре! Кликните на хомяка, чтобы заработать очки!</div>
    <a href="<%= request.getContextPath() %>/index.jsp" id="playButton">Играть</a>
    <img id="previewImage" src="<%= request.getContextPath() %>/photo/hamster3.png" alt="Хомяк" />
</main>
<footer>
    <p>&copy; 2023 HamsterClick. Все права защищены.</p>
    <p><a href="<%= request.getContextPath() %>/privacy.html">Политика конфиденциальности</a></p>
</footer>
</body>
</html>
