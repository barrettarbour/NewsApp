//
//  ArticleViewController.swift
//  NewsApp
//
//  Created by Barrett on 2020-05-30.
//  Copyright © 2020 Barrett Arbour. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var authourLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var article:Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headlineLabel.text = article?.title?.uppercased()
        authourLabel.text = article?.author
        contentLabel.text = article?.content
        
        fetchImage(urlString: (article?.urlToImage)!) { image in
            self.newsImageView.image = image
        }
        
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
