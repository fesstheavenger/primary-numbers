//
//  ViewController.m
//  SimpleNumbersGenerator
//
//  Created by OR on 24/09/2015.
//  Copyright © 2015 New Future Vision. All rights reserved.
//

#import "ViewController.h"
#import "SimpeNumbersGenerationOperation.h"
#import "SimpleNumbersData.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SimpeNumbersGenerationOperationDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *numberTextField;
@property (nonatomic, weak) IBOutlet UIButton *generateButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinnerView;

@property (nonatomic, weak) IBOutlet UIButton *downButton;
@property (nonatomic, weak) IBOutlet UIButton *upButton;

@property (nonatomic, strong) NSMutableArray *currentSimpleNumbers;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@property (nonatomic, assign) NSInteger currentCountOfSimpleNumbers;
@property (nonatomic, assign) NSInteger maxCheckedNumber;

@end

@implementation ViewController

- (NSNumberFormatter *)numberFormatter
{
    if(!_numberFormatter)
    {
        _numberFormatter = [NSNumberFormatter new];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return _numberFormatter;
}

- (NSNumber *)enteredNumber
{
    return [self.numberFormatter numberFromString:self.numberTextField.text];
}

- (IBAction)upButtonTouched:(UIButton *)button
{
    if(self.currentCountOfSimpleNumbers > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (IBAction)downButtonTouched:(UIButton *)button
{
    if(self.currentCountOfSimpleNumbers > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.currentCountOfSimpleNumbers - 1) inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)setControlButtonsEnabled:(BOOL)enable
{
    self.generateButton.enabled = enable;
    self.upButton.enabled = enable;
    self.downButton.enabled = enable;
}

- (void)generatePrimaryNumbers
{
    [self.currentSimpleNumbers removeAllObjects];
    [self setControlButtonsEnabled:NO];
    
    NSNumber *enteredNumber = [self enteredNumber];
    if(enteredNumber.integerValue > self.maxCheckedNumber)
    {
        self.currentCountOfSimpleNumbers = [SimpleNumbersData primaryNumbers].count;
        
        self.spinnerView.hidden = NO;
        [self.spinnerView startAnimating];
        
        SimpeNumbersGenerationOperation *op = [[SimpeNumbersGenerationOperation alloc] initWithNumberDownLimit:(self.maxCheckedNumber + 1) numberUpLimit:enteredNumber.integerValue];
        op.delegate = self;
        [self.queue addOperation:op];
        
        self.maxCheckedNumber = enteredNumber.integerValue - 1;
    }
    else
    {
        self.currentCountOfSimpleNumbers = 0;
        
        for(NSNumber *number in [SimpleNumbersData primaryNumbers])
        {
            if(number.integerValue < enteredNumber.integerValue)
            {
                self.currentCountOfSimpleNumbers++;
            }
        }
        [self setControlButtonsEnabled:YES];
        [self.tableView reloadData];
    }
}

- (IBAction)startGeneration:(UIButton *)sender
{
    [self generatePrimaryNumbers];
    [self.numberTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self generatePrimaryNumbers];
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.spinnerView.hidden = YES;
    self.maxCheckedNumber = 1;
    self.queue = [[NSOperationQueue alloc] init];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSNumber *num = [SimpleNumbersData primaryNumbers][indexPath.row];
    cell.textLabel.text = [num stringValue];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentCountOfSimpleNumbers;
}

#pragma mark - SimpeNumbersGenerationOperationDelegate

- (void)finishedWithCountOfSimpleNumbersFound:(NSNumber *)count
{
    self.currentCountOfSimpleNumbers += count.integerValue;
    
    [self setControlButtonsEnabled:YES];
    [self.tableView reloadData];
    
    [self.spinnerView stopAnimating];
    self.spinnerView.hidden = YES;
}

@end
