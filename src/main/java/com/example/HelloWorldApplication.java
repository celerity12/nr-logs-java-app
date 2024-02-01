package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

@SpringBootApplication
@RestController
@RequestMapping("/api")
public class HelloWorldApplication {

    public static void main(String[] args) {
        SpringApplication.run(HelloWorldApplication.class, args);
    }

    @GetMapping("/hello")
    public String helloWorld() throws IOException {
        return hw(); //  + callEndpoint();   TESTING
    }

    private String hw() {
        return "Hello, Java World! from self + another service called --- " + this.toString() + " ---- ";
    }

    public static String callEndpoint() throws IOException {
        // Create a URL object with the endpoint URL
        URL url = new URL("http://host.docker.internal:9136/api/hello");

        // Open a connection to the URL
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        // Set the request method
        connection.setRequestMethod("GET");
        connection.setRequestProperty("Content-Type", "application/json");

        int responseCode = connection.getResponseCode();
        System.out.println("Response Code: " + responseCode);

        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();

        // Close the connection
        connection.disconnect();

        // Return the response as a string
        return response.toString();
    }

    @GetMapping("/hw") // this works
    public String hwSelf() throws IOException {
        return "Hello, Java World! from Self  ---  ";
    }
    // Other API endpoints can be added here

    @GetMapping("/call-api") // this works
    public String callApi() {
        String apiKey = "04VY7EOG9W9F6RQG";
        String symbol = "AAPL";
        String url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=" + symbol
                + "&apikey=" + apiKey;

        // Perform the API call and return the result
        // You can use a library like RestTemplate or HttpClient to make the API call
        // Example using RestTemplate:
        RestTemplate restTemplate = new RestTemplate();
        String result = restTemplate.getForObject(url, String.class);

        String apiUrl = "http://host.docker.internal:8135/weatherforecast";
        String response = callWeatherApi(apiUrl);

        return result + " -------------------------------- DOT NET: -------------------------------- " + response;
    }

    private String callWeatherApi(String apiUrl) {
        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.getForObject(apiUrl, String.class);
        return response;
    }
}
