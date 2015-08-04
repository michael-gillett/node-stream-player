var assert = require('assert');
var StreamPlayer = require('../lib/stream-player');

var validSong1 = 'http://www.stephaniequinn.com/Music/Commercial%20DEMO%20-%2015.mp3';
var invalidSong1 = 'http://google.com'

describe('StreamPlayer', function() {

  describe('#play()', function () {
    it('should throw an error if attempting to play an empty queue', function () {
      var player = new StreamPlayer();
      assert.throws(player.play(), 'The queue is empty.');
    });
    it('should emit play start if a valid song url is added', function (done) {
      var player = new StreamPlayer();
      player.on('play start', function() {
        done();
      })
      player.add(validSong1);
      player.play();
    });
    it('should throw an error if we try to play() when a song is already playing', function (done) {
      var player = new StreamPlayer();
      player.on('play start', function() {
        assert.throws(player.play(), Error);
        done();
      })
      player.add(validSong1);
      player.play();
    });
    it('should throw an error if we try to play() a url that is not a song', function (done) {
      var player = new StreamPlayer();
      player.add(invalidSong1);
      player.play();
      player.once('invalid url', function() {
        done();
      })
    });
  });

  describe('#nowPlaying()', function () {
    it('should return the metadata for the first song added to the queue', function (done) {
      var player = new StreamPlayer();
      var metadata = {title: "Some song", artist: "Some artist"};
      player.add(validSong1, metadata);
      player.on('play start', function() {
        var time = Date.now();
        var current = player.nowPlaying();
        assert.deepEqual(current.track, metadata);
        // Check that the timestamp is +/- 10 ms
        assert(Math.abs(time - current.timestamp) < 10);
        done();
      });
      player.play();
    });
    it('should return an error if no song is currently playing', function () {
      var player = new StreamPlayer();
      assert.throws(player.nowPlaying(), 'No song is currently playing.');
    });
    it('should return undefined if no metadata is given', function (done) {
      var player = new StreamPlayer();
      player.add(validSong1);
      player.on('play start', function() {
        var time = Date.now();
        var current = player.nowPlaying();
        assert(typeof current.track == 'undefined');
        // Check that the timestamp is +/- 10 ms
        assert(Math.abs(time - current.timestamp) < 10);
        done();
      });
      player.play();
    });
  });

  describe('#add()', function () {
    it('should emit that a song has been added', function (done) {
      var player = new StreamPlayer();
      var metadata = {title: "Some song", artist: "Some artist"};
      player.once('song added', function() {
        done();
      })
      player.add('', metadata);
    });
  });

});
