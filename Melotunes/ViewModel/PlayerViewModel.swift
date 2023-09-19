import Foundation
import Combine

final class PlayerViewModel {
  
  @Published
  var artist: Artist
  
  @Published
  var tracks: [Track]
  
  @Published
  var currentTrackIndex: Int
  
  @Published
  var playbackState: PlaybackState
  
  @Published
  var isShuffleOn: Bool
  
  @Published
  var repeatMode: RepeatMode

  private let formatter: DateComponentsFormatter
  private let playerController: PlayerController
  
  var currentTrack: AnyPublisher<Track?, Never>!
  
  var imageURL: AnyPublisher<URL?, Never>!
  
  var title: AnyPublisher<String?, Never>!
  
  var info: AnyPublisher<String?, Never>!
  
  var relativeProgress: AnyPublisher<Float, Never>!
  
  var elapsedTime: AnyPublisher<String?, Never>!
  
  var timeLeft: AnyPublisher<String?, Never>!
  
  var duration: AnyPublisher<TimeInterval, Never>!
  
  var requestAlbum: PassthroughSubject<AlbumDescriptor, Never>
  
  private var cancellables: Set<AnyCancellable>
  
  enum Action {
    case backward
    case playPause
    case forward
    case select(Float)
    case toggleInfinitePlayback
    case tapAlbum
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
  
  enum RepeatMode {
    case off
    case on(single: Bool)
  }
  
  init(artist: Artist,
       tracks: [Track],
       currentTrackIndex: Int,
       playerController: PlayerController) {
    self.tracks = tracks
    self.currentTrackIndex = currentTrackIndex
    self.artist = artist
    self.formatter = .init()
    self.playerController = playerController
    self.playbackState = playerController.isPlaying ? .playing : .pause
    self.requestAlbum = .init()
    self.cancellables = []
    self.repeatMode = .off
    self.isShuffleOn = false
    setupFormatter()
    setupPublishers()
  }
  
  func perform(_ action: Action) {
    switch action {
    case .forward:
      playNextTrack(forced: true)
    case .playPause:
      switch playbackState {
      case .pause:
        if playerController.hasItem && !playerController.isPlaying {
          playerController.play()
        } else {
          playCurrentTrack()
        }
      case .playing:
        playerController.pause()
      }
      playbackState.toggle()
    case .backward:
      let prevTrackIndex = currentTrackIndex == 0 ? tracks.endIndex - 1 : currentTrackIndex-1
      currentTrackIndex = prevTrackIndex
      playCurrentTrack()
    case .select(let progress):
      playerController.setRelativeProgress(progress)
    case .toggleInfinitePlayback:
      isShuffleOn.toggle()
    case .tapAlbum:
      requestAlbum.send(tracks[currentTrackIndex].sourceAlbum)
    }
  }
  
  func playCurrentTrack() {
    if tracks.isEmpty {
      return
    }
    playbackState = .playing
    playerController.setItem(withURL: tracks[currentTrackIndex].previewURL)
  }
  
  func toggleRepeat() {
    switch repeatMode {
    case .off:
      repeatMode = .on(single: false)
    case .on(single: false):
      repeatMode = .on(single: true)
    case .on(single: true):
      repeatMode = .off
    }
  }
  
  func toggleShuffle() {
    isShuffleOn.toggle()
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
    
    relativeProgress = playerController.$absoluteProgress
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
    
    timeLeft = playerController.$absoluteProgress
      .combineLatest(duration)
      .map { [weak self] progress, duration in
        guard let self else { return nil }
        return "-\(formatter.string(from: duration - progress)!)"
      }
      .eraseToAnyPublisher()
    
    elapsedTime = playerController.$absoluteProgress
      .map { [weak self] progress in
        guard let self else { return nil }
        return "\(formatter.string(from: progress)!)"
      }
      .eraseToAnyPublisher()
    
    playerController.didFinishPlaying
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.playNextTrack(forced: false)
      }
      .store(in: &cancellables)
  }
  
  func setupFormatter() {
    formatter.maximumUnitCount = 2
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = [.pad]
    formatter.allowedUnits = [.minute, .second]
  }
      
  func playNextTrack(forced: Bool) {
    if case .on(single: true) = repeatMode, !forced {
      playCurrentTrack()
      return
    }
    
    if isShuffleOn {
      currentTrackIndex = (tracks.startIndex..<tracks.endIndex).randomElement()!
      playCurrentTrack()
      return
    }
    
    let nextTrackIndex = currentTrackIndex + 1
    
    guard nextTrackIndex == tracks.endIndex else {
      currentTrackIndex = nextTrackIndex
      playCurrentTrack()
      return
    }
    
    switch (forced, repeatMode) {
    case (false, .on(single: true)):
      playCurrentTrack()
      
    case (true, .on(single: true)):
      playerController.setRelativeProgress(0)
      
    case (_, .off):
      playerController.setRelativeProgress(0)
      playerController.pause()
      playbackState = .pause
      
    case (_, .on(single: false)):
      currentTrackIndex = 0
      playCurrentTrack()
    }
  }
  
}
