//
//  ViewController.m
//  PDFReader
//
//  Created by 上田澄博 on 2019/05/22.
//  Copyright © 2019 sumihiro. All rights reserved.
//

#import "ViewController.h"
@import PDFKit;

const NSTimeInterval MaxInterval = 60.0;
const NSTimeInterval MinInterval = 0.5;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PDFView *pdfView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevButton;
@property (weak, nonatomic) IBOutlet UISlider *intervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;

@property (nonatomic, readwrite) BOOL isRunning;
@property (nonatomic, readwrite) NSTimeInterval slideInterval;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PDFDocument *document;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pdfView.displayMode = kPDFDisplaySinglePage;
    self.pdfView.displayDirection = kPDFDisplayDirectionHorizontal;
    self.pdfView.autoScales = true;
    
    self.pdfView.document = self.document;

    self.slideInterval = 2.0;
    
    [self statusLog];
    [self updateViews];
}

- (IBAction)pushStart:(id)sender {
    self.isRunning = true;
    [self slide];
    [self updateViews];
}

- (IBAction)pushStop:(id)sender {
    [self.timer invalidate];
    self.isRunning = false;
    [self updateViews];
}

- (IBAction)pushNext:(id)sender {
    [self.pdfView goToNextPage:nil];
    [self statusLog];
    [self updateViews];
}

- (IBAction)pushPrev:(id)sender {
    [self.pdfView goToPreviousPage:nil];
    [self statusLog];
    [self updateViews];
}

- (IBAction)tapPDFView:(id)sender {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (IBAction)intervalSliderChanged:(UISlider*)sender {
    self.slideInterval = sender.value * MaxInterval + MinInterval;
    self.intervalLabel.text = [self formatInterval:self.slideInterval];
}

- (void)openFileAtURL:(NSURL*)url {
    PDFDocument *document = [[PDFDocument alloc] initWithURL:url];
    if (!document) {
        NSLog(@"error URL: %@", url);
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"エラー" message:@"ファイルが開けません" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    self.document = document;

    self.pdfView.document = document;
}

- (void)slide {
    __weak typeof(self) this = self;
    self.timer = [NSTimer timerWithTimeInterval:self.slideInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self statusLog];
        if (this.isRunning) {
            if (this.pdfView.canGoToNextPage) {
                [this.pdfView goToNextPage:nil];
            } else {
                [this.pdfView goToFirstPage:nil];
            }
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (NSString*)formatInterval:(NSTimeInterval)interval {
    return [NSString stringWithFormat:@"%.0f秒", interval];
}

- (void)updateViews {
    self.startButton.enabled = !self.isRunning;
    self.pauseButton.enabled = self.isRunning;
    self.nextButton.enabled = self.pdfView.canGoToNextPage;
    self.prevButton.enabled = self.pdfView.canGoToPreviousPage;
    self.intervalSlider.enabled = !self.isRunning;
    self.intervalSlider.value = (self.slideInterval - MinInterval) / MaxInterval;
    self.intervalLabel.text = [self formatInterval:self.slideInterval];
}

- (void)statusLog {
    NSLog(@"canGoToFirstPage: %@", @(self.pdfView.canGoToFirstPage));
    NSLog(@"canGoToLastPage: %@", @(self.pdfView.canGoToLastPage));
    NSLog(@"canGoToNextPage: %@", @(self.pdfView.canGoToNextPage));
    NSLog(@"canGoToPreviousPage: %@", @(self.pdfView.canGoToPreviousPage));
}

@end
