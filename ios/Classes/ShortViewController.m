//
//  ShortViewController.m
//  CJMobileAdDemo
//
//  Created by Jun on 2022/4/11.
//

#import "ShortViewController.h"
#import <CJMobileAd/CJMobileAd.h>

@interface ShortViewController ()<CJShortVideoDelegate>

@property (nonatomic, strong) CJShortVideoAd *shortVideoAd;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ShortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.closeBtn];
    [self loadAdData];
}


- (void)dealloc
{
    NSLog(@"the page of fullscreenVideo delloc");
}

- (void)loadAdData {
    self.shortVideoAd = [[CJShortVideoAd alloc] initWithSlotId:@"be537b85a50e9954"];
    self.shortVideoAd.delegate = self;
    [self.shortVideoAd loadAdData];
}

#pragma mark CJFullscreenVideoAdDelegate

- (void)shortAdDidLoad:(CJShortVideoAd *)shortVideoAd resourceId:(NSString *)resourceId {
    NSLog(@"load success");
    [self.shortVideoAd showFromRootViewController:self contentView:self.view];
    [self.view bringSubviewToFront:self.closeBtn];
}

- (void)shortVideoAdLoadFailed:(CJShortVideoAd *)shortVideoAd error:(NSError *)error {
    NSLog(@"load failed of error: %@", error);
}

- (void)closeEvent {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CJMobileAd" ofType:@"bundle"]];
        UIImage *iconImage= [UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_cj_more_dislike_close" ofType:@"png"]];
        [_closeBtn setImage:iconImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.frame = CGRectMake(16, 46, 24, 24);
    }
    return _closeBtn;
}


- (void)shortVideoStateChange:(CJShortVideoStatus)status error:(NSError *)error {
    switch (status) {
        case CJShortVideoPlaying:
            NSLog(@"播放中");
            break;
        case CJShortVideoPause:
            NSLog(@"暂停");
            break;
        case CJShortVideoStop:
            NSLog(@"停止");
        case CJShortVideoError:
            NSLog(@"播放错误");
            break;
        case CJShortVideoEnd:
            NSLog(@"播放结束");
            break;
        case CJShortVideoUnKnow:
            NSLog(@"未知状态");
            break;
        default:
            
            break;
    }
}

@end
