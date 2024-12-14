package org.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/saveResult")
public class ResultServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/book_platform";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Получение данных из сессии
        HttpSession session = request.getSession();
        String nickname = (String) session.getAttribute("userNickname");

        if (nickname == null) {
            response.sendRedirect("login.jsp"); // Если пользователь не авторизован, отправляем на логин
            return;
        }

        // Получение количества кликов из параметров запроса
        String clicksParam = request.getParameter("clicks");
        if (clicksParam == null || clicksParam.isEmpty()) {
            request.setAttribute("message", "Результаты игры недоступны.");
            request.getRequestDispatcher("result.jsp").forward(request, response);
            return;
        }

        int clicks;
        try {
            clicks = Integer.parseInt(clicksParam);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Некорректное количество кликов.");
            request.getRequestDispatcher("result.jsp").forward(request, response);
            return;
        }

        try {
            // Сохранение результата в базе данных
            saveResult(nickname, clicks);

            // Перенаправление на страницу результатов
            request.setAttribute("clicks", clicks);
            request.getRequestDispatcher("result.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Ошибка сохранения результата: " + e.getMessage());
            request.getRequestDispatcher("result.jsp").forward(request, response);
        }
    }

    private void saveResult(String nickname, int clicks) throws SQLException {
        String findUserIdQuery = "SELECT id FROM users WHERE nickname = ?";
        String checkDuplicateQuery = "SELECT COUNT(*) FROM game_records WHERE user_id = ? AND click_count = ? AND timestamp::date = CURRENT_DATE";
        String insertResultQuery = "INSERT INTO game_records (user_id, click_count, timestamp) VALUES (?, ?, CURRENT_TIMESTAMP)";

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Получение user_id по nickname
            int userId;
            try (PreparedStatement findUserIdStmt = connection.prepareStatement(findUserIdQuery)) {
                findUserIdStmt.setString(1, nickname);
                try (ResultSet resultSet = findUserIdStmt.executeQuery()) {
                    if (resultSet.next()) {
                        userId = resultSet.getInt("id");
                    } else {
                        throw new SQLException("Пользователь не найден: " + nickname);
                    }
                }
            }

            // Проверка на дубликат записи
            try (PreparedStatement checkDuplicateStmt = connection.prepareStatement(checkDuplicateQuery)) {
                checkDuplicateStmt.setInt(1, userId);
                checkDuplicateStmt.setInt(2, clicks);
                try (ResultSet resultSet = checkDuplicateStmt.executeQuery()) {
                    if (resultSet.next() && resultSet.getInt(1) > 0) {
                        // Запись уже существует, выходим
                        return;
                    }
                }
            }

            // Вставка нового результата в game_records
            try (PreparedStatement insertResultStmt = connection.prepareStatement(insertResultQuery)) {
                insertResultStmt.setInt(1, userId);
                insertResultStmt.setInt(2, clicks);
                insertResultStmt.executeUpdate();
            }
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
