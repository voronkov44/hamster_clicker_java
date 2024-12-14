<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Игра</title>
  <link href="https://fonts.googleapis.com/css?family=Press+Start+2P" rel="stylesheet">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/index.css">
</head>
<body>
<main>
  <div id="display">Кликните на изображение!</div>
  <img id="clickableImage" src="<%= request.getContextPath() %>/photo/hamster3.png" alt="Хомяк" />
  <div id="counter">Счет: 0</div>
  <audio id="audio" src="<%= request.getContextPath() %>/audio/accompaniment.mp3" preload="auto"></audio>
</main>

<script>
  const TIMEOUT = 12000;
  const MOVE_INTERVAL = 1000; // Интервал перемещения картинки в миллисекундах

  let clicks = 0; // Счетчик кликов

  const display = document.getElementById('display');
  const clickableImage = document.getElementById('clickableImage');
  const counter = document.getElementById('counter');
  const audio = document.getElementById('audio');

  // Установка громкости аудио
  audio.volume = 0.5; // Установите уровень громкости (от 0.0 до 1.0)

  let initialPosition = { x: 0, y: 0 }; // Начальные координаты

  clickableImage.onload = () => {
    // Сохранить начальные координаты после загрузки изображения
    initialPosition.x = clickableImage.offsetLeft;
    initialPosition.y = clickableImage.offsetTop;
  };

  clickableImage.onclick = start;

  function start() {
    audio.play(); // Начать воспроизводить музыку при клике на хомяка
    const startTime = Date.now();

    display.textContent = formatTime(TIMEOUT);
    clickableImage.onclick = () => {
      clicks++;
      counter.textContent = 'Счет: ' + clicks;
    };

    const interval = setInterval(() => {
      const elapsed = Date.now() - startTime; // Время, прошедшее с начала
      const remainingTime = TIMEOUT - elapsed; // Оставшееся время
      if (remainingTime <= 0) {
        clearInterval(interval);
        endGame();
      } else {
        display.textContent = formatTime(remainingTime);
      }
    }, 100);

    const moveInterval = setInterval(() => {
      moveImageRandomly();
    }, MOVE_INTERVAL);

    const timeout = setTimeout(() => {
      clearInterval(interval);
      clearInterval(moveInterval); // Остановить перемещение при окончании игры
      endGame();
    }, TIMEOUT);
  }

  function moveImageRandomly() {
    const viewportWidth = window.innerWidth - clickableImage.clientWidth;
    const viewportHeight = window.innerHeight - clickableImage.clientHeight;

    const randomX = Math.floor(Math.random() * viewportWidth);
    const randomY = Math.floor(Math.random() * viewportHeight);

    clickableImage.style.position = 'absolute';
    clickableImage.style.left = randomX + 'px';
    clickableImage.style.top = randomY + 'px';
  }

  function endGame() {
    clickableImage.onclick = null;
    display.textContent = 'Game Over';
    audio.pause(); // Остановить музыку по окончании игры
    audio.currentTime = 0; // Сбросить время воспроизведения

    // Возвращаем изображение на начальные координаты
    clickableImage.style.position = 'absolute';
    clickableImage.style.left = initialPosition.x + 'px';
    clickableImage.style.top = initialPosition.y + 'px';

    // Перенаправление на страницу результатов
    window.location.href = `<%= request.getContextPath() %>/saveResult?clicks=${clicks}`;
  }

  function formatTime(ms) {
    return Number.parseFloat(ms / 1000).toFixed(2);
  }
</script>
</body>
</html>
