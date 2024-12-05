import SwiftUI
import AVKit

public struct VideoPlayer: View {
    let url: URL?
    @State private var player: AVPlayer?
    
    public init(url: URL?) {
        self.url = url
        if let url = url {
            self._player = State(initialValue: AVPlayer(url: url))
        }
    }
    
    public var body: some View {
        if let player = player {
            AVKit.VideoPlayer(player: player)
                .aspectRatio(contentMode: .fill)
                .onAppear {
                    player.seek(to: .zero)
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
                .onDisappear {
                    player.pause()
                    player.seek(to: .zero)
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
