# ===========================
# Stage 1: Build
# ===========================
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Define diretório de trabalho
WORKDIR /app

# Copia o arquivo pom.xml e baixa dependências
COPY pom.xml .
COPY src ./src

# Gera o JAR
RUN mvn clean package -DskipTests

# ===========================
# Stage 2: Runtime
# ===========================
FROM eclipse-temurin:17-jdk-jammy

# Define diretório de trabalho
WORKDIR /app

# Copia o jar gerado do build
COPY --from=build /app/target/*.jar app.jar

# Porta exposta (a mesma do application.properties)
EXPOSE 8080

# Variáveis de ambiente (com fallback default)
ENV APPLE_API_PROFILE=dev
ENV JWT_SECRET=defaultSecret

# Executa a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
