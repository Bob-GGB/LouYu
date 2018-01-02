//
//  JYZRecorder.m
//  aaa
//
//  Created by jiayazi on 16/11/4.
//  Copyright © 2016年 jiayazi. All rights reserved.
//

#import "JYZRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Record.caf"]

@interface JYZRecorder()<AVAudioRecorderDelegate>;

/***  录音对象  */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/***  计时器  */
@property (nonatomic, strong) NSTimer *levelTimer;
/***  计时器对象++1  */
@property (assign, nonatomic)CGFloat timer;
/** 当前暂停的时间 */
@property (assign, nonatomic) NSTimeInterval pauseTime;


/** 最终录音总时间 */
@property (assign, nonatomic) NSInteger recordTotalTime;
@end

@implementation JYZRecorder

/**
 *  快速初始化
 *
 *  @return 录音对象
 */
+(JYZRecorder *)initRecorder{
    
    JYZRecorder * recoder = [[JYZRecorder alloc] init];
    return recoder;
}



/**
 *  开始录音
 *
 *  @ basePath 设置录音基础路径（后面要加上具体录音的名字）
 */
-(void)startRecorder{
    //初始化一些值
    _pauseTime = 0;
    
    //处理权限问题
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    //设置AVAudioSession
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    [audioSession setActive:YES error:nil];
   
    if(err) {
        NSLog(@"获取权限失败");
        return;
    }
    
    
    //初始化生成录音对象
    err = nil;
    NSURL *recordedFile = [self getRecorderUrlPath];
//    NSURL *mp3File=[NSURL fileURLWithPath:[RecordFile stringByAppendingString:_mp3Name]];
    
    NSDictionary *dic = [self recordingSettings];
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:dic error:&err];
    if(_recorder == nil) {
        NSLog(@"生成录音对象失败");
        return;
    }
    
    
    //准备和开始录音
    [_recorder prepareToRecord];
    //启用录音测量
    _recorder.meteringEnabled = YES;
    _recorder.delegate=self;
    //开始录音
    [_recorder record];
    [_recorder recordForDuration:0];
    [_recorder peakPowerForChannel:0];
    
    //开始计时
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    
    _timer = 0;
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(startTime) userInfo: nil repeats: YES];
    
    
    
}


/**
 *  开始录音计时
 */
- (void)startTime {
    _timer++;
    //NSLog(@"当前时间 == %f",_timer);
    self.sendcountDown = 0;
    //在这里要判断是否设置最大录音时间
    if (_recordMaxTime > 0) {
        self.sendcountDown = _recordMaxTime - _timer;
    }else{
        self.sendcountDown = 60 - _timer;
    }

    
   // NSLog(@"还可以录制%d",self.sendcountDown);
    
    if (self.sendcountDown < 1) {
       // NSLog(@"语音最长只能120秒哦");
        [self stopRecorder];
    }
}



/**
 *  暂停录音
 */
-(void)pauseRecorder{
    [_recorder pause];
    _pauseTime = _recorder.currentTime;
    [self.levelTimer invalidate];
    self.levelTimer = nil;
   // NSLog(@"已经暂停录音");
}

/**
 *  暂停后 继续开始录音
 */
-(void)pauseToStartRecorder{
    [_recorder recordAtTime:_pauseTime];
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(startTime) userInfo: nil repeats: YES];
    //NSLog(@"已经暂停 to 开始录音");
}



/**
 *  结束录音
 */
-(void)stopRecorder{
    if (_recorder) {
        [_recorder stop];
    }
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
    _recordTotalTime = _timer;
    _timer = 0;
    
    //NSLog(@"结束录音");
    
//    NSURL *recordedFiles = [self getRecorderUrlPath];
//    NSString *recoredStrfilePath=[recordedFiles absoluteString];
//
//        NSURL *mp3Files=[NSURL fileURLWithPath:[RecordFile stringByAppendingString:_mp3Name]];
//    NSString *mp3StrfilePath=[mp3Files absoluteString];
//
//    [self cafToMp3:recoredStrfilePath toMp3Path:mp3StrfilePath];
//
//    NSLog(@"recordedFiles:%@\n mp3Files:%@",recordedFiles,mp3Files);
    [self cafToMp3];
}

/**
 *  获取录音总时间
 */
-(NSInteger)getRecorderTotalTime{
    return _recordTotalTime;
}


/**
 *  获取录音地址
 */
-(NSURL *)getRecorderUrlPath{
    NSString *urlStr=RecordFile;
     NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 获取转成MP3的地址
 */
-(NSString *)getMp3UrlPath{
    
    return [RecordFile stringByAppendingString:_mp3Name];
    
}

/**
 *  删除录音
 */
-(void)deleteRecord{
    [_recorder stop];
    //删除本地录音文件
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:[[self getRecorderUrlPath] absoluteString]error:nil];
}


/**
 *  重置l录音器
 */
-(void)resetRecorder{
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    _timer = 0;
    _pauseTime = 0;
    _recordTotalTime = 0;
    [self deleteRecord];

}

/**
 *  设置录音一些属性
 */
- (NSDictionary *)recordingSettings
{
    NSMutableDictionary *recordSetting =[[NSMutableDictionary alloc] init];
    // 音频格式
    recordSetting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    recordSetting[AVSampleRateKey] = @(11025.0);
    // 音频通道数 1 或 2
    recordSetting[AVNumberOfChannelsKey] = @(2);
    // 线性音频的位深度  8、16、24、32
    recordSetting[AVLinearPCMBitDepthKey] = @(16);
    //录音的质量
    recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
    
    
    return recordSetting;
}
#pragma mark - caf文件转换成MP3格式
/**
 *
 */

-(void)cafToMp3{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *cafFilePath = RecordFile;
    NSString *mp3FilePath = [path stringByAppendingPathComponent:@"record.mp3"];
    
     [self creatFileWithFileName:cafFilePath];
   
//     NSLog(@"cafFilePath:%@\n mp3FilePath:%@",cafFilePath,mp3FilePath);
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        if(pcm == NULL)
        {
            NSLog(@"file not found");
        }
        else
        {
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header,跳过头文件 有的文件录制会有音爆，加上此句话去音爆
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);//11025.0
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            do {
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
            } while (read != 0);
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
            
        }
       
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
       
    }
    @finally {
        
//                cafFilePath = mp3FilePath;
//            NSData *voiceData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mp3FilePath]];   //此处可以打断点看下data文件的大小，如果太小，很可能是个空文件
//                NSLog(@"data ＝ %ld",voiceData.length);
        
        //         [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:_cafFilePath] error:nil]; // 生成文件移除原文件

        NSLog(@"执行完成");
    }
    
    
}
-(void)creatFileWithFileName:(NSString *)filepath{
    
    //创建文件管理器对象
    NSFileManager *managerFile=[NSFileManager defaultManager];
    //文件路
    
    //判断文件夹是否存在
    BOOL isExit= [managerFile fileExistsAtPath:filepath];
    if (!isExit) {
        NSLog(@"文件不存在");
        BOOL isSuccess= [managerFile createFileAtPath:filepath contents:nil attributes:nil];
        if (isSuccess) {
            NSLog(@"文件创建成功");
        }
        else
        {
            NSLog(@"文件创建失败");
        }
        
    }
}

@end
