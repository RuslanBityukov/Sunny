//
//  ViewController.swift
//  Sunny
//
//  Created by Руслан Битюков on 22.12.2022.
//

import UIKit

protocol WeatherSearchTableViewControllerDelegate {
    func getCity(city: String)
}

class WeatherDisplayViewController: UIViewController {
    
    @IBOutlet weak var weaterImage: UIImageView!
    @IBOutlet weak var temperatyreCityLabel: UILabel!
    
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var weater: Weater!
    var city: String?
    var saveCityWeaters: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dowloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC = segue.destination as? WeatherSearchTableViewController else { return }
        settingVC.saveCityWeaters = saveCityWeaters
    }
    
    @IBAction func showWeater(_ sender: UIBarButtonItem) {
        showAlert(with: "What city do you want to find?", and: nil)
    }
    
    
    @IBAction func saveCity(_ sender: UIBarButtonItem) {
        StorageManager.shared.save(weater.name) { city in
            saveCityWeaters.append(city)
        }
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        guard let settingVC = segue.source as? WeatherSearchTableViewController else { return }
        settingVC.delegate = self
    }
    
    private func dowloadData() {
        NetworkManager.shared.fetch(dataType: Weater.self, from: NetworkManager.shared.nameCity(forCity: city ?? "Moscow")) { result in
            switch result {case .success(let current):
                self.updateUI(weater: current)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateUI(weater: Weater) {
        self.weater = weater
        
        self.title = weater.name
        self.weaterImage.image = UIImage(named: weater.weather.first?.idIconString ?? "clear")
        self.temperatyreCityLabel.text = "\(String(Int(weater.main.temp)))°C"
        self.minimumTemperatureLabel.text = "Minimum temperature: \(String(Int(weater.main.tempMin))) °C"
        self.maximumTemperatureLabel.text = "Maximum temperature: \(String(Int(weater.main.tempMax))) °C"
        self.humidityLabel.text = "Humidity: \(String(Int(weater.main.humidity))) %"
        self.cloudinessLabel.text = "Cloudiness: \(String(Int(weater.clouds.all))) %"
        self.windSpeedLabel.text = "Wind speed: \(String(Int(weater.wind.speed))) m/с"
    }
}

// MARK: - Delegate method implementation

extension WeatherDisplayViewController: WeatherSearchTableViewControllerDelegate {
    func getCity(city: String) {
        self.city = city
        dowloadData()
    }
}

// MARK: - Alert controller

extension WeatherDisplayViewController {
    
    private func showAlert(with title: String?, and message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Ок", style: .default) { _ in
            guard let cityName = alert.textFields?.first?.text else { return }
            guard !cityName.isEmpty else { return }
            
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                self.city = city
                self.dowloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Enter the name of the city"
        }
        present(alert, animated: true)
    }
}


