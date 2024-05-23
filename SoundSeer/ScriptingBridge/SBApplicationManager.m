#import "SBApplicationManager.h"

#import <ScriptingBridge/ScriptingBridge.h>

@implementation SBApplicationManager

+ (SBAppleMusicApplication *)appleMusicApp {
    return [SBApplication applicationWithBundleIdentifier:@"com.apple.Music"];
}

+ (SBSpotifyApplication *)spotifyApp {
    return [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
}

@end
