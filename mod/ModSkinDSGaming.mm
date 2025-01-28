//
// ModSkinDSGaming.h
// ModSkinDSGM
//
// Created by DS Gaming on 08/02/2021
// Long live Vietnam
//
// djt me bon an cap khong ghi nguon
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "ModSkinDSGaming.h"
#import "aov.h"
@implementation ModSkinDSGM



UIAlertController *alertCtrl3;

NSFileManager *fileManager3;
NSString *documentDir3;

+ (instancetype)sharedInstance {
    static ModSkinDSGM *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)ActiveModDSGM {
    [[self sharedInstance] presentDocumentPicker];
}

- (void)load {
    [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"] title:__name message:@"Đang Load Mod Skin..."];

    timer(2) { [self suce]; });
}

- (void)suce {
    // Tạo một chuỗi NSAttributedString với tiêu đề màu xanh lá, in đậm và kích thước lớn
    NSString *title = @"Successfully";
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: [UIColor greenColor],
        NSFontAttributeName: [UIFont boldSystemFontOfSize:22] // Điều chỉnh kích thước font ở đây
    };
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    
    // Tạo UIAlertController với thông báo thành công
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"Mod Skin Thành Công!" preferredStyle:UIAlertControllerStyleAlert];
    
    // Thiết lập tiêu đề với màu xanh lá, in đậm và kích thước lớn bằng cách sử dụng KVC
    [alertCtrl setValue:attributedTitle forKey:@"attributedTitle"];
    
    // Thêm nút OK với hành động gây crash khi nhấn
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Gây crash ứng dụng khi nhấn OK
        abort(); // Hoặc sử dụng đoạn mã truy cập bộ nhớ không hợp lệ
    }]];
    
    // Hiển thị UIAlertController
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}


- (void)presentDocumentPicker {

    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] 
        initWithDocumentTypes:@[@"public.zip"] 
        inMode:UIDocumentPickerModeImport];
    
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet; 
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = [urls firstObject];
    [self handleSelectedZip:url];
}

- (void)handleSelectedZip:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *tempZipPath = [documentDir stringByAppendingPathComponent:@"ModSkin.zip"];
        [data writeToFile:tempZipPath atomically:YES];
        BOOL success = [SSZipArchive unzipFileAtPath:tempZipPath toDestination:documentDir];
        [[NSFileManager defaultManager] removeItemAtPath:tempZipPath error:nil];

        if (success) {
            [self load];
        }
    }
}

+ (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
}

@end