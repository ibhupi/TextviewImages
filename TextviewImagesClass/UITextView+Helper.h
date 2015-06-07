//
//  UITextView+Helper.h
//  twme
//
//  Created by Bhupendra Singh on 6/2/15.
//  Copyright (c) 2015 Bhupendra Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewImagePickerDelegate;


@interface UITextView (Helper)

- (void)addSelectImageMenuText:(NSString *)selectImageMenuText;

- (void)addSelectImageMenuText:(NSString *)selectImageMenuText
                cameraMenuText:(NSString *)cameraMenuText;

@property (nonatomic, assign) id<TextViewImagePickerDelegate> imagePickerDelegate;

@end


@protocol TextViewImagePickerDelegate <NSObject>

@optional

- (void)textViewWillShowImageSelecteController:(UITextView *)textView;
- (void)textViewDidShowImageSelecteController:(UITextView *)textView;
- (void)textViewWillHideImageSelecteController:(UITextView *)textView;
- (void)textViewDidHideImageSelecteController:(UITextView *)textView;

@end