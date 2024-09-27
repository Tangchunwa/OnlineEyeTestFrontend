import SwiftUI

struct VisionTestView: View {
    @State private var currentSize = 1.0
    @State private var result = ""
    @State private var distance: Float = 0.0
    @State private var currentLetter = "E"
    
    let sizes = [1.0, 0.8, 0.6, 0.4, 0.2]
    let letters = ["E", "F", "P", "T", "O", "Z", "L", "P", "E", "D"]
    
    var body: some View {
        ZStack {
            FaceDistanceView(distance: $distance)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Vision Test")
                    .font(.largeTitle)
                
                Text(currentLetter)
                    .font(.system(size: 100 * currentSize))
                    .padding()
                
                Button("I can see this") {
                    if let index = sizes.firstIndex(of: currentSize), index < sizes.count - 1 {
                        currentSize = sizes[index + 1]
                        currentLetter = letters[Int.random(in: 0..<letters.count)]
                    } else {
                        result = "Your vision is excellent!"
                    }
                }
                
                Button("I can't see this") {
                    result = "Your vision score is \(String(format: "%.1f", 1.0 / currentSize))"
                }
                
                Text(result)
                    .padding()
                
                Text("Distance to face: \(String(format: "%.2f", distance)) meters")
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
struct MacularDegenerationTestView: View {
    @State private var result = ""
    
    var body: some View {
        VStack {
            Text("Macular Degeneration Self Test")
                .font(.largeTitle)
            
            Image(systemName: "circle.grid.3x3.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.gray)
            
            Button("I see straight lines") {
                result = "Your test result is normal."
            }
            
            Button("I see wavy or missing lines") {
                result = "Please consult an eye care professional."
            }
            
            Text(result)
                .padding()
        }
    }
}

struct ColorBlindnessTestView: View {
    @State private var result = ""
    
    var body: some View {
        VStack {
            Text("Color Blindness Test")
                .font(.largeTitle)
            
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.red)
            
            Button("I see a red circle") {
                result = "Your color vision appears normal."
            }
            
            Button("I don't see a red circle") {
                result = "You may have color vision deficiency. Please consult an eye care professional."
            }
            
            Text(result)
                .padding()
        }
    }
}
