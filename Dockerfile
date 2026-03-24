FROM gradle:8-jdk17 AS build

WORKDIR /workspace

RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm \
    && rm -rf /var/lib/apt/lists/*

COPY gradle gradle
COPY gradlew gradlew
COPY gradlew.bat gradlew.bat
COPY build.gradle settings.gradle package.json package-lock.json ./
COPY src src
COPY data data

RUN chmod +x gradlew \
    && npm install --include=optional \
    && ./gradlew --no-daemon bootJar

FROM eclipse-temurin:17-jre

WORKDIR /app

ENV PFAS_DATA_ROOT=/app/data
ENV JAVA_TOOL_OPTIONS="-XX:+UseSerialGC -Xms256m -Xmx384m -Xss512k"

COPY --from=build /workspace/build/libs/*.jar /app/app.jar
COPY --from=build /workspace/data /app/data

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "exec java $JAVA_TOOL_OPTIONS -jar /app/app.jar"]
