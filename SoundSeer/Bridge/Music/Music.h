/*
 * com.apple.Music.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class MusicApplication, MusicItem, MusicTrack;

enum MusicEPlS {
    MusicEPlSStopped = 'kPSS',
    MusicEPlSPlaying = 'kPSP',
    MusicEPlSPaused = 'kPSp',
    MusicEPlSFastForwarding = 'kPSF',
    MusicEPlSRewinding = 'kPSR'
};
typedef enum MusicEPlS MusicEPlS;



/*
 * Music Suite
 */

// The application program
@interface MusicApplication : SBApplication

@property (copy, readonly) NSString *currentStreamTitle;  // the name of the current track in the playing stream (provided by streaming server)
@property (copy, readonly) NSString *currentStreamURL;  // the URL of the playing stream or streaming web site (provided by streaming server)
@property (copy, readonly) MusicTrack *currentTrack;  // the current targeted track
@property BOOL frontmost;  // is this the active application?
@property BOOL fullScreen;  // is the application using the entire screen?
@property (copy, readonly) NSString *name;  // the name of the application
@property (copy, readonly) NSString *version;  // the version of the application

- (void) run;  // Run the application
- (void) quit;  // Quit the application
- (MusicTrack *) add:(NSArray<NSURL *> *)x to:(SBObject *)to;  // add one or more files to a playlist
- (void) backTrack;  // reposition to beginning of current track or go to previous track if already at start of current track
- (MusicTrack *) convert:(NSArray<SBObject *> *)x;  // convert one or more files or tracks
- (void) fastForward;  // skip forward in a playing track
- (void) nextTrack;  // advance to the next track in the current playlist
- (void) pause;  // pause playback
- (void) playOnce:(BOOL)once;  // play the current track or the specified track or file.
- (void) playpause;  // toggle the playing/paused state of the current track
- (void) previousTrack;  // return to the previous track in the current playlist
- (void) resume;  // disable fast forward/rewind and resume playback, if playing.
- (void) rewind;  // skip backwards in a playing track
- (void) stop;  // stop playback
- (void) openLocation:(NSString *)x;  // Opens an iTunes Store or audio stream URL

@end

@protocol MusicGenericMethods

@end

// an item
@interface MusicItem : SBObject <MusicGenericMethods>

- (NSInteger) id;  // the id of the item
@property (copy) NSString *name;  // the name of the item

- (void) reveal;  // reveal and select a track or playlist

@end

// playable audio source
@interface MusicTrack : MusicItem

@property (copy) NSString *album;  // the album name of the track
@property (copy) NSString *albumArtist;  // the album artist of the track
@property BOOL albumDisliked;  // is the album for this track disliked?
@property BOOL albumFavorited;  // is the album for this track favorited?
@property (copy) NSString *category;  // the category of the track
@property (copy) NSString *comment;  // freeform notes about the track
@property BOOL compilation;  // is this track from a compilation album?
@property (copy) NSString *composer;  // the composer of the track
@property (readonly) NSInteger databaseID;  // the common, unique ID for this track. If two tracks in different playlists have the same database ID, they are sharing the same data.
@property (copy, readonly) NSDate *dateAdded;  // the date the track was added to the playlist
@property (copy) NSString *objectDescription;  // the description of the track
@property BOOL favorited;  // is this track favorited?


@end
