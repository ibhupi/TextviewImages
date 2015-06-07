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

/**
 * Add menu item option to select image. 
 * When user will tap on this it will ask user to select image source as camera roll or camera.
 * @param selectImageMenuText, NSString menu text to show option to select image
 */
- (void)addSelectImageMenuText:(NSString *)selectImageMenuText;

/**
 * Add menu item option to select image from camera roll and camera.
 * Use this method if you want to show both in otion or disable either one of them by passing nil
 * When user tap on appropriate item, it show that source to select image
 * @param selectImageMenuText, NSString menu text to show option to select image from camera roll
 * @param cameraMenuText, NSString menu text to show option to select image from camera
 */
- (void)addSelectImageMenuText:(NSString *)selectImageMenuText
                cameraMenuText:(NSString *)cameraMenuText;

/**
 * Client can set this imagePickerDelegate to listen various TextViewImagePickerDelegate protocols
 */
@property (nonatomic, assign) id<TextViewImagePickerDelegate> imagePickerDelegate;

/**
 * Get list of attached images in text view.
 */
- (NSArray *)attachedImages;

@end


@protocol TextViewImagePickerDelegate <NSObject>

@optional
/**
 * Delegate infromed when text view will present image picker controller
 */
- (void)textViewWillShowImageSelecteController:(UITextView *)textView;

/**
 * Delegate infromed when text view did present image picker controller
 */
- (void)textViewDidShowImageSelecteController:(UITextView *)textView;

/**
 * Delegate infromed when text view will hide image picker controller
 */
- (void)textViewWillHideImageSelecteController:(UITextView *)textView;

/**
 * Delegate infromed when text view did hide image picker controller
 */
- (void)textViewDidHideImageSelecteController:(UITextView *)textView;

@end