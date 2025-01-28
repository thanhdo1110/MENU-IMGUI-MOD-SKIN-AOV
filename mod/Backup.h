#import <Foundation/Foundation.h>
#import "aov.h"
#import "Esp/FTNotificationIndicator.h"
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
@interface Backup : NSObject


+ (void)createBackup; // Chuyển thành class method
+ (void)deleteBackup; // Chuyển thành class method

@end