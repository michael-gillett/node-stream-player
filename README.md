# node-stream-player
[![npm version](https://badge.fury.io/js/stream-player.svg)](http://badge.fury.io/js/stream-player)

##### This package is still in the very early stages of development so expect breaking changes and things to not behave as expected.

For all of your mp3 streaming needs. Queue mp3 streams and play them through your computers speakers.

### Installation
```
$ npm install stream-player
```

### Example
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

// Get the metadata for the current playing song
// throws an error if no song is currently playing or null if no metadata was given
player.nowPlaying();

// Get an array of metadata for the songs in the queue (excludes the current playing song)
player.getQueue();


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

### Roadmap
- Error message system
- Ability to pause a song part way through and pick up at a later time
- Ability to play local files (Not a huge priority for my needs, but I will add it at some point for completeness)
