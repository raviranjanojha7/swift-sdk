import SwiftUI
import AVKit

public struct VideoPlayer: View {
    let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        if let url = url {
            let player = AVPlayer(url: url)
            AVKit.VideoPlayer(player: player)
                .aspectRatio(contentMode: .fill)
                .onAppear {
                    player.play()
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player.currentItem,
                        queue: .main
                    ) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                }
        } else {
            Image(systemName: "video.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }
} 

#Preview {
    VideoPlayer(url: URL(string: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4"))
}
