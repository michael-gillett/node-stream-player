# node-stream-player
[![npm version](https://badge.fury.io/js/stream-player.svg)](http://badge.fury.io/js/stream-player)

For all of your mp3 streaming needs. Queue mp3 streams and play them through your computers speakers.

## Installation
```
$ npm install stream-player
```

## Example
```javascript
var StreamPlayer = require('stream-player');
var player = new StreamPlayer();

// Add a song url to the queue
player.add('http://path-to-mp3.com/example.mp3');

// Add a song url to the queue along with some metadata about the song
// Metadata can be any object that you want in any format you want
var metadata = {
  "title": "Some song",
  "artist": "Some artist",
  "duration": 234000,
  "humanTime": "3:54"
};

player.add('http://path-to-mp3.com/example.mp3', metaData);

// Start playing all songs added to the queue (FIFO)
player.play();

// Get the metadata for the current playing song and a time stamp when it started playing
player.nowPlaying();

// Get an array of metadata for the songs in the queue (excludes the current playing song)
player.getQueue();

// Get if the player is currently playing
player.isPlaying()


// EMIT EVENTS

player.on('play start', function() {
  // Code here is executed every time a song starts playing
});

player.on('play end', function() {
  // Code here is executed every time a song ends
});

player.on('song added', function() {
  // Code here is executed every time a song is added to the queue
});

```
## Methods
### `add(url [, metadata])`
Adds the mp3 stream located at `url` to the queue. The optional metadata parameter can be any JS object that holds information about the song. If no metadata is given then it will be `undefined` when referenced.
### `play()`
Starts playing the next song in the queue out of the speakers.
`throws new Error('A song is already playing.')`
`throws new Error('The queue is empty.')`
### `pause()`
Pause the current playing sound. Call `play()` to resume.
### `getQueue()`
Returns an array of song metadata in the queue.
### `isPlaying()`
Returns true if a song is currently playing and false otherwise.
### `nowPlaying()`
Returns an object containing the current playing song's metadata and the Unix time stamp of when the song started playing.
`throws new Error('No song is currently playing.')`
###### Example
```javascript
{
  track: {
    title: "Some song",
    artist: "Some artist"
  },
  timestamp: 1438489161
}
```



### Roadmap
- Support for more audio file types
