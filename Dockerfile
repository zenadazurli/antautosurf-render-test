# Dockerfile
FROM python:3.13-slim

# Installa le dipendenze di sistema necessarie per Playwright
RUN apt-get update && apt-get install -y \
    libnss3 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxshmfence1 \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils \
    libnspr4 \
    libxss1 \
    libxtst6 \
    libatk-bridge2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file dei requisiti e installa le dipendenze Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Installa Playwright e i browser
RUN playwright install firefox

# Copia il resto del codice
COPY antautosurf_render.py .

# Comando per avviare l'applicazione
CMD ["python", "antautosurf_render.py"]
