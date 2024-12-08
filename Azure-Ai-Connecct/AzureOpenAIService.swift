import Foundation

class AzureOpenAIService {
    static let shared = AzureOpenAIService()
    private init() {}

    // Load the API key from config.plist
    private let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let key = dictionary["AZURE_API_KEY"] as? String else {
            fatalError("Missing AZURE_API_KEY in config.plist")
        }
        return key
    }()

    private let endpoint = "https://access-01.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-08-01-preview" // Replace with your endpoint
    
    func sendRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let headers = [
            "Content-Type": "application/json",
            "api-key": apiKey
        ]
        
        let requestBody: [String: Any] = [
            "messages": [["role": "user", "content": prompt]],
            "max_tokens": 300,
            "temperature": 0.7
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let content = choices.first?["message"] as? [String: Any],
                   let text = content["content"] as? String {
                    completion(.success(text))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
