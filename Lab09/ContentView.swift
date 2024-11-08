import SwiftUI

struct ContentView: View {
    @State private var ballPosition: CGPoint = .zero
    @State private var targetPosition: CGPoint = .zero
    @State private var isShooting = false
    @Namespace private var ballNamespace

    private let ballDiameter: CGFloat = 20
    private let targetSize: CGSize = CGSize(width: 50, height: 50)

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                Rectangle()
                    .fill(Color.green)
                    .frame(width: targetSize.width, height: targetSize.height)
                    .position(x: targetPosition.x, y: targetSize.height / 2)

                Spacer()

                Circle()
                    .fill(Color.black)
                    .frame(width: ballDiameter, height: ballDiameter)
                    .position(ballPosition)
                    .matchedGeometryEffect(id: "ball", in: ballNamespace)

                Spacer()

                HStack {
                    Button(action: { adjustDestination(by: -10, in: geometry.size) }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()

                    HStack {
                        Button("Reset") {
                            resetGame(in: geometry.size)
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)

                        Button("Shoot!") {
                            shootBall(in: geometry.size)
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                    }
                    
                    Spacer()

                    Button(action: { adjustDestination(by: 10, in: geometry.size) }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
            }
            .onAppear {
                setupInitialPositions(in: geometry.size)
            }
        }
    }

    private func setupInitialPositions(in size: CGSize) {
        ballPosition = CGPoint(x: size.width / 2, y: size.height / 2.25)
        targetPosition = CGPoint(x: size.width / 2, y: targetSize.height / 2)
    }

    private func resetGame(in size: CGSize) {
        isShooting = false
        ballPosition = CGPoint(x: size.width / 2, y: size.height / 2.5)
        targetPosition = CGPoint(x: CGFloat.random(in: targetSize.width / 2...size.width - targetSize.width / 2), y: targetSize.height / 2)
    }

    private func shootBall(in size: CGSize) {
        guard !isShooting else { return }
        isShooting = true
        withAnimation(.linear(duration: 1)) {
            ballPosition = CGPoint(x: targetPosition.x, y: targetPosition.y - size.height / 2.1)
        }
    }

    private func adjustDestination(by amount: CGFloat, in size: CGSize) {
        ballPosition.x = max(0, min(size.width, ballPosition.x + amount))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
