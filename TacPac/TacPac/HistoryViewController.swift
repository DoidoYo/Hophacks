//
//  HistoryViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //connects barview to variable
    @IBOutlet weak var barView: BarChartView!
    //connects table view to variable
    @IBOutlet weak var tableView: UITableView!
    //array to store measurements
    var measurements : [Reading] = [Reading]()
    //segmented buttons
    @IBAction func segmentedButtonPress(_ sender: UISegmentedControl) {
        //if graph is selected
        if sender.selectedSegmentIndex == 0 {
            barView.isHidden = false
            tableView.isHidden = true
        } else {
            //if table is selected
            barView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide table
        tableView.isHidden = true
        //set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setup graph, hide axis and other stuff
        barView.xAxis.enabled = false
        barView.legend.enabled = false
        barView.leftAxis.enabled = false
        barView.rightAxis.enabled = false
        barView.chartDescription?.text = ""
        barView.highlightPerTapEnabled = false
        barView.highlightPerDragEnabled = false
        //get measurements from server
        
        FirebaseHelper.getMeasurements(completion:{
            (readings) in
        
            print(readings.count)
            
//            check measurements is not nil
                //add measurements to graph
//                for i in readings {
//                    if !self.measurements.contains(i) {
//                        self.measurements.append(i)
//                    }
//                }
            self.measurements = readings.reversed()
                //update graph
                if (readings.count > 0) {
                    self.updateChartWithData()
                    self.tableView.reloadData()
                }
            
        })
//        TacPacServer.getMeasurements(amount: 7, completion: {
//            measurements, error in
//
//            //print("Data Acquired!")
//            
//            if let err = error {
//                print(err)
//            }
//            
//            
//            //check measurements is not nil
//            if let mea = measurements {
//                //add measurements to graph
//                for i in mea {
//                    if !self.measurements.contains(i) {
//                        self.measurements.append(i)
//                    }
//                }
//                //update graph
//                if (mea.count > 0) {
//                    self.updateChartWithData()
//                    self.tableView.reloadData()
//                }
//            }
//            
//            
//        })
    }
    
    @IBAction func unwindToHistory(sender: UIStoryboardSegue)
    {
    }
    
    func updateChartWithData() {
        //update data when new is acquired
        var dataEntries: [ChartDataEntry] = []
        //
        for i in 0..<measurements.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: measurements[i].concentration)
            dataEntries.append(dataEntry)
        }
        //add values to chart
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Measurements")
        let chartData = LineChartData(dataSet: chartDataSet)
        barView.data = chartData
        //animated transition
        barView.animate(yAxisDuration: 0.1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //set table row count
        return measurements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get customt able cell
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = String(measurements[measurements.count - 1 - indexPath.row].concentration) + " ng/L"
        cell.detailTextLabel?.text = measurements[measurements.count - 1 - indexPath.row].time
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //change of screen animation
        segue.destination.hidesBottomBarWhenPushed = true
    }
    
}




