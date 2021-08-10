//
//  AIFDrawBasePointView.h
//  AIFMapLib
//
//  Created by moyazi on 2020/2/12.
//  Copyright © 2020 moyazi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIFBaseDrawViewStateObject.h"
#import "CommonHeader.h"


NS_ASSUME_NONNULL_BEGIN
static CGFloat kDotViewCircle = 20;
@interface AIFDrawBasePointView : UIView
- (void)refreshView:(id)state;
@end

NS_ASSUME_NONNULL_END
