# Use Maven with OpenJDK 11 as base image
FROM maven:3.8-openjdk-11-slim

# Set working directory
WORKDIR /app

# Copy the pom.xml file
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the rest of the application
COPY src ./src/

# Create data directory
RUN mkdir -p /app/src/main/resources/data

# Build the application
RUN mvn clean package -DskipTests

# Use a smaller JRE image for runtime
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=0 /app/target/stock-recommender.war ./app.war
COPY --from=0 /app/src/main/resources/data /app/src/main/resources/data

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.war"] 