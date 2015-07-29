var assert = require('assert');
var StreamPlayer = require('../lib/stream-player');

var validSong1 = 'http://soundbible.com/grab.php?id=989&type=mp3';

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
  });

  describe('#nowPlaying()', function () {
    it('should return the metadata for the first song added to the queue', function (done) {
      var player = new StreamPlayer();
      var metadata = {title: "Some song", artist: "Some artist"};
      player.add(validSong1, metadata);
      player.on('play start', function() {
        assert.equal(player.nowPlaying(), metadata);
        done();
      });
      player.play();
    });
    it('should return an error if no song is currently playing', function () {
      var player = new StreamPlayer();
      assert.throws(player.nowPlaying(), 'No song is currently playing.');
    });
    it('should return null if no metadata is given', function (done) {
      var player = new StreamPlayer();
      player.add(validSong1);
      player.on('play start', function() {
        assert.equal(player.nowPlaying(), null);
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
