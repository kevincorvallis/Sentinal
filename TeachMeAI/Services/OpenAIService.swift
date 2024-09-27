import Foundation

struct OpenAIService {
    // Load API Key from secrets.plist
    private var apiKey: String? {
        guard let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            print("Failed to load API Key from environment.")
            return nil
        }
        return key
    }


    // Function to send a message to the OpenAI API
    func sendMessageToAPI(message: String, completion: @escaping (String?) -> Void) {
        // Ensure the API key exists
        guard let apiKey = apiKey else {
            print("API Key is missing.")
            completion(nil)
            return
        }

        // OpenAI API URL for chat completions
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build the request body
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",  // Use the model available in your API plan
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": message]
            ],
            "max_tokens": 150  // You can adjust the token limit
        ]

        // Encode the body as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Failed to encode request body: \(error.localizedDescription)")
            completion(nil)
            return
        }

        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors in the request itself
            if let error = error {
                print("Error during network request: \(error.localizedDescription)")
                completion(nil)
                return
            }

            // Check if the HTTP response has a valid status code
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Received non-200 response: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }

            // Ensure we received data
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }

            // Log the raw response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw API response: \(rawResponse)")
            }

            // Decode the response
            do {
                let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                completion(result.choices.first?.message.content)
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                completion(nil)
            }
        }

        // Start the task
        task.resume()
    }
}

// Define the response structure
struct OpenAIResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: MessageContent
    }

    struct MessageContent: Codable {
        let content: String
    }
}
