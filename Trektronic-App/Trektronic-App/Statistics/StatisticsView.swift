//
//  StatisticsView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 18.06.23.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    
    @ObservedObject var vm: StatisticsViewModel = StatisticsViewModel()
    
    @State var selectedTab = "Шаги"
    var tabs = ["Шаги", "Дистанция"]
    
    var body: some View {
       
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    HStack {
                        VStack {
                            Text("Всего")
                            Text("\(Int(vm.steps))")
                        }
                        .padding(.trailing, 36)
                        VStack {
                            Text("Дистанция")
                            Text("\(Int(vm.distance))")
                        }
                        
                    }
                    .padding(.vertical, 24)
                    
                    
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 35.0)
                            .shadow(radius: 25)
                            .opacity(0.20)
                            .foregroundColor(Color.gray)
                        Circle()
                            .stroke(lineWidth: 35.0)
                            .shadow(radius: 25)
                            .opacity(0.20)
                            .foregroundColor(Color.green)
                            .frame(width: 150, height: 150)
                        
                        Text("\(Int(vm.steps))")
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(vm.steps, (Float(vm.steps) * 0.0001))))
                            .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.red)
                            .rotationEffect(Angle(degrees: 270))
                          //  .animation(.easeInOut(duration: 1.0)) // withAnimation
                        
                    }
                    .frame(width: 200, height: 200)
                    .padding(20)
                    .padding(.vertical, 24)
                    
                    Text("График")
                        .padding(.vertical, 24)
                    
                    Picker("charts", selection: $selectedTab) {
                        ForEach(tabs, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                
                    
                    Chart {
                        ForEach(vm.stepsWeek) { stepWeek in
                            
                            RuleMark(y: .value("Цель", 10000))
                                .foregroundStyle(.green)
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                            
                            
                            BarMark(
                                x: .value("День недели", stepWeek.date, unit: .day),
                                y: .value("Шаги",  stepWeek.count)
                            )
                            .foregroundStyle(Color.purple)
                            .cornerRadius(.greatestFiniteMagnitude)
                            
                            
                            
                        }
                        
                    }
                    .padding(.vertical, 24)
                    .frame(height: 350)
                    .chartXAxis {
                        AxisMarks(values: vm.stepsWeek.map { $0.date }) { date in
                            //AxisGridLine()
                            //AxisTick()
                            AxisValueLabel(format: .dateTime.weekday())
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) {
                            AxisValueLabel()
                            //AxisGridLine()
                        }
                    }
                    
                    
                }
                .padding(.horizontal, 24)
            }
            .onAppear {
                vm.calculateData()
            }
            .navigationTitle("Статистика")
        }
        
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
