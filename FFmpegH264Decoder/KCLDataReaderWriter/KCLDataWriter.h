//
//  KCLDataWriter.h
//  TeachingClient
//
//  Created by Chentao on 2017/4/27.
//  Copyright © 2017年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCLDataWriter : NSObject

@property (nonatomic, strong, readonly) NSMutableData *data;

+ (instancetype)writerWithData:(NSMutableData*)data;
- (instancetype)initWithData:(NSMutableData*)data;

- (void)writeBytes:(NSData*)bytes;
- (void)writeBytes:(const char*)rawBytes length:(uint32_t)length;
- (void)writePrefixedBytes:(NSData*)data;
- (void)writeInt32:(int32_t)value;
- (void)writeInt64:(int64_t)value;
- (void)writeInt16:(int16_t)value;
- (void)writeUInt32:(uint32_t)value;
- (void)writeUInt64:(uint64_t)value;
- (void)writeUInt16:(uint16_t)value;
- (void)writeByte:(char)byte;
- (void)writeBool:(BOOL)value;
- (void)writeString:(NSString*)str;
- (void)writeFloat:(float)value;
- (void)writeDouble:(double)value;


@end
