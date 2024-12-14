<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>home_page</title>
    <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/register.css">
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
    <h1>Регистрация</h1>
    <div id="registrationForm">
        <!-- Форма регистрации -->
        <form action="<%= request.getContextPath() %>/register" method="POST">
            <input type="text" name="name" placeholder="Имя" required>
            <input type="text" name="surname" placeholder="Фамилия" required>
            <input type="text" name="nickname" placeholder="Никнейм" required>
            <input type="password" name="password" placeholder="Пароль" required>
            <button type="submit">Зарегистрироваться</button>
        </form>
    </div>

    <!-- Сообщение о результате регистрации -->
    <div>
        <h2><%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %></h2>
    </div>
</main>
<footer>
    <p>&copy; 2023 HamsterClick. Все права защищены.</p>
    <p><a href="<%= request.getContextPath() %>/privacy.html">Политика конфиденциальности</a></p>
</footer>
</body>
</html>
