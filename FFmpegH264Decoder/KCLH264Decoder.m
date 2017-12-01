
//
//  KCLH264Decoder.m
//  FFmpegH264Decoder
//
//  Created by Chentao on 2017/11/27.
//  Copyright © 2017年 Chentao. All rights reserved.
//

#import "KCLH264Decoder.h"
#import <libavcodec/avcodec.h>
#import <libswscale/swscale.h>
#import <libavutil/pixdesc.h>
#import <libavutil/imgutils.h>
#import <UIKit/UIKit.h>

static AVCodec *codec;
static AVCodecParserContext *codecParser;
static AVCodecContext *codecContext;
static AVFrame *frame;
static AVPacket *packet;
//static int ret;

struct SwsContext *swsContext;

static uint8_t *pictureData[4];
static int pictureLineSize[4];

@implementation KCLH264Decoder {
}

- (void)initializeDecoder {
    avcodec_register_all();
    packet = av_packet_alloc();
    if (!packet) {
        NSLog(@"初始化解码器失败");
    }

    codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    if (!codec) {
        NSLog(@"初始化解码器失败");
    }

    char *codecName = codec->name;
    NSLog(@"%s",codecName);

    codecParser = av_parser_init(codec->id);
    if (!codecParser) {
        NSLog(@"初始化解码器失败");
    }

    codecContext = avcodec_alloc_context3(codec);
    if (!codecContext) {
        NSLog(@"初始化解码器失败");
    }

    if (avcodec_open2(codecContext, codec, NULL) < 0) {
        NSLog(@"初始化解码器失败");
    }

    frame = av_frame_alloc();
    if (!frame) {
        NSLog(@"初始化解码器失败");
    }
}

- (void)decodeH264Data:(NSData *)data {
    NSMutableData *tempData = [[NSMutableData alloc] initWithData:data];
    while (tempData.length > 0) {
        int len = av_parser_parse2(codecParser, codecContext, &packet->data, &packet->size, tempData.bytes, tempData.length, AV_NOPTS_VALUE, AV_NOPTS_VALUE, 0);
        if (len < 0) {
            NSLog(@"解码失败");
            return;
        }

        NSMutableData *subData = [[NSMutableData alloc] initWithData:[tempData subdataWithRange:NSMakeRange(len, tempData.length - len)]];
        tempData = subData;

        if (packet->size) {
            NSLog(@"解码:%d", packet->size);
            [self decodeCodecContext:codecContext frame:frame packet:packet];
        }
    }
}

- (void)decodeCodecContext:(AVCodecContext *)decCtx frame:(AVFrame *)fae packet:(AVPacket *)pkt {
    int ret = avcodec_send_packet(decCtx, pkt);
    if (ret < 0) {
        NSLog(@"解码失败");
        return;
    }
    while (ret >= 0) {
        ret = avcodec_receive_frame(decCtx, fae);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            return;
        } else if (ret < 0) {
            NSLog(@"解码失败");
            return;
        }

        UIImage *image = [self convertFrameToImage:fae];
        // NSLog(@"size:%@", NSStringFromCGSize(image.size));

        NSData *imageData = UIImagePNGRepresentation(image);
        // NSLog(@"imageData size:%lld", imageData.length);

        /////
        NSString *filenameString = [NSString stringWithFormat:@"image%d.jpg", decCtx->frame_number];
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePathOutput = [documentPath stringByAppendingPathComponent:filenameString];

        [imageData writeToFile:filePathOutput atomically:YES];
    }
}

- (UIImage *)convertFrameToImage:(AVFrame *)pFrame {

    if (pFrame->data[0]) {

        int width = pFrame->width;
        int height = pFrame->height;

        struct SwsContext *scxt = sws_getContext(width, height, pFrame->format, width, height, AV_PIX_FMT_RGBA, SWS_POINT, NULL, NULL, NULL);
        if (scxt == NULL) {
            return nil;
        }
        int det_bpp = av_get_bits_per_pixel(av_pix_fmt_desc_get(AV_PIX_FMT_RGBA));

        //        uint8_t *videoDstData[4];
        //        int videoLineSize[4];

        if (pFrame->key_frame) {
            av_image_alloc(pictureData, pictureLineSize, width, height, AV_PIX_FMT_RGBA, 1);
        }

        sws_scale(scxt, (const uint8_t **)pFrame->data, pFrame->linesize, 0, height, pictureData, pictureLineSize);

        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
        CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pictureData[0], pictureLineSize[0] * height, kCFAllocatorNull);
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGImageRef cgImage = CGImageCreate(width, height, 8, det_bpp, pictureLineSize[0], colorSpace, bitmapInfo, provider, NULL, NO, kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        CGDataProviderRelease(provider);
        CFRelease(data);
        return image;
    }
    
    return nil;
}


@end

