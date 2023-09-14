import Foundation
import Combine
import AVFoundation

final class PlayerViewModel {
  
  @Published
  var artist: Artist
  
  @Published
  var tracks: [Track]
  
  @Published
  var currentTrackIndex: Int
  
  @Published
  var absoluteProgress: TimeInterval
  
  @Published
  var playbackState: PlaybackState
  
  @Published
  var isInfinitePlaybackOn: Bool
  
  var currentTrack: AnyPublisher<Track?, Never>!
  
  var imageURL: AnyPublisher<URL?, Never>!
  
  var title: AnyPublisher<String?, Never>!
  
  var info: AnyPublisher<String?, Never>!
  
  var relativeProgress: AnyPublisher<Float, Never>!
  
  var elapsedTime: AnyPublisher<String?, Never>!
  
  var timeLeft: AnyPublisher<String?, Never>!
  
  var duration: AnyPublisher<TimeInterval, Never>!
  
  enum Action {
    case backward
    case playPause
    case forward
    case select(Float)
    case toggleInfinitePlayback
  }
  
  enum PlaybackState {
    case playing
    case pause
    
    mutating func toggle() {
      switch self {
      case .playing:
        self = .pause
      case .pause:
        self = .playing
      }
    }
  }
    
  private let player: AVPlayer
  
  private let formatter: DateComponentsFormatter

  private var timeObserverToken: Any?
  private var itemDidPlayToEndToken: Any?
  
  init(artist: Artist,
       tracks: [Track],
       currentTrackIndex: Int) {
    self.tracks = tracks
    self.currentTrackIndex = currentTrackIndex
    self.artist = artist
    self.formatter = .init()
    self.player = .init()
    self.isInfinitePlaybackOn = true
    self.absoluteProgress = 0
    self.playbackState = .pause
    setupFormatter()
    setupPublishers()
  }
  
  func perform(_ action: Action) {
    switch action {
    case .forward:
      playNextTrack()
    case .playPause:
      switch playbackState {
      case .pause:
        if player.currentItem == nil {
          playCurrentTrack()
        } else {
          player.play()
        }
        playbackState.toggle()
      case .playing:
        player.pause()
        playbackState.toggle()
      }
    case .backward:
      let prevTrackIndex = currentTrackIndex == 0 ? tracks.endIndex - 1 : currentTrackIndex-1
      currentTrackIndex = prevTrackIndex
      playCurrentTrack()
    case .select(let progress):
      let interval = CMTime(seconds: 30 * Double(progress),
                            preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      player.seek(to: interval)
    case .toggleInfinitePlayback:
      isInfinitePlaybackOn.toggle()
    }
  }
  
  deinit {
    timeObserverToken.flatMap(player.removeTimeObserver)
    itemDidPlayToEndToken.flatMap(NotificationCenter.default.removeObserver)
  }
  
}

private extension PlayerViewModel {
  
  func setupPublishers() {
    duration = Just(30)
      .eraseToAnyPublisher()
    
    currentTrack = $currentTrackIndex
      .combineLatest($tracks)
      .map { (index, tracks) in
        guard (tracks.startIndex..<tracks.endIndex).contains(index) else { return nil }
        return tracks[index]
      }
      .eraseToAnyPublisher()
    
    imageURL = currentTrack
      .map(\.?.sourceAlbum.coverImageURL)
      .eraseToAnyPublisher()
    
    relativeProgress = $absoluteProgress
      .combineLatest(duration)
      .map { progress, duration in
        Float(progress / duration)
      }
      .eraseToAnyPublisher()
    
    title = currentTrack
      .map(\.?.title)
      .eraseToAnyPublisher()
    
    info = $artist
      .combineLatest(currentTrack)
      .map { artist, track in
        "\(artist.name)\(track.flatMap { " – \($0.sourceAlbum.title)"} ?? "")"
      }
      .eraseToAnyPublisher()

    let interval = CMTime(seconds: 0.1,
                          preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    timeObserverToken =
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
          guard let self else { return }
          self.absoluteProgress = time.seconds
    }
    
    timeLeft = $absoluteProgress
      .combineLatest(duration)
      .map { [weak self] progress, duration in
        guard let self else { return nil }
        return "-\(self.formatter.string(from: duration - progress)!)"
      }
      .eraseToAnyPublisher()
    
    elapsedTime = $absoluteProgress
      .map { [weak self] progress in
        guard let self else { return nil }
        return "\(formatter.string(from: progress)!)"
      }
      .eraseToAnyPublisher()
  }
  
  func setupFormatter() {
    formatter.maximumUnitCount = 2
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = [.pad]
    formatter.allowedUnits = [.minute, .second]
  }
  
  func playNextTrack() {
    let nextTrackIndex = (currentTrackIndex + 1) % tracks.count
    currentTrackIndex = nextTrackIndex
    playCurrentTrack()
  }
  
  func playCurrentTrack() {
    let url = tracks[currentTrackIndex].previewURL
    let item = AVPlayerItem(url: url)
    if let oldObserver = itemDidPlayToEndToken {
      NotificationCenter.default.removeObserver(oldObserver)
    }
    itemDidPlayToEndToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                   object: item,
                                                                   queue: .main) { [weak self] _ in
      guard let self else { return }
      if self.isInfinitePlaybackOn {
        self.playNextTrack()
      } else {
        item.seek(to: CMTime(seconds: 0,
                             preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                  completionHandler: nil)
        self.playbackState = .pause
      }
    }
    player.replaceCurrentItem(with: item)
    player.play()
  }
  
}
