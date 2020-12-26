//
//  ViewController.swift
//  NewsApp
//
//  Created by Barrett on 2020-05-29.
//  Copyright © 2020 Barrett Arbour. All rights reserved.
//

import UIKit

//protocol imports
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: PROPERTIES
    @IBOutlet weak var NewsTableView: UITableView!
    var feed = NewsFeed()
    var imgs = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonParse {
            self.NewsTableView.reloadData()
            print(self.feed.totalResults)
        }
        
        
        //table view stuff
        NewsTableView.dataSource = self
        NewsTableView.delegate = self
    }
    
    //MARK: TABLEVIEW DELEGATE AND DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.totalResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        cell.headlineLabel?.text = feed.articles![indexPath.row].title?.uppercased()
        
        fetchImage(urlString: feed.articles![indexPath.row].urlToImage!) { image in
            cell.newsImageView?.image = image
            self.imgs = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticleViewController {
            destination.article = feed.articles![NewsTableView.indexPathForSelectedRow!.row]
            
            print(feed.articles![0])
            //recalling closure for image fetch
            
            //print(feed.articles![NewsTableView.indexPathForSelectedRow!.row].urlToImage!)
        }
    }
    
    //MARK: JSON PARSE FOR NEWS API
    
    //parameter closure with escaping protocol
    private func jsonParse(completed: @escaping () -> ()) {
        //hit the API endpoint
        
        //EDIT: had to add s to the end of http, to satisfy iOS 9 secure connection.
        let urlString = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=f3d1d08d78df4e11a2ff6f651def538e"
        
        let url = URL(string: urlString)
        
        //URL check before proceeding
        guard url != nil else {
            return
        }
        
        let session  = URLSession.shared

        //forced unwrap plus closure
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            //check for errors
            if error == nil && data != nil {
                
                //Parse JSON
                let decoder = JSONDecoder()
                
                do {
                    let newsFeed = try decoder.decode(NewsFeed.self, from: data!)
                    
                    self.feed = newsFeed //assigning decoded data to instance variable
                    
                    //completed data call closure once data is obtained
                    DispatchQueue.main.async {
                        completed()
                    }
                    
                } catch {
                    print("Error in JSON Parsing")
                }
            }
        }
        
        dataTask.resume()
    }
    
    //MARK: IMAGE FETCH AND DISPLAY FROM URL
    
    private func fetchImage(urlString: String, completed: @escaping (_ image: UIImage) -> ())
    {
        let url = URL(string: urlString)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)!
                    
                    DispatchQueue.main.async {
                        completed(image)
                    }
                }
            }
        }
        dataTask.resume()
            
    }
}

