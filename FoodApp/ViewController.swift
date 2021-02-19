//
//  ViewController.swift
//  FoodApp
//
//  Created by Dayal N D on 17/02/21.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {




@IBOutlet weak var collectionViewmain: UICollectionView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var searchText: UITextField!
    
private var apiService = ApiService()
var arrayCat = [CategoryArray]()
var menuarray = [String : AnyObject]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
        self.collectionViewmain.dataSource = self
        self.collectionViewmain.delegate = self
        
    }
    
    
    
private func loadCategoryData() {
         
         // Fetch data from the server
        apiService.getCategoryApiData { [weak self] (result) in
             
            switch result {
            case .success(let cata):
            self!.arrayCat = cata.categoryarray
            print(self!.arrayCat)
            self!.collectionViewmain.reloadData()
            //self!.saveDataOf(categoryarray: listOf.categoryarray)
            case .failure(let error):
                print("Error processing json data: \(error)")
                }
        }
}


       

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of items
    
    return arrayCat.count
       
}
    
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}

    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionViewmain.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    
    let catago = arrayCat[indexPath.row]
    cell.label.text = catago.strCategory
    let imageUrlString = catago.strCategoryThumb
    cell.image.loadImageUsingUrlString(urlString: imageUrlString!)
    
    return cell
    
}
    
    
@IBAction func buttonAction(_ sender: Any) {
        getMethod2()
}
    

func getMethod2(){

                
    let urlstring = "https://www.themealdb.com/api/json/v1/1/search.php?f=" + searchText.text!
                let urlString = URL(string: urlstring )
                
                print ( "\(String(describing: urlString))" )
                
                if let url = urlString {
                 
                    let task = URLSession.shared.dataTask(with: url)
                    { (data, response, error)
                        in
                        if error != nil {
                            print(error!)
                        } else {
                            if let usableData = data {
                                
                                do{
                                    let json = try JSONSerialization.jsonObject(with: usableData, options:.allowFragments) as! [String : AnyObject]
        
                                    OperationQueue.main.addOperation({
                                        
                                        print(json)

                                        DispatchQueue.main.async {
                  
                                         self.menuarray = json
                                         
                                        print("FULL2=\(self.menuarray)")
                                         

                                            if json["photoList"] != nil {

                                               self.performSegue(withIdentifier: "photowebfftt", sender: self)
                                               
                                            }else{
                                               
                                               let alert = UIAlertController.init(title: "Search Complete", message: "Please Reselect", preferredStyle: UIAlertController.Style.alert)
                                               alert.addAction(UIAlertAction.init(title: "Back", style: UIAlertAction.Style.default, handler: { _ in
                                                   alert.resignFirstResponder()
                                                   
                                               }))
                                               
                                               self.present(alert,animated: true,completion:  nil)
                                                
                                            }

                                        }
             })
                                    
                                }catch let error as NSError{
                                    print(error)
                                }
                                
                                
                                print(usableData)
                            }
                        }
                    }
                    
                    
                    task.resume()
                    
                }
                
    }
    
    
    
    
    
    
    
    
    
    
}







let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String)  {
        let url = NSURL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage{
            
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler:
            { (data, respones, error) in
                if error != nil {
                    
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async(){
                    
                    let imageToCache = UIImage(data: data!)
                    
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                    
                    self.image = imageToCache
                }
                
            }).resume()
    }
   
}
