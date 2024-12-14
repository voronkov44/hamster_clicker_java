package org.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/book_platform";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Установить кодировку для получения данных
        request.setCharacterEncoding("UTF-8");

        // Получение данных из формы
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");

        if (nickname == null || password == null || nickname.isEmpty() || password.isEmpty()) {
            request.setAttribute("message", "Все поля должны быть заполнены.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Хэширование введенного пароля
        String hashedPassword = hashPassword(password);
        if (hashedPassword == null) {
            request.setAttribute("message", "Ошибка при обработке пароля.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Проверка данных в базе
        try {
            boolean isAuthenticated = authenticateUser(nickname, hashedPassword);
            if (isAuthenticated) {
                // Сохранение информации о пользователе в сессии
                HttpSession session = request.getSession();
                session.setAttribute("userNickname", nickname); // Сохраняем никнейм

                // Перенаправление на главную страницу после успешного входа
                response.sendRedirect(request.getContextPath() + "/preview.jsp");
            } else {
                request.setAttribute("message", "Неверный никнейм или пароль.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Ошибка входа: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    private boolean authenticateUser(String nickname, String hashedPassword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE nickname = ? AND hashed_password = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, nickname);
            statement.setString(2, hashedPassword);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("PostgreSQL Driver not found", e);
        }
    }
}
