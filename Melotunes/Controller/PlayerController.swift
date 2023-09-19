//
//  PlayerController.swift
//  Melotunes
//
//  Created by Vladislav Fitc on 18.09.2023.
//

import Foundation
import AVFoundation
import Combine

final class PlayerController {
  
  private let player: AVPlayer
  private var timeObserverToken: Any?
  private var itemDidPlayToEndToken: Any?
  
  var hasItem: Bool {
    player.currentItem != nil
  }
  
  var isPlaying: Bool {
    player.timeControlStatus == .playing
  }

  @Published
  var absoluteProgress: TimeInterval
  
  let didFinishPlaying: PassthroughSubject<URL, Never>
    
  init(player: AVPlayer = .init()) {
    self.player = player
    self.didFinishPlaying = PassthroughSubject()
    self.absoluteProgress = 0
    let interval = CMTime(seconds: 0.1,
                          preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    timeObserverToken =
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
          guard let self else { return }
          self.absoluteProgress = time.seconds
    }
  }
  
  func play() {
    player.play()
  }
  
  func pause() {
    player.pause()
  }
  
  func resetCurrentTrack() {
    guard let item = player.currentItem else { return }
    item.seek(to: CMTime(seconds: 0,
                         preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
              completionHandler: nil)
  }
  
  func setItem(withURL url: URL) {
    let item = AVPlayerItem(url: url)
    if let oldObserver = itemDidPlayToEndToken {
      NotificationCenter.default.removeObserver(oldObserver)
    }
    itemDidPlayToEndToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                   object: item,
                                                                   queue: .main) { [weak self] _ in
      self?.didFinishPlaying.send(url)
    }
    player.replaceCurrentItem(with: item)
    player.play()
  }
    
  func setRelativeProgress(_ progress: Float) {
    let interval = CMTime(seconds: 30 * Double(progress),
                          preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    player.seek(to: interval)
  }
  
  deinit {
    timeObserverToken.flatMap(player.removeTimeObserver)
    itemDidPlayToEndToken.flatMap(NotificationCenter.default.removeObserver)
  }
  
}
