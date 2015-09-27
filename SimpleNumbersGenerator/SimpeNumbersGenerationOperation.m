//
//  SimpeNumbersGenerationOperation.m
//  SimpleNumbersGenerator
//
//  Created by OR on 24/09/2015.
//  Copyright © 2015 New Future Vision. All rights reserved.
//

#import "SimpeNumbersGenerationOperation.h"
#import "SimpleNumbersData.h"

@implementation SimpeNumbersGenerationOperation

- (instancetype)initWithNumberDownLimit:(NSInteger)downLimit numberUpLimit:(NSInteger)upLimit
{
    if(self = [super init])
    {
        self.numberDownLimit = downLimit;
        self.numberUpLimit = upLimit;
        return self;
    }
    return nil;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    if((self.numberDownLimit > 2) && (self.numberDownLimit % 2 == 0))
        self.numberDownLimit++;
    
    BOOL isDone = NO;
    NSInteger count = 0;
    
    do
    {
        for(NSInteger i = self.numberDownLimit; i < self.numberUpLimit; i++)
        {
            if([self isPrimary:i])
            {
                count++;
                [SimpleNumbersData addPrimaryNumber:@(i)];
            }
        }
        isDone = YES;
        
    } while(![self isCancelled] && !isDone);
        
    if(self.delegate && [self.delegate respondsToSelector:@selector(finishedWithCountOfSimpleNumbersFound:)])
    {
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(finishedWithCountOfSimpleNumbersFound:) withObject:@(count) waitUntilDone:NO];
    }
}

- (BOOL)isPrimary:(NSInteger)number
{
    if(number == 2 || number == 3 || number == 5)
    {
        return YES;
    }
    if(number % 2 == 0)
        return NO;
    if(number % 5 == 0)
        return NO;
    if([self sumOfDigitsOfNumber:number] % 3 == 0)
        return NO;
    
    for(NSNumber *num in [SimpleNumbersData primaryNumbers])
    {
        if(num.integerValue > (NSInteger)sqrt(number))
        {
            break;
        }
        if(number % num.integerValue == 0)
        {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)sumOfDigitsOfNumber:(NSInteger)number
{
    NSInteger sum = 0;
    
    while(number > 0)
    {
        sum += number % 10;
        number = number / 10;
    }
    
    return sum;
}

@end
