# Используем официальный образ Python 3.12 (slim)
FROM python:3.12-slim

# Рабочая директория в контейнере
WORKDIR /app

# Снижает вмешательство apt в окружение и ставит нужные системные зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    ca-certificates \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Копируем файлы приложения в контейнер
COPY . /app

# Установим pip последней версии и установим зависимости из requirements.txt
# --no-cache-dir уменьшает размер слоя
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Открываем порт Streamlit (по умолчанию 8501)
EXPOSE 8501

# Переменные окружения для стабильной работы streamlit
ENV STREAMLIT_SERVER_HEADLESS=true \
    STREAMLIT_SERVER_PORT=8501 \
    STREAMLIT_SERVER_ADDRESS=0.0.0.0

# Запуск streamlit
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
