package org.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class TopRecordsServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/book_platform";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "";

    public static class Record {
        private String nickname;
        private int clickCount;

        public Record(String nickname, int clickCount) {
            this.nickname = nickname;
            this.clickCount = clickCount;
        }

        public String getNickname() {
            return nickname;
        }

        public int getClickCount() {
            return clickCount;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Получаем топ-3 рекордов
            List<Record> topRecords = getTopRecords();

            // Передаем список рекордов в JSP
            request.setAttribute("topRecords", topRecords);

            // Перенаправляем запрос на JSP файл
            request.getRequestDispatcher("/records.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Ошибка при получении данных рекордов: " + e.getMessage(), e);
        }
    }

    private List<Record> getTopRecords() throws SQLException {
        List<Record> records = new ArrayList<>();

        String query = """
            SELECT
                u.nickname,
                gr.click_count
            FROM
                users u
            JOIN
                game_records gr ON u.id = gr.user_id
            WHERE
                gr.click_count = (
                    SELECT MAX(gr2.click_count)
                    FROM game_records gr2
                    WHERE gr2.user_id = gr.user_id
                )
            ORDER BY
                gr.click_count DESC
            LIMIT 3;
        """;

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                String nickname = resultSet.getString("nickname");
                int clickCount = resultSet.getInt("click_count");
                records.add(new Record(nickname, clickCount));
            }
        }

        return records;
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
