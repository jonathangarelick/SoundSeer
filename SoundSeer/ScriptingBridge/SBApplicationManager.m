#import "SBApplicationManager.h"

#import <ScriptingBridge/ScriptingBridge.h>

@implementation SBApplicationManager

+ (SBMusicApplication *)musicApp {
    return [SBApplication applicationWithBundleIdentifier:@"com.apple.Music"];
}

+ (SBSpotifyApplication *)spotifyApp {
    return [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
}

@end
