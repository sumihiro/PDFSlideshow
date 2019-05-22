//
//  ViewController.m
//  PDFReader
//
//  Created by 上田澄博 on 2019/05/22.
//  Copyright © 2019 sumihiro. All rights reserved.
//

#import "ViewController.h"
@import PDFKit;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PDFView *pdfView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevButton;

@property (nonatomic, readwrite) BOOL isRunning;
@property (nonatomic, readwrite) NSTimeInterval slideInterval;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pdfView.displayMode = kPDFDisplaySinglePage;
    self.pdfView.displayDirection = kPDFDisplayDirectionHorizontal;
    
    NSURL *documentURL = [[NSBundle mainBundle] URLForResource:@"サンプル" withExtension:@"pdf"];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:documentURL];
    self.pdfView.document = document;

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

- (void)updateViews {
    self.startButton.enabled = !self.isRunning;
    self.pauseButton.enabled = self.isRunning;
    self.nextButton.enabled = self.pdfView.canGoToNextPage;
    self.prevButton.enabled = self.pdfView.canGoToPreviousPage;
}

- (void)statusLog {
    NSLog(@"canGoToFirstPage: %@", @(self.pdfView.canGoToFirstPage));
    NSLog(@"canGoToLastPage: %@", @(self.pdfView.canGoToLastPage));
    NSLog(@"canGoToNextPage: %@", @(self.pdfView.canGoToNextPage));
    NSLog(@"canGoToPreviousPage: %@", @(self.pdfView.canGoToPreviousPage));
}

@end
