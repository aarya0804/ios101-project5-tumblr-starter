//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [Post] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 260
        fetchPosts()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return posts.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        
        cell.summaryLabel.text = post.summary
        
        if let photo = post.photos.first {
            let url = photo.originalSize.url
            ImagePipeline.shared.loadImage(with: url) { result in
                switch result {
                case .success(let response):
                    cell.postImageView.image = response.image
                case .failure:
                    cell.postImageView.image = nil
                }
            }
        } else {
            cell.postImageView.image = nil
        }
        return cell
    }



    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.posts = blog.response.posts

                    self.tableView.reloadData()

                    print("✅ We got \(self.posts.count) posts; reloaded table.")
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
