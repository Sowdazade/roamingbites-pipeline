FROM python:3.12-slim AS lint
WORKDIR /app
COPY app.html .
RUN pip install flake8 && flake8 app.html --ignore=E501

FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.html .

FROM python:3.12-slim AS production
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /app/app.html /app/app.html
EXPOSE 5000
CMD ["python", "app.html"]
