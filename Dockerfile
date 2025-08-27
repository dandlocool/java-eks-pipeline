# Use OpenJDK 11 slim image
FROM openjdk:11-jdk-slim

# Set working directory
WORKDIR /app

# Copy Java source file
COPY SimpleHttpServer.java .

# Compile Java file
RUN javac SimpleHttpServer.java

# Run Java application
CMD ["java", "SimpleHttpServer"]
