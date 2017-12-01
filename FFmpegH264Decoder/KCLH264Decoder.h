//
//  KCLH264Decoder.h
//  FFmpegH264Decoder
//
//  Created by Chentao on 2017/11/27.
//  Copyright © 2017年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCLH264Decoder : NSObject

- (void)initializeDecoder;

- (void)decodeH264Data:(NSData *)data;

- (void)destroyDecoder;

@end
