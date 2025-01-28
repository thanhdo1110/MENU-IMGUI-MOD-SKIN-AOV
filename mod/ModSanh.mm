#import "ModSanh.h"
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
@interface ModSanh () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation ModSanh


- (void)showAlertWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *title = @"Thông báo";
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName: [UIColor greenColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:22] 
        };
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
        

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        

        [alertController setValue:attributedTitle forKey:@"attributedTitle"];
        

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
            abort(); 
        }];
        [alertController addAction:okAction];
        

        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}



- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)sharedInstance {
    static ModSanh *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)ActiveModSanh {
    [[self sharedInstance] presentVideoPicker];
}

- (void)presentVideoPicker {
    [self showAlertWithMessage:@"Presenting video picker..."];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = @[UTTypeMovie.identifier];
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (rootViewController) {
            [rootViewController presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            [self showAlertWithMessage:@"Root view controller is nil."];
        }
    } else {
        [self showAlertWithMessage:@"Photo library is not available."];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSURL *videoURL = info[UIImagePickerControllerMediaURL];
    [self showAlertWithMessage:[NSString stringWithFormat:@"Selected video URL: %@", videoURL]];
    if (videoURL) {
        [self handleSelectedVideo:videoURL];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self showAlertWithMessage:@"Image picker was cancelled."];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSelectedVideo:(NSURL *)videoURL {
    [self showAlertWithMessage:[NSString stringWithFormat:@"Handling video at URL: %@", videoURL]];
    
    
    NSString *destinationDirectory = [self getDestinationDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:destinationDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Error creating directory: %@", error.localizedDescription]];
        }
    }
    

    NSArray *existingFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:destinationDirectory error:nil];
    

    for (NSString *file in existingFiles) {
        if ([file hasSuffix:@".mp4"]) {
            NSString *filePath = [destinationDirectory stringByAppendingPathComponent:file];
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"Error deleting file: %@", error.localizedDescription]];
            }
        }
    }


    NSString *newFileName = [videoURL lastPathComponent]; 

 
    NSString *destinationFilePath = [destinationDirectory stringByAppendingPathComponent:newFileName];

    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:[NSURL fileURLWithPath:destinationFilePath] error:&error];
    if (!success) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"Failed to copy video: %@", error.localizedDescription]];
    } else {
        [self showAlertWithMessage:[NSString stringWithFormat:@"Video copied successfully to: %@", destinationFilePath]];

 
        for (int i = 139; i <= 190; i++) {
            NSString *newFileName = [NSString stringWithFormat:@"PvpBtnDynamic%d.mp4", i];
            NSString *newFilePath = [destinationDirectory stringByAppendingPathComponent:newFileName];
            [[NSFileManager defaultManager] copyItemAtPath:destinationFilePath toPath:newFilePath error:&error];
            if (error) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"Error copying file: %@", error.localizedDescription]];
            }
        }
    }
}

- (NSString *)getDestinationDirectory {
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [documentDir stringByAppendingPathComponent:@"Extra/2019.V2/ISPDiff/LobbyMovie/"];
}

+ (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Document picker was cancelled");
}

@end
