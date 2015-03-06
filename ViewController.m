//
//  ViewController.m
//  JiSuanQi
//
//  Created by 冯勇海 on 15-3-4.
//  Copyright (c) 2015年 Chai. All rights reserved.
//

#import "ViewController.h"
#import "SalutationButton.h"

#define De_Name @"的"
#define Del_Name @"<-"
#define Del_All_Name @"AC"
#define Result_Name @"="
#define Empty_Name @""
#define Nian_Zhang @"（年长）"
#define Nian_Qing @"（年轻）"
#define CURRENT_DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define Edge_Space 16
#define Row_Count 4
#define Btn_Sapce 5

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *displayBgView;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    NSArray *titles = @[@"父", @"母", Del_Name, Del_All_Name, @"兄", @"姐", @"夫", @"年长", @"弟", @"妹", @"妻", @"年轻", @"仔", @"囡", De_Name, Result_Name];
    NSArray *titleNames = @[@"爸爸", @"妈妈", Del_Name, Del_All_Name, @"哥哥", @"姐姐", @"丈夫", Nian_Zhang, @"弟弟", @"妹妹", @"妻子", Nian_Qing, @"儿子", @"女儿", De_Name, Result_Name];
    
    CGFloat btnWidth = (CURRENT_DEVICE_SCREEN_WIDTH - Edge_Space * 2 - Btn_Sapce * (Row_Count - 1)) / Row_Count;
    CGFloat btnHeight = 40;
    for (NSUInteger i=0; i<titles.count; i++) {
        SalutationButton *btn = [self creatButton];
        if (i == 2 || i == 3) {
            [btn setBackgroundColor:[UIColor redColor]];
        } else if (i == titles.count - 1) {
            [btn setBackgroundColor:[UIColor orangeColor]];
        }
        btn.name = titleNames[i];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        CGRect btnFrame = btn.frame;
        btnFrame.origin.x = Edge_Space + (Btn_Sapce + btnWidth) * (i % Row_Count);
        btnFrame.origin.y = self.displayBgView.frame.origin.y + self.displayBgView.frame.size.height + Edge_Space + (Btn_Sapce + btnHeight) * (i / Row_Count);
        btnFrame.size.width = btnWidth;
        btnFrame.size.height = btnHeight;
        btn.frame = btnFrame;
        [btn addTarget:self action:@selector(nameBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawView {
    self.displayBgView.layer.cornerRadius = 3.0f;
    self.displayBgView.layer.masksToBounds = YES;
}

- (void)nameBtnPressed:(SalutationButton *)sender {
    if ([sender.name isEqualToString:Empty_Name]) {
        return;
    }
    if ([sender.name isEqualToString:Result_Name] && self.courseLabel.text.length > 0) {
        NSArray *names = [self.courseLabel.text componentsSeparatedByString:De_Name];
        if ([[self.courseLabel.text componentsSeparatedByString:De_Name].firstObject isEqualToString:@"儿子"] || [[self.courseLabel.text componentsSeparatedByString:De_Name].firstObject isEqualToString:@"女儿"]) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"keyValue" ofType:@"plist"];
            NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
            NSString *resultStr = resultDic[self.courseLabel.text];
            if (resultStr.length == 0) {
                self.resultLabel.text = @"外星人";
            } else {
                self.resultLabel.text = resultStr;
            }
            return;
        } else if (([[self.courseLabel.text componentsSeparatedByString:De_Name] containsObject:@"儿子"] || [[self.courseLabel.text componentsSeparatedByString:De_Name] containsObject:@"女儿"]) && [self.courseLabel.text componentsSeparatedByString:De_Name]){
            
        }
    }
    if (self.courseLabel.text.length > 0) {
        // 最后一个是“的”就拼上
        if ([[self.courseLabel.text substringFromIndex:self.courseLabel.text.length - 1] isEqualToString:De_Name]) {
            self.courseLabel.text = [self.courseLabel.text stringByAppendingString:sender.name];
        } else if ([sender.name isEqualToString:De_Name] && ![[self.courseLabel.text substringFromIndex:self.courseLabel.text.length - 1] isEqualToString:De_Name]) {
            self.courseLabel.text = [self.courseLabel.text stringByAppendingString:sender.name];
        } else if ([sender.name isEqualToString:Del_Name]) {
            if ([self.courseLabel.text containsString:De_Name]) {
                NSArray *names = [self.courseLabel.text componentsSeparatedByString:De_Name];
                NSString *lastStr = [De_Name stringByAppendingString:names.lastObject];
                self.courseLabel.text = [self.courseLabel.text substringToIndex:self.courseLabel.text.length - lastStr.length];
            } else {
                self.courseLabel.text = @"";
            }
        } else if ([sender.name isEqualToString:Del_All_Name]) {
            self.courseLabel.text = @"";
            self.resultLabel.text = @"";
        }
    } else if (self.courseLabel.text.length == 0 && ![sender.name isEqualToString:Del_Name] && ![sender.name isEqualToString:Del_All_Name] && ![sender.name isEqualToString:Result_Name] && ![sender.name isEqualToString:De_Name]) {
        self.courseLabel.text = [self.courseLabel.text stringByAppendingString:sender.name];
    }
}

- (SalutationButton *)creatButton {
    SalutationButton *btn = [[SalutationButton alloc] init];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 3.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return btn;
}

@end
