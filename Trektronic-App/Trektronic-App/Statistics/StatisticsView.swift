//
//  StatisticsView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 18.06.23.
//

import SwiftUI
import Charts

struct valueView: View {
    
    var name: String
    var color: Color
    var data: String
    
    var body: some View {
        
        VStack {
            Text(name)
            Spacer()
            Text(data)
        }
        
        .padding(.horizontal, 45)
        .padding(.vertical, 12)
        .background(color)
        .cornerRadius(.greatestFiniteMagnitude)
        
    }
}

struct StatisticsView: View {
    
    @StateObject var vm: StatisticsViewModel = StatisticsViewModel()
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    VStack {
                        HStack {
                            valueView(name: "Всего", color: .red, data: "\(Int(vm.steps))")
                            Spacer()
                            valueView(name: "Дистанция", color: .green, data: "\(Int(vm.distance))")
                        }
                        .padding(.vertical, 24)
                    }
                    
                    
                    VStack {
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
                            
                            Text("Цель\n10000")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .opacity(0.2)
                            
                            Circle()
                                .trim(from: 0.0, to: CGFloat(min(vm.steps, (Float(vm.steps) * 0.0001))))
                                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color.red)
                                .rotationEffect(Angle(degrees: 270))
                                .animation(.easeInOut, value: vm.steps)
                        }
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 24)
                    }
                    
                    
                    VStack {
                        
                        Text("График")
                            .bold()
                            .font(.system(size: 32))
                            .padding(.vertical, 24)
                        
                        Picker(selection: $vm.selectedTab, label: Text("")) {
                            ForEach(ChartsState.allCases, id: \.self) { priority in
                                let menuText = priority.rawValue
                                Text(menuText).tag(priority)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Chart {
                            ForEach( vm.selectedTab == .steps ? vm.stepsWeek : vm.distanceWeek ) { dataWeek in // чет пытался сделать через енам , но чет я пока не понял как в этом месте реализовать это что бы если больше двух будет, массив с массивами и по индексу их выбирать но так не получилось , сделать массивв с массивами которые во вьюмодели
                                
                                BarMark(
                                    x: .value("День недели", dataWeek.date, unit: .day),
                                    y: .value("Шаги", dataWeek.count)
                                    
                                )
                                .foregroundStyle(Color.purple)
                                .cornerRadius(.greatestFiniteMagnitude)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .frame(height: 350)
                        .chartXAxis {
                            AxisMarks(values: vm.stepsWeek.map { $0.date }) { date in
                                AxisValueLabel(format: .dateTime.weekday())
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) {
                                AxisValueLabel()
                            }
                        }
                    }
                    
                    
                    VStack {
                        Text("В среднем за день")
                            .bold()
                            .font(.system(size: 32))
                            .padding(.bottom, 24)
                        
                        HStack {
                            valueView(name: "Шаги", color: .red, data: vm.stepAvenge.description)
                            Spacer()
                            valueView(name: "Дистанция", color: .green, data: vm.distanceAvenge.description)
                        }
                        .padding(.bottom, 24)
                    }
                    
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Статистика")
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.baseColorWB)
                }
            }
            .task {
                vm.calculateDataHealthKit()
                
            }
      
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
