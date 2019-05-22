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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *documentURL = [[NSBundle mainBundle] URLForResource:@"サンプル" withExtension:@"pdf"];
    PDFDocument *document = [[PDFDocument alloc] initWithURL:documentURL];
    self.pdfView.document = document;
}


@end
