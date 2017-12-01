//
//  KCLDataReader.h
//  TeachingClient
//
//  Created by Chentao on 2017/4/27.
//  Copyright © 2017年 Chentao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCLDataReader : NSObject{
    char *_pointer;
}

@property (nonatomic, assign) uint64_t poz;
@property (nonatomic, strong, readonly) NSData *data;

+ (instancetype)readerWithData:(NSData*)data;
- (instancetype)initWithData:(NSData*)data;

- (NSData*)readBytes:(uint64_t)len;
- (int32_t)readInt32;
- (int64_t)readInt64;
- (int16_t)readInt16;
- (uint32_t)readUInt32;
- (uint64_t)readUInt64;
- (uint16_t)readUInt16;
- (char)readByte;
- (BOOL)readBool;
- (NSString*)readString;
- (NSData*)readPrefixedBytes;
- (float)readFloat;
- (double)readDouble;

@end
