# Dockerfile
FROM python:3.13-slim

# Installa le dipendenze di sistema minime (solo quelle essenziali)
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

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Installa Firefox e salta l'installazione delle dipendenze di sistema
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
RUN playwright install firefox

# Disabilita il check delle dipendenze all'avvio
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/render/.cache/ms-playwright

COPY antautosurf_render.py .

CMD ["python", "antautosurf_render.py"]
