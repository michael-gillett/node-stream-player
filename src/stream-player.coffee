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
    self = this

  play: () ->
    # Grab the next song if it exists
    nextSongUrl = queue[0]
    if typeof nextSongUrl != 'undefined'
      self.getStream(nextSongUrl, self.playStream)

  add: (url, track) ->
    queue.push(url)
    trackInfo.push(track)

  # Get the audio stream
  getStream: (url, callback) ->
    request.get(url).on 'response', (res) ->
      callback(res)

  playStream: (stream) ->
    decoder = new lame.Decoder()
    speaker = new Speaker(audioOptions)
    stream.pipe(decoder).once 'format', () ->
      this.pipe(speaker)
      speaker.once 'close', () ->
        queue.shift()
        if queue.length > 0
          self.play()

module.exports = StreamPlayer
