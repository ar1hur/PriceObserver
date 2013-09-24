//
//  AppDelegate.m
//  PriceObserver
//
//  Created by Arthur on 23.09.13.
//  Copyright (c) 2013 Arthur Zielinski. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize productNameTextField;
@synthesize products;
@synthesize progressIndicator;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)getPriceClicked:(id)sender
{
    [progressIndicator startAnimation:nil];
    
    // prepare query string
    NSString *productName = [productNameTextField.stringValue stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchUrl = [NSString stringWithFormat:@"http://www.idealo.de/preisvergleich/MainSearchProductCategory.html?q=%@", productName];
    
    // get html
    NSURL *url = [NSURL URLWithString:searchUrl];
    
    // perform some xpath action on html
    NSError *error;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyHTML error:&error];
    NSXMLElement *rootNode = [document rootElement];
    
    // Get price
    NSString *xpathQueryString = @".//*[@id='plist']/tr[1]/td[3]/div/text()";
    NSArray *priceNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
    if(error) {
        [[NSAlert alertWithError:error] runModal];
        [progressIndicator stopAnimation:nil];
        return;
    }
    
    // format price
    NSString *price = [[priceNodes objectAtIndex:0] stringValue];
    [price stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Get image
    xpathQueryString = @".//*[@id='plist']/tr[1]/td[1]/div/a/img/@data-original";
    NSArray *imageNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
    if(error) {
        [[NSAlert alertWithError:error] runModal];
        [progressIndicator stopAnimation:nil];
        return;
    }

    
    // Get src attribute from image -> which is the image url
    NSString *imageSource = [[imageNodes objectAtIndex:0] stringValue];

    [imageSource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imageUrl = [NSURL URLWithString:imageSource];
    NSImage *thumb = [[NSImage alloc] initWithContentsOfURL:imageUrl];
    

    Product *aProduct = [Product new];
    aProduct.name = productNameTextField.stringValue;
    aProduct.price = price;
    aProduct.date = [NSDate date];
    aProduct.image = thumb;
    [products addObject:aProduct];
    
    [progressIndicator stopAnimation:nil];
}


@end
