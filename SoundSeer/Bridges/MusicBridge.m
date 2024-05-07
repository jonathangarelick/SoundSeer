#import <Foundation/Foundation.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "Music.h"

@interface AppleMusicBridge : NSObject

+ (MusicApplication *)appleMusicApplication;

@end

@implementation AppleMusicBridge

+ (MusicApplication *)appleMusicApplication {
    MusicApplication *appleMusic = [SBApplication applicationWithBundleIdentifier:@"com.apple.Music"];
    return appleMusic;
}

@end
