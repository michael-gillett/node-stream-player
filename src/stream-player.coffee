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
    @currentSong = null
    @playing = false


  # Play the next song in the queue if it exists
  play: () ->
    if @queue.length > 0 && !@playing
      @getStream(@queue[0], @playStream)
    else if @playing
      return new Error('A song is already playing.')
    else
      return new Error('The queue is empty.')

  # Add a song and metadata to the queue
  add: (url, track) ->
    @queue.push(url)
    @trackInfo.push(track)
    @emit('song added')

  nowPlaying: () ->
    if typeof @currentSong != 'undefined' && @playing
      return @currentSong
    else if !@playing
      return new Error('No song is currently playing.')
    else
      return null

  isPlaying: () ->
    return @playing

  getQueue: () ->
    return @trackInfo

  # Get the audio stream
  getStream: (url, callback) ->
    request.get(url).on 'response', (res) ->
      if res.headers['content-type'] == 'audio/mpeg'
        callback(res)
      else
        self.emit('invalid url')
        loadNextSong()


  # Decode the stream and pipe it to our speakers
  playStream: (stream) ->
    decoder = new lame.Decoder()
    speaker = new Speaker(audioOptions)
    stream.pipe(decoder).once 'format', () ->
      decoder.pipe(speaker)
      self.queue.shift()
      self.currentSong = self.trackInfo.shift()
      self.playing = true
      self.emit('play start')
      speaker.once 'close', () ->
        loadNextSong()



loadNextSong = () ->
  self.currentSong = null
  self.playing = false
  self.emit('play end')
  self.play()


module.exports = StreamPlayer
