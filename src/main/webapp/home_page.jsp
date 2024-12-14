<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>home_page</title>
    <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/home_page.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/header.css"> <!-- Подключаем CSS для шапки -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/footer.css"> <!-- Подключаем CSS для футера -->
</head>
<body>
<header>
    <nav>
        <ul>
            <li><a href="<%= request.getContextPath() %>/home_page.jsp">Главная</a></li>
            <li><a href="<%= request.getContextPath() %>/registerLogin.jsp">Регистрация</a></li>
        </ul>
    </nav>
</header>
<main>
    <h1>Добро пожаловать в HamsterClick!</h1>
    <div id="description">Для того чтобы начать играть, тебе нужно авторизоваться!</div>
    <a href="<%= request.getContextPath() %>/login.jsp" id="playButton">Войти</a>
    <img id="previewImage" src="<%= request.getContextPath() %>/photo/hamster3.png" alt="Хомяк" />
</main>
<footer>
    <p>&copy; 2023 HamsterClick. Все права защищены.</p>
    <p><a href="<%= request.getContextPath() %>/privacy.jsp">Политика конфиденциальности</a></p>
</footer>
</body>
</html>
