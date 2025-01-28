#import "Backup.h"

@implementation Backup


+ (void)createBackup { // Chuyển thành class method
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *backupPathDSGM = [documentDir stringByAppendingPathComponent:@"Resources.backup"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *backupError;
    if ([fileManager fileExistsAtPath:backupPathDSGM]) {
        return;
    }

    if ([fileManager fileExistsAtPath:[documentDir stringByAppendingPathComponent:@"Resources"]]) {
        // Thư mục gốc tồn tại, tiến hành tạo backup
        if (![fileManager copyItemAtPath:[documentDir stringByAppendingPathComponent:@"Resources"]
                                  toPath:backupPathDSGM
                                   error:&backupError]) {
            // Xử lý lỗi khi không thể tạo backup
            NSLog(@"Error creating backup: %@", backupError.localizedDescription);
        } else {
            // Xử lý khi tạo backup thành công
            NSLog(@"Backup created successfully.");
        }
    } else {
        // Thư mục gốc không tồn tại, không thể tạo backup
        NSLog(@"Error: Resources directory not found.");
    }
}


+ (void)deleteBackup { // Chuyển thành class method
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *backupPathDSGM = [documentDir stringByAppendingPathComponent:@"Resources.backup"];
    NSString *dataPathDSGM = [documentDir stringByAppendingPathComponent:@"/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIAlertController *alertCtrl;

    if ([fileManager fileExistsAtPath:backupPathDSGM]) {
        NSError *deleteErrorDSGM;
        if ([fileManager removeItemAtPath:[dataPathDSGM stringByAppendingPathComponent:@"/Resources"] error:&deleteErrorDSGM]) {
            NSError *renameErrorDSGM;
            if ([fileManager moveItemAtPath:backupPathDSGM toPath:[dataPathDSGM stringByAppendingPathComponent:@"/Resources"] error:&renameErrorDSGM]) {
                        [FTNotificationIndicator showNotificationWithImage:[UIImage imageNamed:@"AppIcon"]
                                              title:@" Nguyễn Huỳnh Đức "
                                         message:@"Khôi Phục Thành Công Game Sẽ Crash Sau 3 Giây...."];

timer(3) {

exit(0);
           
        

});
            } else {
                alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                                message:@"File Backup Không Hợp Lệ Hoặc Lỗi Không Xác Định"
                                                         preferredStyle:UIAlertControllerStyleAlert];
                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
            }
        } else {
            alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                            message:@"Không Thể Khôi Phục Dữ Liệu Do Thư Mục / File Không Tồn Tại"
                                                     preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
        }
    } else {
        alertCtrl = [UIAlertController alertControllerWithTitle:@"Error"
                                                        message:@"Không Có File Backup Hoặc Hiện Đã Là Data Gốc"
                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"Đóng"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    }
}



@end