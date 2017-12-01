//
//  MainViewController.m
//  FFmpegH264Decoder
//
//  Created by Chentao on 2017/11/24.
//  Copyright © 2017年 Chentao. All rights reserved.
//

#import "MainViewController.h"
#import "KCLH264Decoder.h"
#import "KCLDataReader.h"

@interface MainViewController ()

@property (nonatomic, strong) KCLH264Decoder *decoder;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.decoder = [[KCLH264Decoder alloc] init];
    [self.decoder initializeDecoder];

    NSString *filenameString = @"capture";
    NSString *filePathIn = [[NSBundle mainBundle] pathForResource:filenameString ofType:@"h264"];

    NSFileHandle *fileHandler = [NSFileHandle fileHandleForReadingAtPath:filePathIn];

    unsigned long long fileSize = [fileHandler seekToEndOfFile];
    [fileHandler seekToFileOffset:0];

    while (fileHandler.offsetInFile != fileSize) {
        NSData *data = [fileHandler readDataOfLength:1];
        [self.decoder decodeH264Data:data];
    }
}

@end
