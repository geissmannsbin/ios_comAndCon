//
//  ViewController.swift
//  ComAndCon
//
//  Created by Robin Geissmann on 26.10.20.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    struct Response: Codable {
        let images: [ImageInfo]
        
        let lastUpdate: Date
        let info: String
    }
    
    struct ImageInfo: Codable {
        let identifier: Int
        let title: String
        let text: String
        let url: URL
    }
    
    
    var images: [ImageInfo] = []{
        didSet {
            self.picker.reloadAllComponents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        images = loadListSync()!
        
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    
    func loadListSync() -> [ImageInfo]?{
        
        var returnValue: [ImageInfo] = []
        DispatchQueue.global().sync{
        if let url = URL(string: "https://hslu.nitschi.ch/networking/data.json") {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                do {
                    let res = try JSONDecoder().decode(Response.self, from: data)
                    print(res.images)
                    returnValue = res.images
                } catch let error {
                    print(error)
                }
               }
           }.resume()
        }}
        return returnValue
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return images[row].title
    }

    /*
    func loadImageSync(image: ImageInfo) -> UIImage? {
        
    }
    
    func loadImageAsync(image: ImageInfo, completion: @escaping (UIImage?)->Void){
        
    }
 
 */
    


}

