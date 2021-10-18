//
//  SearchVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 18.10.2021.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var userList = Array<UserData>()
    var searchedUser = UserData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged), for: .editingChanged)
        
        /*Recognizer For Hide Keyboard
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGestureRecognizer)*/
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if userList[indexPath.row].userName != "User not found"{
            cell.textLabel?.text = "Go to @"+userList[indexPath.row].userName
        }
        else{
            cell.textLabel?.text = userList[indexPath.row].userName
        }
        return cell
    }
    
    @objc func searchTextFieldChanged(){

    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        let user = User()
        user.getUsersBySearchText(searchText: searchTextField.text!) { users, message in
            if message == "Success"{
                self.userList.removeAll(keepingCapacity: false)
                self.userList = users
                
                if users.isEmpty {
                    self.userList.append(UserData.init(documentId: "", userId: "", userName: "User not found", email: "", password: "", sex: ""))
                }
                
                self.searchResultTableView.reloadData()
            }
        }
        view.endEditing(true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.userList.removeAll(keepingCapacity: false)
        self.searchTextField.text = ""
        self.searchResultTableView.reloadData()
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchedUser = userList[indexPath.row]
        performSegue(withIdentifier: "toAccountVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAccountVC"{
            if let VC = segue.destination as? AccountVC{
                VC.searchedUser = self.searchedUser
            }
        }
    }
}
