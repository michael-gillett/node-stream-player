Speaker = require('speaker')
lame = require('lame')
request = require('request')
events = require('events')

audioOptions = {
  channels: 2,
  bitDepth: 16,
  sampleRate: 44100,
  mode: lame.STEREO
}

self = null

class StreamPlayer extends events.EventEmitter

  constructor: () ->
    events.EventEmitter.call(this)
    self = this
    @queue = []
    @trackInfo = []


  # Play the next song in the queue if it exists
  play: () ->
    nextSongUrl = @queue[0]
    if typeof nextSongUrl != 'undefined'
      @getStream(nextSongUrl, @playStream)
    else
      return new Error('The queue is empty.')

  # Add a song and metadata to the queue
  add: (url, track) ->
    @queue.push(url)
    @trackInfo.push(track)
    @emit('song added')

  nowPlaying: () ->
    song = @trackInfo[0]
    if typeof song != 'undefined'
      return song
    else
      return new Error('No metadata was given.')

  getQueue: () ->
    return @trackInfo

  # Get the audio stream
  getStream: (url, callback) ->
    request.get(url).on 'response', (res) ->
      callback(res)

  # Decode the stream and pipe it to our speakers
  playStream: (stream) ->
    decoder = new lame.Decoder()
    speaker = new Speaker(audioOptions)
    stream.pipe(decoder).once 'format', () ->
      decoder.pipe(speaker)
      self.emit('play start')
      speaker.once 'close', () ->
        self.emit('play end')
        self.queue.shift()
        self.trackInfo.shift()
        self.play()

module.exports = StreamPlayer
