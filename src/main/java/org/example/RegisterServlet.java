package org.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class RegisterServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/book_platform";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Установить кодировку для получения данных
        request.setCharacterEncoding("UTF-8");

        // Получение данных из формы
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");

        if (name == null || surname == null || nickname == null || password == null ||
                name.isEmpty() || surname.isEmpty() || nickname.isEmpty() || password.isEmpty()) {
            request.setAttribute("message", "Все поля должны быть заполнены.");
            request.getRequestDispatcher("/registerLogin.jsp").forward(request, response);
            return;
        }

        // Хэширование пароля
        String hashedPassword = hashPassword(password);
        if (hashedPassword == null) {
            request.setAttribute("message", "Ошибка при обработке пароля.");
            request.getRequestDispatcher("/registerLogin.jsp").forward(request, response);
            return;
        }

        try {
            if (isNicknameTaken(nickname)) {
                // Никнейм уже существует
                request.setAttribute("message", "Никнейм \"" + nickname + "\" уже занят.");
            } else {
                // Сохранение данных в базу
                saveToDatabase(name, surname, nickname, hashedPassword);
                request.setAttribute("message", "Регистрация прошла успешно!");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Ошибка регистрации: " + e.getMessage());
        }

        request.getRequestDispatcher("/registerLogin.jsp").forward(request, response);
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

    private boolean isNicknameTaken(String nickname) throws SQLException {
        String checkNicknameQuery = "SELECT COUNT(*) FROM users WHERE nickname = ?";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement statement = connection.prepareStatement(checkNicknameQuery)) {

            statement.setString(1, nickname);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0; // Возвращаем true, если такой никнейм существует
                }
            }
        }
        return false;
    }

    private void saveToDatabase(String name, String surname, String nickname, String hashedPassword) throws SQLException {
        String sql = "INSERT INTO users (name, surname, nickname, hashed_password) VALUES (?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, name);
            statement.setString(2, surname);
            statement.setString(3, nickname);
            statement.setString(4, hashedPassword);
            statement.executeUpdate();
        }
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
