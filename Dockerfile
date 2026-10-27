FROM python:3.12-slim
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION} \
PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN useradd --create-home appuser
USER appuser
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
CMD python -c "import urllib.request as u; u.urlopen('http://localhost:5000/health')"
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]