#import "SBMusic.h"
#import "SBSpotify.h"

@interface SBApplicationManager : NSObject

+ (SBMusicApplication *)musicApp;
+ (SBSpotifyApplication *)spotifyApp;

@end
