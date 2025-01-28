
#import "Esp/FTNotificationIndicator.h"
#import "SSZipArchive/SSZipArchive.h"
#import "aov.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^

@interface Mod : NSObject

+ (void)ActiveMod;

@end
