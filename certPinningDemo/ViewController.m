//
//  ViewController.m
//  certPinningDemo
//
//  Created by Zsombor on 2018. 01. 22..
//  Copyright © 2018. Zsombor. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ContentArea;
@property (strong) AFHTTPSessionManager* manager;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)osStorePressed:(id)sender {
    _ContentArea.text = @"Getting content from remote server...";
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"der"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSLog(@"CertPath:");
    NSLog(@"%@", cerPath);
    //kickstart AFNetworking
    NSURL *URL = [NSURL URLWithString:@"https://mrgsrv1.mrg-effitas.com/ios/test.html"];
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[NSSet setWithObject:certData]];
    _manager.securityPolicy = sec;
    
    @try{
        [_manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
            _ContentArea.text = responseString;
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _ContentArea.text = error.domain;
        }];
    }
    @catch(NSException *exception){

    }
}


- (IBAction)pinnedCertPressed:(id)sender {
    _ContentArea.text = @"Tapped pinned cert";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://t.metacortex.hu/~zsombor/test.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

@end
