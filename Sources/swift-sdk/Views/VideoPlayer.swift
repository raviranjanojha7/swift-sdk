import SwiftUI
import AVKit

public struct VideoPlayer: View {
    let url: URL?
    @State private var player: AVPlayer?
    @State private var playerObserver: Any?
    @Binding var progress: CGFloat?
    @Binding var isMuted: Bool
    
    public init(
        url: URL?, 
        progress: Binding<CGFloat?> = .constant(nil),
        isMuted: Binding<Bool> = .constant(true)
    ) {
        self.url = url
        self._progress = progress
        self._isMuted = isMuted
        if let url = url {
            let player = AVPlayer(url: url)
            player.isMuted = isMuted.wrappedValue
            self._player = State(initialValue: player)
        }
    }
    
    public var body: some View {
        if let player = player {
            AVKit.VideoPlayer(player: player)
                .aspectRatio(contentMode: .fill)
                .onChange(of: isMuted) { newValue in
                    player.isMuted = newValue
                }
                .onAppear {
                    player.seek(to: .zero)
                    player.play()
                    
                    if progress != nil {
                        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                            if let duration = player.currentItem?.duration.seconds, duration > 0 {
                                DispatchQueue.main.async {
                                    progress = CGFloat(time.seconds / duration)
                                }
                            }
                        }
                    }
                    
                    self.playerObserver = NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player.currentItem,
                        queue: .main
                    ) { _ in
                        player.seek(to: .zero)
                        player.play()
                        DispatchQueue.main.async {
                            progress = 0
                        }
                    }
                }
                .onDisappear {
                    player.pause()
                    player.seek(to: .zero)
                    DispatchQueue.main.async {
                        progress = 0
                    }
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
    VideoPlayer(url: URL(string: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_wlacs5m0tq7rv91yh1gv9rv7.mp4#t=0.1"), progress: .constant(0.5), isMuted: .constant(false))
}
