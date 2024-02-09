//
//  ViewController.swift
//  StopWatch
//
//  Created by Emre Sağıroğlu on 8.02.2024.
//

import UIKit

class HomeScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var timer = Timer()
    var milliseconds = 0
    var isTimerRunning = false
    var lapList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        // table view delegate & datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // add subviews
        view.addSubview(topView)
        view.addSubview(tableView)
        topView.addSubview(mainLabel)
        topView.addSubview(mainTimeLabel)
        topView.addSubview(lapButton)
        topView.addSubview(startStopButton)
        
        
        // initial calls
        updateLabel()
        setupConstraints()
        
        
    }
    
    // updating Time Label every 0.1 second
    func updateLabel() {
        let minutes = (milliseconds / 60000) % 60
        let seconds = (milliseconds / 1000) % 60
        let millisecondsPart = (milliseconds % 1000) / 100
        mainTimeLabel.text = String(format: "%02d:%02d,%01d", minutes, seconds, millisecondsPart)
    }

    private let topView : UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    private let mainLabel : UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Stop Watch"
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont.boldSystemFont(ofSize: 30)
        return mainLabel
    }()
    
    private let mainTimeLabel : UILabel = {
        let mainTimeLabel = UILabel()
        mainTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTimeLabel.textAlignment = .center
        mainTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50, weight: .semibold)
        return mainTimeLabel
    }()
    
    private let lapButton : UIButton = {
        let lapButton = UIButton()
        lapButton.translatesAutoresizingMaskIntoConstraints = false
        lapButton.setTitle("Lap", for: .normal)
        lapButton.backgroundColor = .systemGray
        lapButton.layer.cornerRadius = 10
        lapButton.addTarget(self, action: #selector(lapClicked), for: .touchUpInside)
        return lapButton
    }()
    
    private let startStopButton : UIButton = {
        let startStopButton = UIButton()
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.backgroundColor = .systemBlue
        startStopButton.layer.cornerRadius = 10
        startStopButton.addTarget(self, action: #selector(startStopButtonClicked), for: .touchUpInside)
        return startStopButton
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray3
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    // Start Stop Button controls
    @objc func startStopButtonClicked(){
        
        // if timer is not running
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            startStopButton.setTitle("Stop", for: .normal)
            lapButton.setTitle("Lap", for: .normal)
          
            startStopButton.backgroundColor = .systemRed
        }
        // if timer is running
        else {
            timer.invalidate()
            isTimerRunning = false
            startStopButton.setTitle("Start", for: .normal)
            lapButton.setTitle("Reset", for: .normal)
            startStopButton.backgroundColor = .systemBlue
        }
    }
    
    // It's called from Timer object every 0.1 seconds
    @objc func updateTimer() {
        milliseconds += 100
        updateLabel()
    }
    
    // Lap button controls
    @objc func lapClicked() {
        
        //if timer is not running
        if !isTimerRunning {
            milliseconds = 0
            lapList = []
            tableView.reloadData()
            updateLabel()
        }
        
        // if timer is running
        else {
            lapList.insert(mainTimeLabel.text!, at: 0)
            tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = .systemGray3
        cell.textLabel?.text = lapList[indexPath.row]
        return cell
    }
    
    
    
    // constraints
    func setupConstraints () {
        var constraints = [NSLayoutConstraint]()
        
        // topView constraints
        constraints.append(topView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45))
        
        // Stop Watch Label constraints
        constraints.append(mainLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor))
        constraints.append(mainLabel.topAnchor.constraint(equalTo: topView.topAnchor,constant: 60))
        
        // Time Label constraints
        constraints.append(mainTimeLabel.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.2))
        constraints.append(mainTimeLabel.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.7))
        constraints.append(mainTimeLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor))
        constraints.append(mainTimeLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor))
        
        // Lap Button constraints
        constraints.append(lapButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 30))
        constraints.append(lapButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10))
        constraints.append(lapButton.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.1))
        constraints.append(lapButton.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.3))
        
        
        // Start stop button constraints
        constraints.append(startStopButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -30))
        constraints.append(startStopButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10))
        constraints.append(startStopButton.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.1))
        constraints.append(startStopButton.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.3))
        
        
        // Table View constraints
        constraints.append(tableView.topAnchor.constraint(equalTo: topView.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        
        
        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    
}

