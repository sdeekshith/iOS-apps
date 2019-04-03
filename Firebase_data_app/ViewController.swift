//
//  ViewController.swift
//  Firebase_data_app
//
//  Created by IOSLevel-01 on 03/04/19.
//  Copyright © 2019 sjbit. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var fetchedDetails = [Web]()
   
    @IBOutlet weak var tableOutlet: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        parsedata()
        
    }
    func parsedata()
    {
        let url = "https://restcountries.eu/rest/v1/all"
        
        var request = URLRequest(url: URL(string:url)!)
        self.fetchedDetails = []
        
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            
            if error != nil
            {
                print(error?.localizedDescription)
            }
            else{
                do{
                    let fetcheddata = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    for eachfetchedcountry in fetcheddata
                    {
                        let eachCountry = eachfetchedcountry as! [String: Any]
                        let capital = eachCountry["capital"] as! String
                        let country = eachCountry["name"] as! String
                          let region = eachCountry["region"] as! String
                          let subregion = eachCountry["subregion"] as! String
                         let area = "\(eachCountry["area"]!)"
                        let population = "\(eachCountry["population"]!)"
    
                        self.fetchedDetails.append(Web(country: country, capital: capital, region: region, subregion: subregion, area: area, population: population))
                        
                    }
                    self.tableOutlet.reloadData()
                }
                catch{
                    print("error")
                }
            }
    }
        task.resume()


}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return fetchedDetails.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.label1.text = fetchedDetails[indexPath.row].country
        cell.label2.text = fetchedDetails[indexPath.row].capital
        cell.label3.text = fetchedDetails[indexPath.row].region
        cell.label4.text = fetchedDetails[indexPath.row].subregion
        cell.label5.text = fetchedDetails[indexPath.row].area
        cell.label6.text = fetchedDetails[indexPath.row].population
        
        return cell
    }
    
    
    @IBAction func saveTofirebase(_ sender: UIButton)
    {
        let data1 = Database.database().reference().child("Country")
        for details in fetchedDetails
        {
            let id = data1.childByAutoId().key
            let newdata1 = data1.child(id!)
            let savedata = ["CountryId" : id,"CountryName": details.country] as [String : Any]
            newdata1.setValue(savedata)
            print(details.country)
            let data2 = newdata1.child("country details")

            let id1 = data2.childByAutoId().key
            let newdata2 = data2.child(id1!)
            
            let savedata2 = ["CountryID": id, "DetailsiD": id1, "Capital":details.capital,"Population":details.population,"Area":details.area,"Region":details.region,"Subregion":details.subregion]
            newdata2.setValue(savedata2)
        }
        let alert = UIAlertController(title: "success", message: "data is now updated to firebase", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "tofirebase", sender: self)
        }
        alert.addAction(ok)
        self.present(alert, animated: true,completion: nil)
      }
}
