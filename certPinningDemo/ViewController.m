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
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;

- (IBAction)osStorePressed:(id)sender;
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

- (IBAction)plainTextButtonPressed:(id)sender {
    NSString *address = @"http://singleframesecurity.net/success.html";
    
    _ContentArea.text = @"Downloading plain text connection";
    _urlTextView.text = address;
    
    NSURL *URL = [NSURL URLWithString:address];
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    @try{
        [_manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
            _ContentArea.text = responseString;
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _ContentArea.text =@"Error during download";
        }];
    }
    @catch(NSException *exception){
        _ContentArea.text = @"Exception occurred.";
    }
}

- (IBAction)osStorePressed:(id)sender {
    NSString *address = @"https://singleframesecurity.net:443/success.html";
    _ContentArea.text = @"Downloading using OS store CA validation...";
    _urlTextView.text = address;
    
    NSURL *URL = [NSURL URLWithString:address];
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    @try{
        [_manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
            _ContentArea.text = responseString;
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _ContentArea.text =@"Error in %@",error.domain;
        }];
    }
    @catch(NSException *exception){
        _ContentArea.text = @"Exception occurred.";
    }
}

- (IBAction)pinnedCertPressed:(id)sender {
    NSString *address= @"https://singleframesecurity.net:443/success.html";
    //NSString *address= @"https://test.singleframesecurity.net:442/success.html";
    //NSString *address= @"https://secure.singleframesecurity.net:444/success.html";
    _ContentArea.text = @"Tapped Pinned Cert.Getting content from remote server...";
    _urlTextView.text = address;
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"der"];
    //cert.der - 443
    //442_ca.der - 442
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSLog(@"CertPath:");
    NSLog(@"%@", cerPath);
    //kickstart AFNetworking
    NSURL *URL = [NSURL URLWithString:address];
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[NSSet setWithObject:certData]];
    //AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:[NSSet setWithObject:certData]];
    _manager.securityPolicy = sec;
    
    @try{
        [_manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseString);
            _ContentArea.text = responseString;
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _ContentArea.text =@"Error during operation";
        }];
    }
    @catch(NSException *exception){
        _ContentArea.text = @"Exception occurred.";
    }
}
@end
