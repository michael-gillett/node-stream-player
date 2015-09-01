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
    @startTime = 0


  # Play the next song in the queue if it exists
  play: () ->
    if @queue.length > 0 && !@playing
      @getStream(@queue[0], @playStream)
      @playing = true
      @queue.shift()
      @currentSong = self.trackInfo.shift()
    else if @playing
      return new Error('A song is already playing.')
    else
      return new Error('The queue is empty.')

  # Remove a song with the given id metadata attribute
  remove: (id) ->
    index = @trackInfo.map( (info) -> return info.id ).indexOf(parseInt(id, 10))
    @trackInfo.splice(index, 1)
    @queue.splice(index, 1)


  # Add a song and metadata to the queue
  add: (url, track) ->
    @queue.push(url)
    @trackInfo.push(track)
    @emit('song added')

  # Returns the metadata for the song that is currently playing
  nowPlaying: () ->
    if @playing
      return {track: @currentSong, timestamp: @startTime}
    else
      return new Error('No song is currently playing.')

  # Returns if there is a song currently playing
  isPlaying: () ->
    return @playing

  # Returns the metadata for the songs that are in the queue
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
      self.startTime = Date.now();
      self.emit('play start')
      speaker.once 'close', () ->
        loadNextSong()


# Load the next song in the queue if there is one
loadNextSong = () ->
  self.currentSong = null
  self.playing = false
  self.emit('play end')
  self.play()


module.exports = StreamPlayer
