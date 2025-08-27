import java.io.*;
import java.net.*;

public class SimpleHttpServer {
    public static void main(String[] args) throws IOException {
        ServerSocket server = new ServerSocket(8080);
        System.out.println("Server started on port 8080...");

        while (true) {
            Socket client = server.accept();
            PrintWriter out = new PrintWriter(client.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(client.getInputStream()));

            String line;
            while (!(line = in.readLine()).isEmpty()) {
                System.out.println(line);
            }

            out.println("HTTP/1.1 200 OK");
            out.println("Content-Type: text/plain");
            out.println();
            out.println("Hello from EKS!");
            out.flush();
            client.close();
        }
    }
}
