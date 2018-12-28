//
//  StatSliderView.swift
//  Monthly
//
//  Created by Denis Litvin on 12/24/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import FlexLayout
import Charts

import RxSwift
import RxCocoa

protocol StatSliderViewViewModelProtocol {
    var chartData: Driver<[ChartDataEntry]>! { get }
}

extension StatSliderView: ViewModelBindable {
    func set(viewModel: StatSliderViewViewModelProtocol) {
        self.viewModel = viewModel
        setUpBindings()
    }
}

class StatSliderView: UIScrollView {
    
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    
    private var lineView: UIImageView!
    private var chartView: LineChartView!
    
    var viewModel: StatSliderViewViewModelProtocol!

    init() {
        super.init(frame: .zero)
        
        setUpViews()
        setUpLayout()
        setUpSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Animator.stopAllAnimations(view: self)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: PRIVATE
    private func setUpBindings() {
        viewModel.chartData
            .drive(onNext: { [weak self] entries in
               self?.chartView.data = LineChartData(dataSet: self?.makeChartDataSet(with: entries))
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpSelf() {
        clipsToBounds = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        backgroundColor = .clear
        isHidden = true
        
        let screenSize = UIScreen.main.bounds.size
        let contentHeight = contentView.clip.measureSize(within: CGSize(width: screenSize.width,
                                                                        height: .greatestFiniteMagnitude)).height
        contentView.frame.size = CGSize(width: screenSize.width, height: contentHeight)
        contentInset.top = max(80, screenSize.height - contentHeight - 80)
        frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
        transform = CGAffineTransform(translationX: 0, y: frame.height)
        
        let layer = CAGradientLayer.Elements.slider
        layer.cornerRadius = 35
        layer.frame.size = CGSize(width: screenSize.width, height: contentHeight + screenSize.height)
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    private func setUpLayout() {
        contentView.clip.enable().withDistribution(.column)
        self.addSubview(contentView)
        
        lineView.clip.enable().insetTop(16).insetBottom(17)
        contentView.addSubview(lineView)
        
        let paddingsContainer = UIView()
        paddingsContainer.clip.enable().withDistribution(.column)
            .insetLeft(40).insetRight(40).insetBottom(80)
        contentView.addSubview(paddingsContainer)
        
        chartView.clip.enable()
            .withHeight(UIScreen.main.bounds.width * 0.9)
            .horizontallyAligned(.stretch)
        paddingsContainer.addSubview(chartView)
    }
   
    private func makeMockData() -> LineChartData {
        let values = ([0,10,20,10, 10, 10, 50, 40]).map { (i) -> ChartDataEntry in
            let val = Double(3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: nil)
        set1.drawIconsEnabled = false
        
        set1.setColor(UIColor.Elements.chartGraph)
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.drawValuesEnabled = false
        set1.mode = .cubicBezier
        set1.form = .none
        
        let gradientColors = [UIColor.white.cgColor,
                              UIColor.Elements.chartGraph.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 0.2
        
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        set1.lineCapType = .round
        return LineChartData(dataSet: set1)
    }
    
    private func setUpViews() {
        lineView = UIImageView(image: #imageLiteral(resourceName: "line"))
        
        chartView = {
            let chartView = LineChartView()
            chartView.clipsToBounds = true
            chartView.layer.cornerRadius = 20
//            chartView.gridBackgroundColor = .clear
            
            let leftAxis = chartView.leftAxis
            leftAxis.labelTextColor = .lightGray
            leftAxis.drawAxisLineEnabled = false
            leftAxis.gridLineWidth = 5
            leftAxis.gridLineCap = .round
            leftAxis.gridColor = UIColor.Elements.chartBackground

            let rightAxis = chartView.rightAxis
            rightAxis.drawLabelsEnabled = false
            rightAxis.drawLimitLinesBehindDataEnabled = false
            rightAxis.drawGridLinesEnabled = false
            rightAxis.drawAxisLineEnabled = false
            rightAxis.gridLineWidth = 5
            rightAxis.gridLineCap = .round
            rightAxis.gridColor = UIColor.Elements.chartBackground
            rightAxis.drawGridLinesEnabled = true
            
            let xAxis = chartView.xAxis
            xAxis.drawGridLinesEnabled = false
            xAxis.centerAxisLabelsEnabled = false
            xAxis.drawAxisLineEnabled = false
            xAxis.drawLimitLinesBehindDataEnabled = false
            xAxis.labelTextColor = .gray
            xAxis.gridLineCap = .round
            xAxis.labelFont = UIFont.dynamic(8, family: .avenir).bolded
            xAxis.labelPosition = .bottom
            xAxis.valueFormatter = DateValueFormatter()
            xAxis.labelCount = 4
            chartView.backgroundColor = .white
            //todo
//            fetchData(closure: { (data) in
//                chartView.data = data
//            })
            return chartView
        }()
    }
    private func makeChartDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
            let set = LineChartDataSet(values: entries, label: nil)
            set.drawIconsEnabled = false
            
            set.setColor(UIColor.Elements.chartGraph)
            set.drawCirclesEnabled = false
            set.lineWidth = 3
            set.drawValuesEnabled = false
            set.mode = .cubicBezier
            set.form = .none
            
            let gradientColors = [UIColor.white.cgColor,
                                  UIColor.Elements.chartGraph.cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set.fillAlpha = 0.2
            
            set.fill = Fill(linearGradient: gradient, angle: 90)
            set.drawFilledEnabled = true
            set.lineCapType = .round
            return set
    }
}

final class DateValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return formatter.string(from: Date(timeIntervalSince1970: value))
    }
    
    
    private lazy var formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
//    private lazy var calendar = Calendar.current
//
//    func stringForValue(_ value: Double,
//                        entry: ChartDataEntry,
//                        dataSetIndex: Int,
//                        viewPortHandler: ViewPortHandler?) -> String {
//        if value == entry.x {
//            return formatter.string(from: Date(timeIntervalSince1970: value))
//        }
//        return "\(value)"
//    }
    
    
}
