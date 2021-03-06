/*
 * Created by Grzegorz Wikiera on 30/03/15.
 * Copyright (c) 2015 Grzegorz Wikiera.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "GWInfinitePickerView.h"
#import "PickerViewDataSourceSurrogate.h"
#import "PickerViewDelegateSurrogate.h"

NSInteger const kInfinitivePickerViewRowOffset = 1000;

@interface GWInfinitePickerView()

@property (strong, nonatomic) PickerViewDataSourceSurrogate * dataSourceSurrogate;
@property (strong, nonatomic) PickerViewDelegateSurrogate * delegateSurrogate;

@end

@implementation GWInfinitePickerView

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    for (int i = 0; i < [self numberOfComponents]; i++) {
        NSInteger selectedRow = [self selectedRowInComponent:i];
        [self selectRow:selectedRow inComponent:i animated:NO];
    }
}

- (NSInteger)normalizedRowForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger numberOfRowsInComponent = [self numberOfRowsInComponent:component];
    if (numberOfRowsInComponent <= 0) {
        return row;
    }
    
    NSInteger normalizedRow = (row - kInfinitivePickerViewRowOffset) % numberOfRowsInComponent;
    if (normalizedRow < 0) {
        normalizedRow += numberOfRowsInComponent;
    }
    return normalizedRow;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return [super numberOfRowsInComponent:component] - 2 * kInfinitivePickerViewRowOffset;
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [super viewForRow:[self normalizedRowForRow:row forComponent:component] forComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [super selectRow:row + kInfinitivePickerViewRowOffset inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    NSInteger row = [super selectedRowInComponent:component];
    return [self normalizedRowForRow:row forComponent:component];
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    PickerViewDataSourceSurrogate * surrogate = [[PickerViewDataSourceSurrogate alloc] init];
    surrogate.pickerViewDataSource = dataSource;
    [super setDataSource:surrogate];
    self.dataSourceSurrogate = surrogate;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    PickerViewDelegateSurrogate * surrogate = [[PickerViewDelegateSurrogate alloc] init];
    surrogate.pickerViewDelegate = delegate;
    [super setDelegate:surrogate];
    self.delegateSurrogate = surrogate;
}

@end
