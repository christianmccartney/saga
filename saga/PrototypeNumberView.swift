//
//  PrototypeNumberView.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SwiftUI

struct PrototypeNumberView: View {
    var size: CGSize
    
    @State var float1: Float = NumberChanger.shared.float1
    @State var float2: Float = NumberChanger.shared.float2
    @State var float3: Float = NumberChanger.shared.float3
    
    @State var int1: Int = NumberChanger.shared.int1
    @State var int2: Int = NumberChanger.shared.int2
    @State var int3: Int = NumberChanger.shared.int3
    
    var body: some View {
        HStack {
            VStack {
                TextField("float1",
                          value: $float1,
                          formatter: NumberChanger.shared.floatFormatter) { _ in NumberChanger.shared.float1 = float1 }
                    .disableAutocorrection(true)
                    .border(Color.blue)
                    .keyboardType(.numberPad)
                TextField("float2",
                          value: $float2,
                          formatter: NumberChanger.shared.floatFormatter) { _ in NumberChanger.shared.float2 = float2 }
                    .disableAutocorrection(true)
                    .border(Color.blue)
                    .keyboardType(.numberPad)
                TextField("float3",
                          value: $float3,
                          formatter: NumberChanger.shared.floatFormatter) { _ in NumberChanger.shared.float3 = float3 }
                    .disableAutocorrection(true)
                    .border(Color.blue)
                    .keyboardType(.numberPad)
            }
            VStack {
                TextField("int1",
                          value: $int1,
                          formatter: NumberChanger.shared.intFormatter) { _ in NumberChanger.shared.int1 = int1 }
                    .disableAutocorrection(true)
                    .border(Color.blue)
                    .keyboardType(.numberPad)
                TextField("int2",
                          value: $int2,
                          formatter: NumberChanger.shared.intFormatter) { _ in NumberChanger.shared.int2 = int2 }
                    .disableAutocorrection(true)
                    .border(Color.blue)
                    .keyboardType(.numberPad)
                TextField("int3",
                          value: $int3,
                          formatter: NumberChanger.shared.intFormatter) { _ in NumberChanger.shared.int3 = int3 }
                    .disableAutocorrection(true)
                    .border(Color.blue)
                    .keyboardType(.numberPad)
            }
        }
        .frame(width: size.width/4, height: size.height/4, alignment: .top)
        .background(Color.black)
    }
}

class NumberChanger: ObservableObject {
    static let shared = NumberChanger()
    
    var floatFormatter: NumberFormatter
    var intFormatter: NumberFormatter
    
    @Published var float1: Float = 4.0
    @Published var float2: Float = 0.75
    @Published var float3: Float = 0.75
    
    @Published var int1: Int = 1
    @Published var int2: Int = 0
    @Published var int3: Int = 0
    
    private init() {
        self.floatFormatter = NumberFormatter()
        self.floatFormatter.allowsFloats = true
        self.floatFormatter.alwaysShowsDecimalSeparator = true
        self.floatFormatter.generatesDecimalNumbers = true
        self.floatFormatter.minimumFractionDigits = 0
        self.floatFormatter.maximumFractionDigits = 3
        self.intFormatter = NumberFormatter()
        self.intFormatter.allowsFloats = false
        self.intFormatter.alwaysShowsDecimalSeparator = false
        
    }
}
