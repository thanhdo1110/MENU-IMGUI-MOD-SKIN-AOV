// ModSkinDSGaming.h
// ModSkinDSGM
//
// Created by DS Gaming on 08/02/2021
// Long live Vietnam
//
// djt me bon an cap khong ghi nguon
//

#import "mod.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
@implementation Mod

UIAlertController *alertCtrl;
UIAlertController *dialogCtrl;
NSFileManager *fileManager = [NSFileManager defaultManager];
NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
bool check_Mod = false;

+ (void)ActiveMod {
    dialogCtrl = [UIAlertController alertControllerWithTitle:@"Link Download Data" message:@"Vui Lòng Nhập Link Mod Skin" preferredStyle:UIAlertControllerStyleAlert];
    [dialogCtrl addTextFieldWithConfigurationHandler:^(UITextField *Text) {
      Text.placeholder = @"Enter Link ...";
    }];
    [dialogCtrl addAction:[UIAlertAction actionWithTitle:@"Hủy" style:UIAlertActionStyleCancel handler:nil]];
    [dialogCtrl
        addAction:[UIAlertAction actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *_Nonnull action) {
                                           UITextField *inputFieldDSGM = dialogCtrl.textFields.firstObject;
                                           NSString *inputTextDSGM = inputFieldDSGM.text;
                                           NSString *convertedLinkDSGM = [inputTextDSGM stringByReplacingOccurrencesOfString:@"file/d/"
                                                                                                                  withString:@"uc?"
                                                                                                                             @"export="
                                                                                                                             @"downloa"
                                                                                                                             @"d&id="];
                                           convertedLinkDSGM = [convertedLinkDSGM stringByReplacingOccurrencesOfString:@"/view?usp=drivesdk" withString:@""];
                                           NSString *dataPathDSGM = [documentDir stringByAppendingPathComponent:@"/"];
                                           NSString *backupPathDSGM = [documentDir stringByAppendingPathComponent:@"/Resources.backup"];
                                           NSString *old_file_DSGM = [documentDir stringByAppendingPathComponent:@"/Resources"];

                                           if ([inputTextDSGM isEqualToString:@""]) {
                                               alertCtrl = [UIAlertController alertControllerWithTitle:@"Warring"
                                                                                               message:@"Vui lòng nhập "
                                                                                                       @" "
                                                                                                       @"Link "
                                                                                                       @"tải Mod Skin"
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                               [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDefault handler:nil]];
                                               [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
                                           } else {
                                               if ([fileManager fileExistsAtPath:old_file_DSGM]) {
                                                   if (![fileManager fileExistsAtPath:backupPathDSGM]) {
                                                       timer(3) { [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"] title:__name message:@"Đang Tạo File BackUp...."]; });

                                                       NSError *backupError;
                                                       if (![fileManager copyItemAtPath:[dataPathDSGM stringByAppendingPathComponent:@"/Resources"] toPath:backupPathDSGM error:&backupError]) {
                                                           [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"] title:__name message:@"Không Thể Tạo File Backup!"];

                                                       } else {
                                                           check_Mod = true;
                                                       }
                                                   } else {
                                                       check_Mod = true;
                                                   }
                                               } else {
                                                   [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"]
                                                                                                title:__name
                                                                                              message:@"Không Thể Tạo File Backup Do Thư Mục Gốc Không \nTồn Tại Hoặc Lôic Khác"];
                                               }
                                               if (check_Mod == true) {
                                                   timer(1.5) {
                                                       [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"] title:__name message:@"Đang Tải Mod Skin \nVui Lòng Chờ Trong Giây Lát"];
                                                   });

                                                   NSString *downloadUrlDSGM = [NSString stringWithFormat:@"%@", convertedLinkDSGM];
                                                   NSURLRequest *requestdsgm = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrlDSGM]];

                                                   [NSURLConnection
                                                       sendAsynchronousRequest:requestdsgm
                                                                         queue:[NSOperationQueue currentQueue]
                                                             completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                               if (error) {
                                                                   [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"] title:__name message:@"Lỗi Máy Chủ \nTai Data Thấp Bại"];

                                                               } else {
                                                                   NSString *tempZipPath = [documentDir stringByAppendingPathComponent:@"Mod Skin.zip"];
                                                                   [data writeToFile:tempZipPath atomically:YES];
                                                                   BOOL success = [SSZipArchive unzipFileAtPath:tempZipPath toDestination:dataPathDSGM];
                                                                   [fileManager removeItemAtPath:tempZipPath error:nil];

                                                                   if (success) {
                                                                       // Hiển thị thông báo thành công
                                                                       [self showSuccessAlert];

                                                                   } else {
                                                                       [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"] title:__name message:@"Lỗi \nMod Giải Nén Tệp Thất Bại"];
                                                                   }
                                                               }
                                                             }];
                                               }
                                           }
                                         }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:dialogCtrl animated:YES completion:nil];
}

// Hàm hiển thị thông báo thành công với tiêu đề lớn, màu xanh lá và nội dung in đậm
+ (void)showSuccessAlert {
    // Tạo NSAttributedString cho tiêu đề với màu xanh lá và kích thước 22
    NSString *title = @"Mod Skin Thành Công";
    NSDictionary *titleAttributes = @{
        NSForegroundColorAttributeName: [UIColor greenColor],
        NSFontAttributeName: [UIFont boldSystemFontOfSize:22]
    };
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:titleAttributes];

    // Tạo NSAttributedString cho nội dung in đậm, không thay đổi kích thước
    NSString *message = @"Vui lòng ấn OK để mod skin có hiệu lực";
    NSDictionary *messageAttributes = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont systemFontSize]] // Giữ nguyên kích thước mặc định
    };
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message attributes:messageAttributes];


    // Tạo UIAlertController và thiết lập các thuộc tính tiêu đề, nội dung
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl setValue:attributedTitle forKey:@"attributedTitle"];
    [alertCtrl setValue:attributedMessage forKey:@"attributedMessage"];

    // Thêm nút OK để văng ứng dụng
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        abort(); // Gây crash ứng dụng khi nhấn OK
    }]];

    // Hiển thị UIAlertController
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

@end
