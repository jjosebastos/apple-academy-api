# ===========================
# Stage 1: Build
# ===========================
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# ===========================
# Stage 2: Runtime
# ===========================
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Render define a porta via variável de ambiente
EXPOSE 8080

# Variáveis de ambiente (com fallback default)
ENV APPLE_API_PROFILE=dev
ENV JWT_SECRET=defaultSecret

ENTRYPOINT ["java", "-jar", "app.jar"]
