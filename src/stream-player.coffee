Speaker = require('speaker')
lame = require('lame')
request = require('request')
events = require('events')

queue = []
trackInfo = []
self = null


audioOptions = {
  channels: 2,
  bitDepth: 16,
  sampleRate: 44100,
  mode: lame.STEREO
}

class StreamPlayer extends events.EventEmitter

  constructor: () ->
    events.EventEmitter.call(this);
    self = this

  # Play the next song in the queue if it exists
  play: () ->
    nextSongUrl = queue[0]
    if typeof nextSongUrl != 'undefined'
      self.getStream(nextSongUrl, self.playStream)
    else
      return new Error('The queue is empty.')

  # Add a song and metadata to the queue
  add: (url, track) ->
    queue.push(url)
    trackInfo.push(track)
    self.emit('song added')

  nowPlaying: () ->
    return trackInfo[0]

  # Get the audio stream
  getStream: (url, callback) ->
    request.get(url).on 'response', (res) ->
      callback(res)

  # Decode the stream and pipe it to our speakers
  playStream: (stream) ->
    decoder = new lame.Decoder()
    speaker = new Speaker(audioOptions)
    stream.pipe(decoder).once 'format', () ->
      this.pipe(speaker)
      self.emit('play start')
      speaker.once 'close', () ->
        self.emit('play end')
        queue.shift()
        trackInfo.shift()
        self.play()

module.exports = StreamPlayer
