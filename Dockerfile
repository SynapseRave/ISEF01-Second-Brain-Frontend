# Stage 1: Build Flutter web app
FROM debian:bookworm-slim AS builder

ARG FLUTTER_VERSION=stable
ARG API_BASE_URL=""
ARG KEYCLOAK_URL=""
ARG KEYCLOAK_REALM=""
ARG KEYCLOAK_CLIENT_ID=""

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone --depth 1 --branch ${FLUTTER_VERSION} \
    https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-cache Flutter web artifacts
RUN flutter precache --web

WORKDIR /app

# Copy dependency files first for layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source
COPY . .

# Build web
RUN flutter build web --release \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=KEYCLOAK_URL=${KEYCLOAK_URL} \
    --dart-define=KEYCLOAK_REALM=${KEYCLOAK_REALM} \
    --dart-define=KEYCLOAK_CLIENT_ID=${KEYCLOAK_CLIENT_ID}

# Stage 2: Serve with Nginx
FROM nginx:alpine AS runtime

# Copy built web app
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
