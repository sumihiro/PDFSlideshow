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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevButton;

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

    [self statusLog];
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

- (void)updateViews {
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
