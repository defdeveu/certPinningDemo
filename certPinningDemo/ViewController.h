//
//  ViewController.h
//  certPinningDemo
//
//  Created by Zsombor on 2018. 01. 22..
//  Copyright © 2018. Zsombor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
    @property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;

@end

