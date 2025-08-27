# Use full OpenJDK (includes javac)
FROM openjdk:11-jdk-slim

# Set working directory
WORKDIR /app

# Copy Java file
COPY SimpleHttpServer.java /app/SimpleHttpServer.java

# Compile Java
RUN javac SimpleHttpServer.java

# Run the app
CMD ["java", "SimpleHttpServer"]
