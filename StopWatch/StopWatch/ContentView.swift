//
//  ContentView.swift
//  StopWatch
//
//  Created by Nishanth on 30/08/24.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel:StopwatchViewModel
    
    var body: some View {
        VStack {
            Text("Select the Time Precision")
                .font(.title2)
            Picker("Select Precision", selection: $viewModel.selectedPrecision) {
                ForEach(Precision.allCases, id: \.self) { precision in
                    Text(precision.rawValue)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: viewModel.selectedPrecision) { oldValue, newValue in
                
                viewModel.reset()
            }
            
            Text(viewModel.formattedTime())
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .padding()
            
            HStack {
                Button(action: {
                    viewModel.isRunning ? viewModel.pause() : viewModel.start()
                }) {
                    Text(viewModel.isRunning ? "Pause" : "Start")
                       
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button(action: {
                    viewModel.reset()
                }) {
                    Text("Reset")
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        
    }
    
    
}
