# Dockerfile
FROM python:3.13-slim

# Installa le dipendenze di sistema per Playwright
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

# Installa Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Installa Playwright e i browser
RUN playwright install firefox && playwright install-deps

# Copia lo script
COPY antautosurf_render.py .

# Avvia lo script
CMD ["python", "antautosurf_render.py"]
