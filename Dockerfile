FROM node:20-bookworm-slim AS tailwind

WORKDIR /workspace

COPY package.json package-lock.json ./
RUN npm ci

COPY src/main/jte src/main/jte
COPY src/main/tailwind src/main/tailwind
COPY src/main/resources/static/css src/main/resources/static/css

RUN npm run build:tailwind

FROM gradle:8-jdk17 AS build

WORKDIR /workspace

COPY gradle gradle
COPY gradlew gradlew
COPY gradlew.bat gradlew.bat
COPY build.gradle settings.gradle ./
COPY src src
COPY data data
COPY --from=tailwind /workspace/src/main/resources/static/css/tailwind.css /workspace/src/main/resources/static/css/tailwind.css

RUN chmod +x gradlew \
    && ./gradlew --no-daemon bootJar -x buildTailwind

FROM eclipse-temurin:17-jre

WORKDIR /app

ENV PFAS_DATA_ROOT=/app/data
ENV JAVA_TOOL_OPTIONS="-XX:+UseSerialGC -Xms256m -Xmx384m -Xss512k"

COPY --from=build /workspace/build/libs/*.jar /app/app.jar
COPY --from=build /workspace/data /app/data
COPY --from=build /workspace/src/main/jte /app/src/main/jte

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "exec java $JAVA_TOOL_OPTIONS -jar /app/app.jar"]
