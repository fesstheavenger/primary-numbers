//
//  SimpeNumbersGenerationOperation.h
//  SimpleNumbersGenerator
//
//  Created by OR on 24/09/2015.
//  Copyright © 2015 New Future Vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SimpeNumbersGenerationOperationDelegate <NSObject>

- (void)finishedWithCountOfSimpleNumbersFound:(NSNumber *)count;

@end


@interface SimpeNumbersGenerationOperation : NSOperation

@property (nonatomic, assign) NSInteger numberDownLimit;
@property (nonatomic, assign) NSInteger numberUpLimit;

@property (nonatomic, assign) id<SimpeNumbersGenerationOperationDelegate> delegate;

- (instancetype)initWithNumberDownLimit:(NSInteger)downLimit numberUpLimit:(NSInteger)upLimit;

@end
