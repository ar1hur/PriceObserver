//
//  AppDelegate.h
//  PriceObserver
//
//  Created by Arthur on 23.09.13.
//  Copyright (c) 2013 Arthur Zielinski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Product.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *productNameTextField;
@property (weak) IBOutlet NSArrayController *products;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end
