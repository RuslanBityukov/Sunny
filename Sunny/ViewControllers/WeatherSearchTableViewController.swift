//
//  WeatherSearchTableViewController.swift
//  Sunny
//
//  Created by Руслан Битюков on 22.12.2022.
//

import UIKit

class WeatherSearchTableViewController: UITableViewController {
    
    var saveCityWeaters: [City] = []
    var delegate: WeatherSearchTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        fetchData()
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        saveCityWeaters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCity", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let city = saveCityWeaters[indexPath.row]
        content.text = city.cityName
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let city = saveCityWeaters[indexPath.row]
        delegate.getCity(city: city.cityName ?? "")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let city = saveCityWeaters[indexPath.row]
        
        if editingStyle == .delete {
            saveCityWeaters.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(city)
        }
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let city):
                self.saveCityWeaters = city
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
