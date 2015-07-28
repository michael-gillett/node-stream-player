var assert = require('assert');
var StreamPlayer = require('../lib/stream-player');

describe('StreamPlayer', function() {

  describe('#play()', function () {
    it('should throw an error if attempting to play an empty queue', function () {
      var player = new StreamPlayer();
      assert.throws(player.play(), 'The queue is empty.');
    });
  });

  describe('#nowPlaying()', function () {
    it('should return the metadata for the first song added to the queue', function () {
      var player = new StreamPlayer();
      var metadata = {title: "Some song", artist: "Some artist"};
      player.add('', metadata);
      assert.equal(player.nowPlaying(), metadata);
    });
    it('should return undefined if we did not no pass any metadata', function () {
      var player = new StreamPlayer();
      assert.throws(player.nowPlaying(), 'No metadata was given.');
    });
  });

  describe('#add()', function () {
    it('should emit that a song has been added', function () {
      var errTimeout = setTimeout(function () {
        assert(false, 'Event never fired');
      }, 1000);

      var player = new StreamPlayer();
      var metadata = {title: "Some song", artist: "Some artist"};
      player.add('', metadata);
      player.on('song added', function() {
        assert(true, 'Song successfully added')
      })
    });
  });

});
