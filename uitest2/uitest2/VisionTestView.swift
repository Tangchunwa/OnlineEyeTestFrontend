import SwiftUI
import AVFoundation

struct VisionTestView: View {
    @StateObject private var faceDistanceManager = FaceDistanceManager()
    @State private var currentSize = 1.0
    @State private var result = ""
    @State private var distance: Float = 0.0
    @State private var currentLetter = "E"
    @State private var isTooClose = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var lastAudioPlayTime: Date?
    
    let sizes = [1.0, 0.8, 0.6, 0.4, 0.2]
    let letters = ["E", "F", "P", "T", "O", "Z", "L", "P", "E", "D"]
    
    // Reference size for iPhone 12 mini
    let referenceWidth: CGFloat = 375
    let referenceHeight: CGFloat = 812
    
    func scaledSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthRatio = geometry.size.width / referenceWidth
        let heightRatio = geometry.size.height / referenceHeight
        let scaleFactor = min(widthRatio, heightRatio)
        return size * scaleFactor
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                FaceDistanceView(distance: $distance, faceDistanceManager: faceDistanceManager)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Vision Test")
                        .font(.system(size: scaledSize(40, for: geometry), weight: .bold))
                    
                    Text(currentLetter)
                        .font(.system(size: scaledSize(100, for: geometry) * currentSize))
                        .padding()
                    
                    if distance < 0.4 {
                        Text("You are too close!")
                            .foregroundColor(.red)
                            .font(.system(size: scaledSize(24, for: geometry), weight: .semibold))
                            .padding()
                    }
                    
                    Button("I can see this") {
                        if let index = sizes.firstIndex(of: currentSize), index < sizes.count - 1 {
                            currentSize = sizes[index + 1]
                            currentLetter = letters[Int.random(in: 0..<letters.count)]
                        } else {
                            result = "Your vision is excellent!"
                        }
                    }
                    .disabled(distance < 0.4)
                    .font(.system(size: scaledSize(22, for: geometry), weight: .semibold))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("I can't see this") {
                        result = "Your vision score is \(String(format: "%.1f", 1.0 / currentSize))"
                    }
                    .disabled(distance < 0.4)
                    .font(.system(size: scaledSize(22, for: geometry), weight: .semibold))
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(result)
                        .font(.system(size: scaledSize(24, for: geometry), weight: .medium))
                        .padding()
                    
                    Text("Distance to face: \(String(format: "%.2f", distance)) meters")
                        .font(.system(size: scaledSize(20, for: geometry)))
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            faceDistanceManager.toggleCameraVisibility()
                        }) {
                            Text(faceDistanceManager.isCameraHidden ? "Show Camera" : "Hide Camera")
                                .font(.system(size: scaledSize(16, for: geometry)))
                                .padding(8)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(8)
                        }
                        .padding(.top, geometry.safeAreaInsets.top)
                        .padding(.trailing, 16)
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: distance) { newValue in
            if newValue < 0.4 {
                faceDistanceManager.playTooCloseAudio()
            }
        }
        .onAppear {
            faceDistanceManager.setupAudioPlayer()
        }
    }
}
class FaceDistanceManager: ObservableObject {
    @Published var isCameraHidden = true
    
    var audioPlayer: AVAudioPlayer?
    var lastAudioPlayTime: Date?
    
    func toggleCameraVisibility() {
        isCameraHidden.toggle()
    }
    
    func setupAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "too_close", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error setting up audio player: \(error.localizedDescription)")
        }
    }
    
    func playTooCloseAudio() {
        let currentTime = Date()
        
        // Check if 3 seconds have passed since the last audio play
        if let lastPlayTime = lastAudioPlayTime,
           currentTime.timeIntervalSince(lastPlayTime) < 3 {
            return
        }
        
        audioPlayer?.play()
        lastAudioPlayTime = currentTime
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
