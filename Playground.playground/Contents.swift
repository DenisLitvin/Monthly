import UIKit
import Charts
import FlexLayout
import PlaygroundSupport

let gray = UIColor(red: 246/255, green: 247/255, blue: 246/255, alpha: 1)

class View: UIView {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let chartView = LineChartView()

let leftAxis = chartView.leftAxis
leftAxis.labelTextColor = .lightGray
leftAxis.drawAxisLineEnabled = false
leftAxis.gridLineWidth = 3
leftAxis.gridLineCap = .round
leftAxis.gridColor = gray

let rightAxis = chartView.rightAxis
rightAxis.drawLabelsEnabled = false
rightAxis.drawLimitLinesBehindDataEnabled = false
rightAxis.drawGridLinesEnabled = false
rightAxis.drawAxisLineEnabled = false
rightAxis.gridLineCap = .round
rightAxis.drawGridLinesEnabled = true

let xAxis = chartView.xAxis
xAxis.drawGridLinesEnabled = false
xAxis.centerAxisLabelsEnabled = false
xAxis.drawAxisLineEnabled = false
xAxis.drawLimitLinesBehindDataEnabled = false
xAxis.labelTextColor = .gray
xAxis.gridLineCap = .round

xAxis.labelPosition = .bottom

chartView.backgroundColor = .white

let values = (0..<20).map { (i) -> ChartDataEntry in
    let val = Double(arc4random_uniform(20) + 3)
    return ChartDataEntry(x: Double(i), y: val)
}

let set1 = LineChartDataSet(values: values, label: "DataSet 1")
set1.drawIconsEnabled = false

set1.setColor(.blue)
set1.setCircleColor(.black)
set1.drawCirclesEnabled = false
set1.lineWidth = 3
set1.drawValuesEnabled = false
set1.circleRadius = 3
set1.drawCircleHoleEnabled = false
set1.mode = .cubicBezier
set1.formLineWidth = 1
set1.form = .none

let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                      UIColor.blue.cgColor]
let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

set1.fillAlpha = 0.2

set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
set1.drawFilledEnabled = true
set1.lineCapType = .round
let data = LineChartData(dataSet: set1)

chartView.data = data

chartView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)


PlaygroundPage.current.liveView = chartView
