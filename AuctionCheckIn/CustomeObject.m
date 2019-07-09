//
//  CustomeObject.m
//  AuctionCheckIn
//
//  Created by Matthew Sansoucie on 7/3/19.
//  Copyright © 2019 Matthew Sansoucie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomObject.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "MfiBtPrinterConnection.h"
#import <UIKit/UIKit.h>
#import "ZebraPrinter.h"
#import "ZebraPrinterFactory.h"
#import <GraphicsUtil.h>


@implementation CustomObject

- (void) someMethod {
    NSLog(@"THIS RAN IN THE OBJECTIVE-C CLASS!");
}




-(void)sampleWithGCD {
    //Dispatch this task to the default queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        // Instantiate connection to Zebra Bluetooth accessory
        id<ZebraPrinterConnection, NSObject> thePrinterConn = [[MfiBtPrinterConnection alloc] initWithSerialNumber:@"XXQVJ183302076"];
        // Open the connection - physical connection is established here.
        BOOL success = [thePrinterConn open];

        NSString *zplData = self.label;//@"^XA^FO200,200^BY3^B3N,N,200,Y,N^FD123ABC^FS^XZ";
        //NSString *zplData1 = @"^XA^FO20,20^A0N,25,25^FDThis is a ZPL test that has been sent from the Checkin App - Matt\n/ntesting.^FS^XZ";
        
        NSError *error = nil;
        
        success = success && [thePrinterConn write:[zplData dataUsingEncoding:NSUTF8StringEncoding] error:&error];
        
        //Dispath GUI work back on to the main queue!
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success != YES || error != nil) {
                //[error localizedDescription]
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure your printer is connected with Bluetooth" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [errorAlert show];
            }
        });
        // Close the connection to release resources.
        [thePrinterConn close];
        //[thePrinterConn release];
    });
}


-(void)sendZplOverBluetooth{
    NSString *serialNumber = @"";
    //Find the Zebra Bluetooth Accessory
    EAAccessoryManager *sam = [EAAccessoryManager sharedAccessoryManager];
    NSArray * connectedAccessories = [sam connectedAccessories];
    for (EAAccessory *accessory in connectedAccessories) {
        if([accessory.protocolStrings indexOfObject:@"com.zebra.rawport"] != NSNotFound){
            serialNumber = accessory.serialNumber;
            break;
            //Note: This will find the first printer connected! If you have multiple Zebra printers connected, you should display a list to the user and have him select the one they wish to use
        }
    }
    // Instantiate connection to Zebra Bluetooth accessory
    id<ZebraPrinterConnection, NSObject> thePrinterConn = [[MfiBtPrinterConnection alloc] initWithSerialNumber:serialNumber];
    // Open the connection - physical connection is established here.
    BOOL success = [thePrinterConn open];
    // This example prints "This is a ZPL test." near the top of the label.
    NSString *zplData = @"^XA^FO20,20^A0N,25,25^FDThis is a ZPL test.^FS^XZ";
    NSError *error = nil;
    // Send the data to printer as a byte array.
    success = success && [thePrinterConn write:[zplData dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    if (success != YES || error != nil) {
       /* UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release]; */
    }
    // Close the connection to release resources.
    [thePrinterConn close];
    //[thePrinterConn release];
}
@end
