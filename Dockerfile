# Use lightweight OpenJDK image
FROM openjdk:11-jre-slim

# Copy Java file
COPY SimpleHttpServer.java /app/SimpleHttpServer.java

# Set working directory
WORKDIR /app

# Compile Java file
RUN javac SimpleHttpServer.java

# Run the app
CMD ["java", "SimpleHttpServer"]
