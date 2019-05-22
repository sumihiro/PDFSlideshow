//
//  AppDelegate.m
//  PDFReader
//
//  Created by 上田澄博 on 2019/05/22.
//  Copyright © 2019 sumihiro. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, weak) ViewController *pdfViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSURL *toURL = [[NSBundle mainBundle] URLForResource:@"サンプル" withExtension:@"pdf"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{ @"DocumentURL": toURL }];
    toURL = [defaults URLForKey:@"DocumentURL"];
    
    UINavigationController *nc = (UINavigationController*)self.window.rootViewController;
    self.pdfViewController = (ViewController*)nc.viewControllers[0];
    [self.pdfViewController openFileAtURL:toURL];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"open: %@", url);

    NSString *fromPath = url.path;
    NSString *fromFileName = [fromPath lastPathComponent];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *toPath = [documentsPath stringByAppendingPathComponent:fromFileName];
    
    NSLog(@"copy from: %@ to: %@", fromPath, toPath);
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:toPath]) {
        NSError *err;
        if ([manager removeItemAtPath:toPath error:&err] != YES) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"エラー" message:err.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:nil]];
            [self.window.rootViewController presentViewController:ac animated:YES completion:nil];
        }
    }
    NSError *err;
    if ([manager copyItemAtPath:fromPath toPath:toPath error:&err] != YES) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"エラー" message:err.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:nil]];
        [self.window.rootViewController presentViewController:ac animated:YES completion:nil];
    } else {
        NSURL *toURL = [NSURL fileURLWithPath:toPath];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setURL:toURL forKey:@"DocumentURL"];
        [self.pdfViewController openFileAtURL:toURL];
    }
    
    return true;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
