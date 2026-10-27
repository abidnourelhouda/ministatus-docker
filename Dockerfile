
# Étape 1 : préparation des dépendances
FROM python:3.12-slim AS builder

WORKDIR /install

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install/packages -r requirements.txt

# Étape 2 : image finale
FROM python:3.12-slim AS runtime

ARG APP_VERSION=1.0.0

ENV APP_VERSION=${APP_VERSION} \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/usr/local/lib/python3.12/site-packages

WORKDIR /app

COPY --from=builder /install/packages /usr/local

COPY app.py .

RUN useradd --create-home appuser
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
    CMD python -c "import urllib.request as u; u.urlopen('http://localhost:5000/health')"

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
