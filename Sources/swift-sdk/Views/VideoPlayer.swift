import SwiftUI
import AVKit

public struct VideoPlayer: View {
    let url: URL?
    @State private var player: AVPlayer?
    @State private var playerObserver: Any?
    
    public init(url: URL?) {
        self.url = url
        if let url = url {
            let player = AVPlayer(url: url)
            player.isMuted = true  // Mute the player
            self._player = State(initialValue: player)
        }
    }
    
    public var body: some View {
        if let player = player {
            AVKit.VideoPlayer(player: player)
                .aspectRatio(contentMode: .fill)
                .onAppear {
                    player.seek(to: .zero)
                    player.play()
                    self.playerObserver = NotificationCenter.default.addObserver(
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
                    if let observer = playerObserver {
                        NotificationCenter.default.removeObserver(observer)
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
