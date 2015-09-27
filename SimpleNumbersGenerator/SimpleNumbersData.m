//
//  SimpleNumbersData.m
//  SimpleNumbersGenerator
//
//  Created by OR on 27/09/2015.
//  Copyright © 2015 New Future Vision. All rights reserved.
//

#import "SimpleNumbersData.h"

static NSMutableArray *cachedPrimaryNumbers;

@implementation SimpleNumbersData

+ (void)load
{
    cachedPrimaryNumbers = [NSMutableArray array];
}

+ (void)addPrimaryNumber:(NSNumber *)number
{
    [cachedPrimaryNumbers addObject:number];
}

+ (NSMutableArray *)primaryNumbers
{
    return cachedPrimaryNumbers;
}

@end
