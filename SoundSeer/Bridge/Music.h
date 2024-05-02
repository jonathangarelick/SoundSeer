/*
 * com.apple.Music.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class comAppleMusicApplication, comAppleMusicItem, comAppleMusicAirPlayDevice, comAppleMusicArtwork, comAppleMusicEncoder, comAppleMusicEQPreset, comAppleMusicPlaylist, comAppleMusicAudioCDPlaylist, comAppleMusicLibraryPlaylist, comAppleMusicRadioTunerPlaylist, comAppleMusicSource, comAppleMusicSubscriptionPlaylist, comAppleMusicTrack, comAppleMusicAudioCDTrack, comAppleMusicFileTrack, comAppleMusicSharedTrack, comAppleMusicURLTrack, comAppleMusicUserPlaylist, comAppleMusicFolderPlaylist, comAppleMusicVisual, comAppleMusicWindow, comAppleMusicBrowserWindow, comAppleMusicEQWindow, comAppleMusicMiniplayerWindow, comAppleMusicPlaylistWindow, comAppleMusicVideoWindow;

enum comAppleMusicEKnd {
	comAppleMusicEKndTrackListing = 'kTrk' /* a basic listing of tracks within a playlist */,
	comAppleMusicEKndAlbumListing = 'kAlb' /* a listing of a playlist grouped by album */,
	comAppleMusicEKndCdInsert = 'kCDi' /* a printout of the playlist for jewel case inserts */
};
typedef enum comAppleMusicEKnd comAppleMusicEKnd;

enum comAppleMusicEnum {
	comAppleMusicEnumStandard = 'lwst' /* Standard PostScript error handling */,
	comAppleMusicEnumDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum comAppleMusicEnum comAppleMusicEnum;

enum comAppleMusicEPlS {
	comAppleMusicEPlSStopped = 'kPSS',
	comAppleMusicEPlSPlaying = 'kPSP',
	comAppleMusicEPlSPaused = 'kPSp',
	comAppleMusicEPlSFastForwarding = 'kPSF',
	comAppleMusicEPlSRewinding = 'kPSR'
};
typedef enum comAppleMusicEPlS comAppleMusicEPlS;

enum comAppleMusicERpt {
	comAppleMusicERptOff = 'kRpO',
	comAppleMusicERptOne = 'kRp1',
	comAppleMusicERptAll = 'kAll'
};
typedef enum comAppleMusicERpt comAppleMusicERpt;

enum comAppleMusicEShM {
	comAppleMusicEShMSongs = 'kShS',
	comAppleMusicEShMAlbums = 'kShA',
	comAppleMusicEShMGroupings = 'kShG'
};
typedef enum comAppleMusicEShM comAppleMusicEShM;

enum comAppleMusicESrc {
	comAppleMusicESrcLibrary = 'kLib',
	comAppleMusicESrcAudioCD = 'kACD',
	comAppleMusicESrcMP3CD = 'kMCD',
	comAppleMusicESrcRadioTuner = 'kTun',
	comAppleMusicESrcSharedLibrary = 'kShd',
	comAppleMusicESrcITunesStore = 'kITS',
	comAppleMusicESrcUnknown = 'kUnk'
};
typedef enum comAppleMusicESrc comAppleMusicESrc;

enum comAppleMusicESrA {
	comAppleMusicESrAAlbums = 'kSrL' /* albums only */,
	comAppleMusicESrAAll = 'kAll' /* all text fields */,
	comAppleMusicESrAArtists = 'kSrR' /* artists only */,
	comAppleMusicESrAComposers = 'kSrC' /* composers only */,
	comAppleMusicESrADisplayed = 'kSrV' /* visible text fields */,
	comAppleMusicESrANames = 'kSrS' /* track names only */
};
typedef enum comAppleMusicESrA comAppleMusicESrA;

enum comAppleMusicESpK {
	comAppleMusicESpKNone = 'kNon',
	comAppleMusicESpKFolder = 'kSpF',
	comAppleMusicESpKGenius = 'kSpG',
	comAppleMusicESpKLibrary = 'kSpL',
	comAppleMusicESpKMusic = 'kSpZ',
	comAppleMusicESpKPurchasedMusic = 'kSpM'
};
typedef enum comAppleMusicESpK comAppleMusicESpK;

enum comAppleMusicEMdK {
	comAppleMusicEMdKSong = 'kMdS' /* music track */,
	comAppleMusicEMdKMusicVideo = 'kVdV' /* music video track */,
	comAppleMusicEMdKUnknown = 'kUnk'
};
typedef enum comAppleMusicEMdK comAppleMusicEMdK;

enum comAppleMusicERtK {
	comAppleMusicERtKUser = 'kRtU' /* user-specified rating */,
	comAppleMusicERtKComputed = 'kRtC' /* computed rating */
};
typedef enum comAppleMusicERtK comAppleMusicERtK;

enum comAppleMusicEAPD {
	comAppleMusicEAPDComputer = 'kAPC',
	comAppleMusicEAPDAirPortExpress = 'kAPX',
	comAppleMusicEAPDAppleTV = 'kAPT',
	comAppleMusicEAPDAirPlayDevice = 'kAPO',
	comAppleMusicEAPDBluetoothDevice = 'kAPB',
	comAppleMusicEAPDHomePod = 'kAPH',
	comAppleMusicEAPDUnknown = 'kAPU'
};
typedef enum comAppleMusicEAPD comAppleMusicEAPD;

enum comAppleMusicEClS {
	comAppleMusicEClSUnknown = 'kUnk',
	comAppleMusicEClSPurchased = 'kPur',
	comAppleMusicEClSMatched = 'kMat',
	comAppleMusicEClSUploaded = 'kUpl',
	comAppleMusicEClSIneligible = 'kRej',
	comAppleMusicEClSRemoved = 'kRem',
	comAppleMusicEClSError = 'kErr',
	comAppleMusicEClSDuplicate = 'kDup',
	comAppleMusicEClSSubscription = 'kSub',
	comAppleMusicEClSPrerelease = 'kPrR',
	comAppleMusicEClSNoLongerAvailable = 'kRev',
	comAppleMusicEClSNotUploaded = 'kUpP'
};
typedef enum comAppleMusicEClS comAppleMusicEClS;

enum comAppleMusicEExF {
	comAppleMusicEExFPlainText = 'kTXT',
	comAppleMusicEExFUnicodeText = 'kUCT',
	comAppleMusicEExFXML = 'kXML',
	comAppleMusicEExFM3U = 'kM3U',
	comAppleMusicEExFM3U8 = 'kM38'
};
typedef enum comAppleMusicEExF comAppleMusicEExF;

@protocol com.apple.MusicGenericMethods

- (void) printPrintDialog:(BOOL)printDialog withProperties:(NSDictionary *)withProperties kind:(comAppleMusicEKnd)kind theme:(NSString *)theme;  // Print the specified object(s)
- (void) close;  // Close an object
- (void) delete;  // Delete an element from an object
- (SBObject *) duplicateTo:(SBObject *)to;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (void) open;  // Open the specified object(s)
- (void) save;  // Save the specified object(s)
- (void) playOnce:(BOOL)once;  // play the current track or the specified track or file.
- (void) select;  // select the specified object(s)

@end



/*
 * Music Suite
 */

// The application program
@interface comAppleMusicApplication : SBApplication

- (SBElementArray<comAppleMusicAirPlayDevice *> *) AirPlayDevices;
- (SBElementArray<comAppleMusicBrowserWindow *> *) browserWindows;
- (SBElementArray<comAppleMusicEncoder *> *) encoders;
- (SBElementArray<comAppleMusicEQPreset *> *) EQPresets;
- (SBElementArray<comAppleMusicEQWindow *> *) EQWindows;
- (SBElementArray<comAppleMusicMiniplayerWindow *> *) miniplayerWindows;
- (SBElementArray<comAppleMusicPlaylist *> *) playlists;
- (SBElementArray<comAppleMusicPlaylistWindow *> *) playlistWindows;
- (SBElementArray<comAppleMusicSource *> *) sources;
- (SBElementArray<comAppleMusicTrack *> *) tracks;
- (SBElementArray<comAppleMusicVideoWindow *> *) videoWindows;
- (SBElementArray<comAppleMusicVisual *> *) visuals;
- (SBElementArray<comAppleMusicWindow *> *) windows;

@property (readonly) BOOL AirPlayEnabled;  // is AirPlay currently enabled?
@property (readonly) BOOL converting;  // is a track currently being converted?
@property (copy) NSArray<comAppleMusicAirPlayDevice *> *currentAirPlayDevices;  // the currently selected AirPlay device(s)
@property (copy) comAppleMusicEncoder *currentEncoder;  // the currently selected encoder (MP3, AIFF, WAV, etc.)
@property (copy) comAppleMusicEQPreset *currentEQPreset;  // the currently selected equalizer preset
@property (copy, readonly) comAppleMusicPlaylist *currentPlaylist;  // the playlist containing the currently targeted track
@property (copy, readonly) NSString *currentStreamTitle;  // the name of the current track in the playing stream (provided by streaming server)
@property (copy, readonly) NSString *currentStreamURL;  // the URL of the playing stream or streaming web site (provided by streaming server)
@property (copy, readonly) comAppleMusicTrack *currentTrack;  // the current targeted track
@property (copy) comAppleMusicVisual *currentVisual;  // the currently selected visual plug-in
@property BOOL EQEnabled;  // is the equalizer enabled?
@property BOOL fixedIndexing;  // true if all AppleScript track indices should be independent of the play order of the owning playlist.
@property BOOL frontmost;  // is this the active application?
@property BOOL fullScreen;  // is the application using the entire screen?
@property (copy, readonly) NSString *name;  // the name of the application
@property BOOL mute;  // has the sound output been muted?
@property double playerPosition;  // the player’s position within the currently playing track in seconds.
@property (readonly) comAppleMusicEPlS playerState;  // is the player stopped, paused, or playing?
@property (copy, readonly) SBObject *selection;  // the selection visible to the user
@property BOOL shuffleEnabled;  // are songs played in random order?
@property comAppleMusicEShM shuffleMode;  // the playback shuffle mode
@property comAppleMusicERpt songRepeat;  // the playback repeat mode
@property NSInteger soundVolume;  // the sound output volume (0 = minimum, 100 = maximum)
@property (copy, readonly) NSString *version;  // the version of the application
@property BOOL visualsEnabled;  // are visuals currently being displayed?

- (void) printPrintDialog:(BOOL)printDialog withProperties:(NSDictionary *)withProperties kind:(comAppleMusicEKnd)kind theme:(NSString *)theme;  // Print the specified object(s)
- (void) run;  // Run the application
- (void) quit;  // Quit the application
- (comAppleMusicTrack *) add:(NSArray<NSURL *> *)x to:(SBObject *)to;  // add one or more files to a playlist
- (void) backTrack;  // reposition to beginning of current track or go to previous track if already at start of current track
- (comAppleMusicTrack *) convert:(NSArray<SBObject *> *)x;  // convert one or more files or tracks
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

// an item
@interface comAppleMusicItem : SBObject <com.apple.MusicGenericMethods>

@property (copy, readonly) SBObject *container;  // the container of the item
- (NSInteger) id;  // the id of the item
@property (readonly) NSInteger index;  // the index of the item in internal application order
@property (copy) NSString *name;  // the name of the item
@property (copy, readonly) NSString *persistentID;  // the id of the item as a hexadecimal string. This id does not change over time.
@property (copy) NSDictionary *properties;  // every property of the item

- (void) download;  // download a cloud track or playlist
- (NSString *) exportAs:(comAppleMusicEExF)as to:(NSURL *)to;  // export a source or playlist
- (void) reveal;  // reveal and select a track or playlist

@end

// an AirPlay device
@interface comAppleMusicAirPlayDevice : comAppleMusicItem

@property (readonly) BOOL active;  // is the device currently being played to?
@property (readonly) BOOL available;  // is the device currently available?
@property (readonly) comAppleMusicEAPD kind;  // the kind of the device
@property (copy, readonly) NSString *networkAddress;  // the network (MAC) address of the device
- (BOOL) protected;  // is the device password- or passcode-protected?
@property BOOL selected;  // is the device currently selected?
@property (readonly) BOOL supportsAudio;  // does the device support audio playback?
@property (readonly) BOOL supportsVideo;  // does the device support video playback?
@property NSInteger soundVolume;  // the output volume for the device (0 = minimum, 100 = maximum)


@end

// a piece of art within a track or playlist
@interface comAppleMusicArtwork : comAppleMusicItem

@property (copy) NSImage *data;  // data for this artwork, in the form of a picture
@property (copy) NSString *objectDescription;  // description of artwork as a string
@property (readonly) BOOL downloaded;  // was this artwork downloaded by Music?
@property (copy, readonly) NSNumber *format;  // the data format for this piece of artwork
@property NSInteger kind;  // kind or purpose of this piece of artwork
@property (copy) id rawData;  // data for this artwork, in original format


@end

// converts a track to a specific file format
@interface comAppleMusicEncoder : comAppleMusicItem

@property (copy, readonly) NSString *format;  // the data format created by the encoder


@end

// equalizer preset configuration
@interface comAppleMusicEQPreset : comAppleMusicItem

@property double band1;  // the equalizer 32 Hz band level (-12.0 dB to +12.0 dB)
@property double band2;  // the equalizer 64 Hz band level (-12.0 dB to +12.0 dB)
@property double band3;  // the equalizer 125 Hz band level (-12.0 dB to +12.0 dB)
@property double band4;  // the equalizer 250 Hz band level (-12.0 dB to +12.0 dB)
@property double band5;  // the equalizer 500 Hz band level (-12.0 dB to +12.0 dB)
@property double band6;  // the equalizer 1 kHz band level (-12.0 dB to +12.0 dB)
@property double band7;  // the equalizer 2 kHz band level (-12.0 dB to +12.0 dB)
@property double band8;  // the equalizer 4 kHz band level (-12.0 dB to +12.0 dB)
@property double band9;  // the equalizer 8 kHz band level (-12.0 dB to +12.0 dB)
@property double band10;  // the equalizer 16 kHz band level (-12.0 dB to +12.0 dB)
@property (readonly) BOOL modifiable;  // can this preset be modified?
@property double preamp;  // the equalizer preamp level (-12.0 dB to +12.0 dB)
@property BOOL updateTracks;  // should tracks which refer to this preset be updated when the preset is renamed or deleted?


@end

// a list of tracks/streams
@interface comAppleMusicPlaylist : comAppleMusicItem

- (SBElementArray<comAppleMusicTrack *> *) tracks;
- (SBElementArray<comAppleMusicArtwork *> *) artworks;

@property (copy) NSString *objectDescription;  // the description of the playlist
@property BOOL disliked;  // is this playlist disliked?
@property (readonly) NSInteger duration;  // the total length of all tracks (in seconds)
@property (copy) NSString *name;  // the name of the playlist
@property BOOL favorited;  // is this playlist favorited?
@property (copy, readonly) comAppleMusicPlaylist *parent;  // folder which contains this playlist (if any)
@property (readonly) NSInteger size;  // the total size of all tracks (in bytes)
@property (readonly) comAppleMusicESpK specialKind;  // special playlist kind
@property (copy, readonly) NSString *time;  // the length of all tracks in MM:SS format
@property (readonly) BOOL visible;  // is this playlist visible in the Source list?

- (void) moveTo:(SBObject *)to;  // Move playlist(s) to a new location
- (comAppleMusicTrack *) searchFor:(NSString *)for_ only:(comAppleMusicESrA)only;  // search a playlist for tracks matching the search string. Identical to entering search text in the Search field.

@end

// a playlist representing an audio CD
@interface comAppleMusicAudioCDPlaylist : comAppleMusicPlaylist

- (SBElementArray<comAppleMusicAudioCDTrack *> *) audioCDTracks;

@property (copy) NSString *artist;  // the artist of the CD
@property BOOL compilation;  // is this CD a compilation album?
@property (copy) NSString *composer;  // the composer of the CD
@property NSInteger discCount;  // the total number of discs in this CD’s album
@property NSInteger discNumber;  // the index of this CD disc in the source album
@property (copy) NSString *genre;  // the genre of the CD
@property NSInteger year;  // the year the album was recorded/released


@end

// the main library playlist
@interface comAppleMusicLibraryPlaylist : comAppleMusicPlaylist

- (SBElementArray<comAppleMusicFileTrack *> *) fileTracks;
- (SBElementArray<comAppleMusicURLTrack *> *) URLTracks;
- (SBElementArray<comAppleMusicSharedTrack *> *) sharedTracks;


@end

// the radio tuner playlist
@interface comAppleMusicRadioTunerPlaylist : comAppleMusicPlaylist

- (SBElementArray<comAppleMusicURLTrack *> *) URLTracks;


@end

// a media source (library, CD, device, etc.)
@interface comAppleMusicSource : comAppleMusicItem

- (SBElementArray<comAppleMusicAudioCDPlaylist *> *) audioCDPlaylists;
- (SBElementArray<comAppleMusicLibraryPlaylist *> *) libraryPlaylists;
- (SBElementArray<comAppleMusicPlaylist *> *) playlists;
- (SBElementArray<comAppleMusicRadioTunerPlaylist *> *) radioTunerPlaylists;
- (SBElementArray<comAppleMusicSubscriptionPlaylist *> *) subscriptionPlaylists;
- (SBElementArray<comAppleMusicUserPlaylist *> *) userPlaylists;

@property (readonly) long long capacity;  // the total size of the source if it has a fixed size
@property (readonly) long long freeSpace;  // the free space on the source if it has a fixed size
@property (readonly) comAppleMusicESrc kind;


@end

// a subscription playlist from Apple Music
@interface comAppleMusicSubscriptionPlaylist : comAppleMusicPlaylist

- (SBElementArray<comAppleMusicFileTrack *> *) fileTracks;
- (SBElementArray<comAppleMusicURLTrack *> *) URLTracks;


@end

// playable audio source
@interface comAppleMusicTrack : comAppleMusicItem

- (SBElementArray<comAppleMusicArtwork *> *) artworks;

@property (copy) NSString *album;  // the album name of the track
@property (copy) NSString *albumArtist;  // the album artist of the track
@property BOOL albumDisliked;  // is the album for this track disliked?
@property BOOL albumFavorited;  // is the album for this track favorited?
@property NSInteger albumRating;  // the rating of the album for this track (0 to 100)
@property (readonly) comAppleMusicERtK albumRatingKind;  // the rating kind of the album rating for this track
@property (copy) NSString *artist;  // the artist/source of the track
@property (readonly) NSInteger bitRate;  // the bit rate of the track (in kbps)
@property double bookmark;  // the bookmark time of the track in seconds
@property BOOL bookmarkable;  // is the playback position for this track remembered?
@property NSInteger bpm;  // the tempo of this track in beats per minute
@property (copy) NSString *category;  // the category of the track
@property (readonly) comAppleMusicEClS cloudStatus;  // the iCloud status of the track
@property (copy) NSString *comment;  // freeform notes about the track
@property BOOL compilation;  // is this track from a compilation album?
@property (copy) NSString *composer;  // the composer of the track
@property (readonly) NSInteger databaseID;  // the common, unique ID for this track. If two tracks in different playlists have the same database ID, they are sharing the same data.
@property (copy, readonly) NSDate *dateAdded;  // the date the track was added to the playlist
@property (copy) NSString *objectDescription;  // the description of the track
@property NSInteger discCount;  // the total number of discs in the source album
@property NSInteger discNumber;  // the index of the disc containing this track on the source album
@property BOOL disliked;  // is this track disliked?
@property (copy, readonly) NSString *downloaderAppleID;  // the Apple ID of the person who downloaded this track
@property (copy, readonly) NSString *downloaderName;  // the name of the person who downloaded this track
@property (readonly) double duration;  // the length of the track in seconds
@property BOOL enabled;  // is this track checked for playback?
@property (copy) NSString *episodeID;  // the episode ID of the track
@property NSInteger episodeNumber;  // the episode number of the track
@property (copy) NSString *EQ;  // the name of the EQ preset of the track
@property double finish;  // the stop time of the track in seconds
@property BOOL gapless;  // is this track from a gapless album?
@property (copy) NSString *genre;  // the music/audio genre (category) of the track
@property (copy) NSString *grouping;  // the grouping (piece) of the track. Generally used to denote movements within a classical work.
@property (copy, readonly) NSString *kind;  // a text description of the track
@property (copy) NSString *longDescription;  // the long description of the track
@property BOOL favorited;  // is this track favorited?
@property (copy) NSString *lyrics;  // the lyrics of the track
@property comAppleMusicEMdK mediaKind;  // the media kind of the track
@property (copy, readonly) NSDate *modificationDate;  // the modification date of the content of this track
@property (copy) NSString *movement;  // the movement name of the track
@property NSInteger movementCount;  // the total number of movements in the work
@property NSInteger movementNumber;  // the index of the movement in the work
@property NSInteger playedCount;  // number of times this track has been played
@property (copy) NSDate *playedDate;  // the date and time this track was last played
@property (copy, readonly) NSString *purchaserAppleID;  // the Apple ID of the person who purchased this track
@property (copy, readonly) NSString *purchaserName;  // the name of the person who purchased this track
@property NSInteger rating;  // the rating of this track (0 to 100)
@property (readonly) comAppleMusicERtK ratingKind;  // the rating kind of this track
@property (copy, readonly) NSDate *releaseDate;  // the release date of this track
@property (readonly) NSInteger sampleRate;  // the sample rate of the track (in Hz)
@property NSInteger seasonNumber;  // the season number of the track
@property BOOL shufflable;  // is this track included when shuffling?
@property NSInteger skippedCount;  // number of times this track has been skipped
@property (copy) NSDate *skippedDate;  // the date and time this track was last skipped
@property (copy) NSString *show;  // the show name of the track
@property (copy) NSString *sortAlbum;  // override string to use for the track when sorting by album
@property (copy) NSString *sortArtist;  // override string to use for the track when sorting by artist
@property (copy) NSString *sortAlbumArtist;  // override string to use for the track when sorting by album artist
@property (copy) NSString *sortName;  // override string to use for the track when sorting by name
@property (copy) NSString *sortComposer;  // override string to use for the track when sorting by composer
@property (copy) NSString *sortShow;  // override string to use for the track when sorting by show name
@property (readonly) long long size;  // the size of the track (in bytes)
@property double start;  // the start time of the track in seconds
@property (copy, readonly) NSString *time;  // the length of the track in MM:SS format
@property NSInteger trackCount;  // the total number of tracks on the source album
@property NSInteger trackNumber;  // the index of the track on the source album
@property BOOL unplayed;  // is this track unplayed?
@property NSInteger volumeAdjustment;  // relative volume adjustment of the track (-100% to 100%)
@property (copy) NSString *work;  // the work name of the track
@property NSInteger year;  // the year the track was recorded/released


@end

// a track on an audio CD
@interface comAppleMusicAudioCDTrack : comAppleMusicTrack

@property (copy, readonly) NSURL *location;  // the location of the file represented by this track


@end

// a track representing an audio file (MP3, AIFF, etc.)
@interface comAppleMusicFileTrack : comAppleMusicTrack

@property (copy) NSURL *location;  // the location of the file represented by this track

- (void) refresh;  // update file track information from the current information in the track’s file

@end

// a track residing in a shared library
@interface comAppleMusicSharedTrack : comAppleMusicTrack


@end

// a track representing a network stream
@interface comAppleMusicURLTrack : comAppleMusicTrack

@property (copy) NSString *address;  // the URL for this track


@end

// custom playlists created by the user
@interface comAppleMusicUserPlaylist : comAppleMusicPlaylist

- (SBElementArray<comAppleMusicFileTrack *> *) fileTracks;
- (SBElementArray<comAppleMusicURLTrack *> *) URLTracks;
- (SBElementArray<comAppleMusicSharedTrack *> *) sharedTracks;

@property BOOL shared;  // is this playlist shared?
@property (readonly) BOOL smart;  // is this a Smart Playlist?
@property (readonly) BOOL genius;  // is this a Genius Playlist?


@end

// a folder that contains other playlists
@interface comAppleMusicFolderPlaylist : comAppleMusicUserPlaylist


@end

// a visual plug-in
@interface comAppleMusicVisual : comAppleMusicItem


@end

// any window
@interface comAppleMusicWindow : comAppleMusicItem

@property NSRect bounds;  // the boundary rectangle for the window
@property (readonly) BOOL closeable;  // does the window have a close button?
@property (readonly) BOOL collapseable;  // does the window have a collapse button?
@property BOOL collapsed;  // is the window collapsed?
@property BOOL fullScreen;  // is the window full screen?
@property NSPoint position;  // the upper left position of the window
@property (readonly) BOOL resizable;  // is the window resizable?
@property BOOL visible;  // is the window visible?
@property (readonly) BOOL zoomable;  // is the window zoomable?
@property BOOL zoomed;  // is the window zoomed?


@end

// the main window
@interface comAppleMusicBrowserWindow : comAppleMusicWindow

@property (copy, readonly) SBObject *selection;  // the selected tracks
@property (copy) comAppleMusicPlaylist *view;  // the playlist currently displayed in the window


@end

// the equalizer window
@interface comAppleMusicEQWindow : comAppleMusicWindow


@end

// the miniplayer window
@interface comAppleMusicMiniplayerWindow : comAppleMusicWindow


@end

// a sub-window showing a single playlist
@interface comAppleMusicPlaylistWindow : comAppleMusicWindow

@property (copy, readonly) SBObject *selection;  // the selected tracks
@property (copy, readonly) comAppleMusicPlaylist *view;  // the playlist displayed in the window


@end

// the video window
@interface comAppleMusicVideoWindow : comAppleMusicWindow


@end

