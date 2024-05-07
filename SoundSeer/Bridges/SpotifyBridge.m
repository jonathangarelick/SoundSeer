#import <Foundation/Foundation.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "Spotify.h"

@interface SpotifyBridge : NSObject

+ (SpotifyApplication *)spotifyApplication;

@end

@implementation SpotifyBridge

+ (SpotifyApplication *)spotifyApplication {
    SpotifyApplication *spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    return spotify;
}

@end
