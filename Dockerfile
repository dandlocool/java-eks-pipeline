# Use full JDK to compile Java
FROM openjdk:11-jdk-slim

WORKDIR /app

# Copy Java file
COPY SimpleHttpServer.java /app/SimpleHttpServer.java

# Compile
RUN javac SimpleHttpServer.java

# Run the app
CMD ["java", "SimpleHttpServer"]
