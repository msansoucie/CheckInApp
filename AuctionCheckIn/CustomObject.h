//
//  CustomObject.h
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 7/3/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "MfiBtPrinterConnection.h"
#import <UIKit/UIKit.h>
#import "ZebraPrinter.h"
#import "ZebraPrinterFactory.h"
#import <GraphicsUtil.h>

#ifndef CustomObject_h
#define CustomObject_h


@interface CustomObject : NSObject



@property (nonatomic, strong) UIImage *image;

@property NSString *year;
@property NSString *mileage;
@property NSString *label;

- (void) someMethod;

-(void)sendZplOverBluetooth;

-(void)sampleWithGCD;

-(void)testPrintImage;

@end


#endif /* CustomObject_h */
