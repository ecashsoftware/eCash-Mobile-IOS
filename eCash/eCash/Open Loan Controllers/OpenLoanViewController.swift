//
//  OpenLoanViewController.swift
//  eCash
//
//  Created by Terence Williams on 8/14/18.
//  Copyright © 2018 Terence Williams. All rights reserved.
//

import UIKit

class OpenLoanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    var openLoans = [[String: Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        
        let username = UserDefaults.standard.value(forKey: "username") as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOpenLoans()
        
        // Do any additional setup after loading the view.
    }

    func getOpenLoans(){
        let endpoint: String = "https://daily.ecashsoftware.com/api/api/MobileApi/GetOpenLoans"
        guard let url = URL(string: endpoint) else {
            return
        }

        //Set HHTP Body
        let json:[String: String] = ["MobileProfileId": "4"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //Begin Making API Call
        var urlRequest = URLRequest(url: url)
        
        //Get Token
        let token = UserDefaults.standard.value(forKey: "token") as? String
        
        //Set Request Details
        urlRequest.addValue(token!, forHTTPHeaderField: "Token")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = "POST"


        let session = URLSession.shared

        let task1 = session.dataTask(with: urlRequest) { (data, response, error) -> Void in

            guard error == nil else {
                print("Error calling POST")
                return
            }

            do {
                if let data = data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let openLoansData = json["OpenLoans"] as? [[String: Any]]{
                    
                    //Get Each Loan's Data
                    for loan in openLoansData {
                        self.openLoans.append(loan)
                    }
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
            }catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task1.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openLoans.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "loan", for: indexPath) as? OpenLoansTableViewCell
        
        let loan = openLoans[indexPath.row]
        print(loan)
        
        let storeName = loan["StoreName"] as? String
        let priniple = loan["PrincipalBalance"] as? Double ?? 0.00
        let type = loan["LoanType"] as? String
        let amountDue = loan["AmountDue"] as? Double ?? 0.00
        let dueDate = loan["DueDate"] as? String
        
        cell?.storeName.text = String.init(format: "%@", storeName!)
        cell?.principleBalance.text =  String.init(format: "Principle: $ %.2f", priniple)
        cell?.loanType.text = String.init(format: "Type: %@", type!)
        cell?.amountDue.text = String.init(format: "Amount Due: $ %.2f", amountDue)
        cell?.dueDate.text = String.init(format: "Due Date: %@", dueDate!)
        
        return cell!
    }



}
