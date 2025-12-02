FROM python:3.11-alpine AS builder
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-alpine

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN adduser -D -u 1000 appuser

RUN apk add --no-cache \
      libpq \
      libxml2 \
      libxslt

COPY --from=builder /install /usr/local

COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 4000
CMD ["python", "main.py"]
