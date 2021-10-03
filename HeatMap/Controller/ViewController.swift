//
//  ViewController.swift
//  HeatMap
//
//  Created by Nicky on 24/09/21.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {

    
    //MARK:- Outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var heatMapCollectionView: UICollectionView!
    
    @IBOutlet weak var allbutton: UIButton!
    @IBOutlet weak var longButton: UIButton!
    @IBOutlet weak var shortCoveringButton: UIButton!
    @IBOutlet weak var shortButton: UIButton!
    @IBOutlet weak var longUnwindingButton: UIButton!
    
    
    
    
    //MARK:- Instances
    var heatMapArray = HeatMapModel()
    var S_dataArray = [String]()
    var SC_dataArray = [String]()
    var L_dataArray = [String]()
    var LU_dataArray = [String]()

    var S_Symbol = [String]()
    var SC_Symbol = [String]()
    var L_Symbol = [String]()
    var LU_Symbol = [String]()
    
    var finalArray = [[String]]()
    
    var symbolValues = [String]()
    var percentValues = [String]()
    var selectedValue = 0
    
    var searchText = String()
    var searchActive : Bool = false
    var filteredSymbolArray = [String]()
    var filteredPercentArray = [String]()
    
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        HeatMapHelper.shared.loadJson(fromURLString: jsonUrlString) { (result) in
            switch result{
            
            case .success(let data):
                
                do{
                    let decodedData = try JSONDecoder().decode(HeatMapModel.self,
                                                               from: data)
                    
                    self.heatMapArray = decodedData
    
                    self.S_dataArray   = (self.heatMapArray.Short?.components(separatedBy: ";"))!
                    self.SC_dataArray  = (self.heatMapArray.ShortCovering?.components(separatedBy: ";"))!
                    self.L_dataArray   = (self.heatMapArray.Long?.components(separatedBy: ";"))!
                    self.LU_dataArray  = (self.heatMapArray.LongUnwinding?.components(separatedBy: ";"))!
                    
                    self.get_L_SymbolValues()
                    self.get_S_SymbolValues()
                    self.get_SC_SymbolValues()
                    self.get_LU_SymbolValues()
                    self.sortData()
                    
                }
                catch{
                    print("decode error")
                }
            case .failure(let error):
                print(error)
            
            }
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allbutton.layer.cornerRadius = allbutton.bounds.height/2
        shortButton.layer.cornerRadius = shortButton.bounds.height/2
        longButton.layer.cornerRadius = longButton.bounds.height/2
        longUnwindingButton.layer.cornerRadius = longUnwindingButton.bounds.height/2
        shortCoveringButton.layer.cornerRadius = shortCoveringButton.bounds.height/2
        
        searchView.layer.cornerRadius = searchView.bounds.height/2
        searchView.layer.masksToBounds = true
        searchView.clipsToBounds = true
    }
    
    func setUpUI(){
        print(selectedValue)
        switch selectedValue {
        case 0:
            allbutton.backgroundColor           = UIColor.systemOrange
            longButton.backgroundColor          = colorCodes.Long?.withAlphaComponent(0.3)
            shortCoveringButton.backgroundColor = colorCodes.Short_Covering?.withAlphaComponent(0.3)
            shortButton.backgroundColor         = colorCodes.Short?.withAlphaComponent(0.3)
            longUnwindingButton.backgroundColor = colorCodes.Long_Unwinding?.withAlphaComponent(0.3)
        case 1:
            allbutton.backgroundColor           = UIColor.systemOrange.withAlphaComponent(0.3)
            longButton.backgroundColor          = colorCodes.Long
            shortCoveringButton.backgroundColor = colorCodes.Short_Covering?.withAlphaComponent(0.3)
            shortButton.backgroundColor         = colorCodes.Short?.withAlphaComponent(0.3)
            longUnwindingButton.backgroundColor = colorCodes.Long_Unwinding?.withAlphaComponent(0.3)
        case 2:
            allbutton.backgroundColor           = UIColor.systemOrange.withAlphaComponent(0.3)
            longButton.backgroundColor          = colorCodes.Long?.withAlphaComponent(0.3)
            shortCoveringButton.backgroundColor = colorCodes.Short_Covering
            shortButton.backgroundColor         = colorCodes.Short?.withAlphaComponent(0.3)
            longUnwindingButton.backgroundColor = colorCodes.Long_Unwinding?.withAlphaComponent(0.3)
        case 3:
            allbutton.backgroundColor           = UIColor.systemOrange.withAlphaComponent(0.3)
            longButton.backgroundColor          = colorCodes.Long?.withAlphaComponent(0.3)
            shortCoveringButton.backgroundColor = colorCodes.Short_Covering?.withAlphaComponent(0.3)
            shortButton.backgroundColor         = colorCodes.Short
            longUnwindingButton.backgroundColor = colorCodes.Long_Unwinding?.withAlphaComponent(0.3)
        case 4:
            allbutton.backgroundColor           = UIColor.systemOrange.withAlphaComponent(0.3)
            longButton.backgroundColor          = colorCodes.Long?.withAlphaComponent(0.3)
            shortCoveringButton.backgroundColor = colorCodes.Short_Covering?.withAlphaComponent(0.3)
            shortButton.backgroundColor         = colorCodes.Short?.withAlphaComponent(0.3)
            longUnwindingButton.backgroundColor = colorCodes.Long_Unwinding
        default:
            break
        }
        
    }
    
    //MARK:- Data Sorting
    func sortData(){

        let finalArr = self.S_dataArray + self.SC_dataArray + self.L_dataArray + self.LU_dataArray
        for i in 0..<finalArr.count{
            self.finalArray.append(finalArr[i].components(separatedBy: ","))
        }
        self.finalArray.sort{($0[3]) < ($1[3])}
        self.finalData(self.finalArray)
    }
    
    func finalData(_ finalArr : [[String]]){
        self.symbolValues.removeAll()
        self.percentValues.removeAll()
        self.filteredSymbolArray.removeAll()
        self.filteredPercentArray.removeAll()
        
        for i in 0..<finalArr.count{

            let newArr = finalArr[i]
            if searchActive{
                if newArr[0] == searchText{
                    self.filteredSymbolArray.append(newArr[0])
                    self.filteredPercentArray.append(newArr[3])
                }
            }
            else{
                self.symbolValues.append(newArr[0])
                self.percentValues.append(newArr[3])
            }
        }
        
        DispatchQueue.main.async {
            self.heatMapCollectionView.reloadData()
        }
    }
    
    //MARK:- GET SYMBOL VALUES
    func get_S_SymbolValues(){
        for i in 0..<self.S_dataArray.count{
            var Array = [[String]]()
            Array.append(self.S_dataArray[i].components(separatedBy: ","))
            
            for j in 0..<Array.count{
                let new = Array[j]
               
                self.S_Symbol.append(new[0])
            }
        }
    }
    
    func get_SC_SymbolValues(){
        for i in 0..<self.SC_dataArray.count{
            var Array = [[String]]()
            Array.append(self.SC_dataArray[i].components(separatedBy: ","))
            
            for j in 0..<Array.count{
                let new = Array[j]
               
                self.SC_Symbol.append(new[0])
            }
        }
    }
    
    func get_L_SymbolValues(){
        for i in 0..<self.L_dataArray.count{
            var Array = [[String]]()
            Array.append(self.L_dataArray[i].components(separatedBy: ","))
            
            for j in 0..<Array.count{
                let new = Array[j]
               
                self.L_Symbol.append(new[0])
            }
        }
        
    }
    func get_LU_SymbolValues(){
        for i in 0..<self.LU_dataArray.count{
            var Array = [[String]]()
            Array.append(self.LU_dataArray[i].components(separatedBy: ","))
            
            for j in 0..<Array.count{
                let new = Array[j]
               
                self.LU_Symbol.append(new[0])
            }
        }
    }
    
    //MARK:- Get All Symbol Colors
    func getFinalCOlor(symbol : String) -> String {
        
        if self.L_Symbol.contains(where: { $0 == symbol}){
            return "Long"
        }
        else if self.SC_Symbol.contains(where: { $0 == symbol}){
            return "ShortCovering"
        }
        else if self.S_Symbol.contains(where: { $0 == symbol}){
            return "Short"
        }
        else if self.LU_Symbol.contains(where: { $0 == symbol}){
            return "LongUnwinding"
        }
        return String()
    }
    

    
    //MARK:- Action Method
    @IBAction func allSelected(_ sender: UIButton){
        clearSearch()
        selectedValue = 0
        self.finalArray.removeAll()
        sortData()
        setUpUI()
    }
    
    @IBAction func longSelected(_ sender: UIButton){
        clearSearch()
        selectedValue = 1
        setUpUI()
        longSelected()
    }
    
    @IBAction func shortCoveringSelected(_ sender: UIButton){
        clearSearch()
        selectedValue = 2
        setUpUI()
        shortCoveringSelected()
    }
    
    @IBAction func shortSelected(_ sender: UIButton){
        clearSearch()
        selectedValue = 3
        setUpUI()
        shortSelected()
    }
    
    @IBAction func longUnwindingSelected(_ sender: UIButton){
        clearSearch()
        selectedValue = 4
        setUpUI()
        longUnwindingSelected()
    }
    
    //MARK:- Method Call for Selected Category
    func longSelected(){
        self.finalArray.removeAll()
        for i in 0..<self.L_dataArray.count {
            self.finalArray.append(self.L_dataArray[i].components(separatedBy: ","))
        }
        finalArray.sort{($0[3]) < ($1[3])}
        self.finalData(self.finalArray)
    }
    
    func shortCoveringSelected(){
        self.finalArray.removeAll()
        for i in 0..<self.SC_dataArray.count {
            self.finalArray.append(self.SC_dataArray[i].components(separatedBy: ","))
        }
        
        finalArray.sort{($0[3]) < ($1[3])}
        self.finalData(self.finalArray)
    }
    
    func shortSelected(){
        self.finalArray.removeAll()
        for i in 0..<self.S_dataArray.count {
            self.finalArray.append(self.S_dataArray[i].components(separatedBy: ","))
        }
        finalArray.sort{($0[3]) < ($1[3])}
        self.finalData(self.finalArray)
    }
    
    func longUnwindingSelected(){
        self.finalArray.removeAll()
        for i in 0..<self.LU_dataArray.count {
            self.finalArray.append(self.LU_dataArray[i].components(separatedBy: ","))
        }
        finalArray.sort{($0[3]) < ($1[3])}
        self.finalData(self.finalArray)
    }
    
    func clearSearch(){
        searchText = ""
        searchTextField.text = ""
        searchActive = false
    }

}


//MARK:- CollectionView Methods

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(symbolValues.count)
        if searchActive{
            
            if filteredSymbolArray.isEmpty{
                self.view.makeToast("No data Found!")
            }
            else{
                return filteredSymbolArray.count
            }
            
        }
        return symbolValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heatMapCollectionViewCell", for: indexPath) as! heatMapCollectionViewCell
        

        
        if searchActive{
            cell.symbolLablel.text = self.filteredSymbolArray[indexPath.row]
            cell.priceChangePercentLabel.text = self.filteredPercentArray[indexPath.row]
        }
        else{
            cell.symbolLablel.text = self.symbolValues[indexPath.row]
            cell.priceChangePercentLabel.text = self.percentValues[indexPath.row]
        }


        cell.overlayView.backgroundColor = HeatMapHelper.shared.OverlayAlphaDown(dataCount: self.symbolValues.count, index: indexPath.row)
        
        switch selectedValue {
        case 0:
            if searchActive {
                cell.backView.backgroundColor = UIColor(named: getFinalCOlor(symbol: self.filteredSymbolArray[indexPath.row]))
            }else{
                cell.backView.backgroundColor = UIColor(named: getFinalCOlor(symbol: self.symbolValues[indexPath.row]))
   
            }
            
        case 1:
            cell.backView.backgroundColor = colorCodes.Long
        case 2:
            cell.backView.backgroundColor = colorCodes.Short_Covering
        case 3:
            cell.backView.backgroundColor = colorCodes.Short
        case 4:
            cell.backView.backgroundColor = colorCodes.Long_Unwinding
        default:
            cell.backView.backgroundColor = colorCodes.Long
        }

        if selectedValue == 0{
            cell.overlayView.isHidden = true
        }else{
            cell.overlayView.isHidden = false
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (self.heatMapCollectionView.frame.size.width)/10, height: self.heatMapCollectionView.frame.size.height/12)
        
        return CGSize(width: (self.heatMapCollectionView.frame.size.width)/5, height: 50 * screenWidthFactor)
    }
    

    
}


//MARK:- Textfield Delegate Methods
extension ViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.filteredSymbolArray.removeAll()
        self.filteredPercentArray.removeAll()
        
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0 {
            searchActive = true
            searchText = textField.text!
        }
        else
        {
            self.view.makeToast("Please input text for search.")
        }
        
        switch selectedValue {
        case 0:
            self.sortData()
        case 1:
            self.longSelected()
        case 2:
            self.shortCoveringSelected()
        case 3:
            self.shortSelected()
        case 4:
            self.longUnwindingSelected()
        default:
            break
        }
        
        heatMapCollectionView.reloadData()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var nsString:NSString = ""
        if textField.text != nil  && string != "" {
            nsString = textField.text! as NSString
            nsString = nsString.replacingCharacters(in: range, with: string) as NSString
        } else if (string == "") && textField.text != "" {
            nsString = textField.text! as NSString
            nsString = nsString.replacingCharacters(in: range, with: string) as NSString
            
        } else if (string == "") && textField.text == "" {
            textField.text = ""
        }
        
        guard textField.text != nil else { return true }
        let currentText = nsString as NSString
        if currentText.length > 100 {
            textField.text = currentText.substring(to: 100)
        }
        return currentText.length <= 100
        
    }
    
}
