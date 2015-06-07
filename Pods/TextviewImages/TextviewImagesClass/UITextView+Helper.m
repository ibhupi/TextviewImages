//
//  UITextView+Helper.m
//  twme
//
//  Created by Bhupendra Singh on 6/2/15.
//  Copyright (c) 2015 Bhupendra Singh. All rights reserved.
//

#import "UITextView+Helper.h"
#import <objc/runtime.h>

static void *ImagePickerControllerPropertyKey = &ImagePickerControllerPropertyKey;

static void *TextViewImagePickerDelegatePropertyKey = &TextViewImagePickerDelegatePropertyKey;


@interface UITextView (Helper_Private) <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@end

@implementation UITextView (Helper_Private)

- (void)setImagePickerController:(UIImagePickerController *)imagePickerController
{
    objc_setAssociatedObject(self, ImagePickerControllerPropertyKey, imagePickerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImagePickerController *)imagePickerController
{
    return objc_getAssociatedObject(self, ImagePickerControllerPropertyKey);
}

- (NSArray *)attachedImages
{
    NSMutableArray *images = [NSMutableArray new];
    if (self.textStorage.length)
    {
        [self.textStorage enumerateAttribute:NSAttachmentAttributeName
                                              inRange:NSMakeRange(0, self.textStorage.length)
                                              options:0
                                           usingBlock:^(id value, NSRange range, BOOL *stop) {
                                               NSTextAttachment* attachment = (NSTextAttachment*)value;
                                               if (attachment.image)
                                               {
                                                   [images addObject:attachment.image];
                                               }
                                           }];
    }
    return images;
}

- (void)_addSelectImageMenuText:(NSString *)selectImageMenuText
{
    if (!selectImageMenuText.length)
    {
        return;
    }
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    NSMutableArray *menuItems = [NSMutableArray new];
    if (selectImageMenuText.length)
    {
        UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:selectImageMenuText action:@selector(_selectImageWithAlertForGalleryOrCamera:)];
        [menuItems addObject:menuItem];
    }
    [menuController setMenuItems:menuItems];
}


- (void)_addSelectImageMenuText:(NSString *)selectImageMenuText
                cameraMenuText:(NSString *)cameraMenuText
{
    if (!selectImageMenuText.length && !cameraMenuText.length)
    {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        NSMutableArray *menuItems = [NSMutableArray new];
        if (selectImageMenuText.length)
        {
            UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:selectImageMenuText action:@selector(_selectImageFromGallery:)];
            [menuItems addObject:menuItem];
        }
        if (cameraMenuText.length)
        {
            UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:cameraMenuText action:@selector(_selectImageFromCamera:)];
            [menuItems addObject:menuItem];
        }
        [menuController setMenuItems:menuItems];
    });
}

- (void)_selectImageWithAlertForGalleryOrCamera:(id)sender
{
    [self resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select Image Source" message:@"Please select image source" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photos", @"Camera", nil];
    [alertView show];
}

- (void)_selectImageFromGallery:(id)sender
{
    [self resignFirstResponder];
    [self _showImagePickerForImagePickerControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)_selectImageFromCamera:(id)sender
{
    [self resignFirstResponder];
    [self _showImagePickerForImagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)_showImagePickerForImagePickerControllerSourceType:(UIImagePickerControllerSourceType)imagePickerSourceType
{
    [self _informDelegateWillShowPicker];

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = imagePickerSourceType;
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:imagePickerController animated:YES completion:^{
        [self _informDelegateDidShowPicker];
    }];
    self.imagePickerController = imagePickerController;
}

- (void)_imageSelected:(UIImage *)image
{
    [self _addImage:image];
}

- (void)_addImage:(UIImage *)image
{
    if (!image)
    {
        return;
    }
    CGFloat padding = 10; // 10px for the padding for displaying image nicely
    CGFloat scaleFactor = image.size.width / (CGRectGetWidth(self.frame) - padding);
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageWithCGImage:image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    NSAttributedString *attributedStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    // Store font to reset it, because there is bug in textkit.
    // Font size changes to unexpected small size when adding text attachment
    UIFont *font =  self.font;
    NSRange textRange = [self _selectedRangeInTextView:self];
    [self.textStorage insertAttributedString:attributedStringWithImage atIndex:textRange.location];
    self.font = font;
    if ((textRange.location + textRange.length) >= (self.text.length-1))
    {
        [self _appendString:@"\n" locationIndex:-1];
        self.selectedRange = NSMakeRange(textRange.location + 2, 0);
    }
    else
    {
        [self _appendString:@" " locationIndex:(textRange.location +1)];
        self.selectedRange = NSMakeRange(textRange.location + 2, 0);
    }
}

- (NSRange)_selectedRangeInTextView:(UITextView*)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextRange *selectedRange = textView.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    const NSInteger location = [textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

/**
 * locationIndex = -1, apped at last
 */
- (void)_appendString:(NSString *)string locationIndex:(NSInteger)locationIndex
{
    if (!string.length)
    {
        return;
    }
    UIFont *font =  [UIFont systemFontOfSize:self.font.pointSize];
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           font, NSFontAttributeName, nil];
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:string
                                           attributes:attrs];
    if (locationIndex < 0)
    {
        [self.textStorage appendAttributedString:attributedText];
    }
    else
    {
        [self.textStorage insertAttributedString:attributedText atIndex:locationIndex];
    }
}

- (void)_informDelegateWillShowPicker
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(textViewWillShowImageSelecteController:)])
    {
        [self.imagePickerDelegate textViewWillShowImageSelecteController:self];
    }
}

- (void)_informDelegateDidShowPicker
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(textViewDidShowImageSelecteController:)])
    {
        [self.imagePickerDelegate textViewDidShowImageSelecteController:self];
    }
}

- (void)_informDelegateWillHidePicker
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(textViewWillHideImageSelecteController:)])
    {
        [self.imagePickerDelegate textViewWillHideImageSelecteController:self];
    }
}

- (void)_informDelegateDidHidePicker
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(textViewDidHideImageSelecteController:)])
    {
        [self.imagePickerDelegate textViewDidHideImageSelecteController:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self _informDelegateWillHidePicker];
    if (!info)
    {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self _informDelegateDidHidePicker];
        }];
        return;
    }
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self _imageSelected:image];
        [self becomeFirstResponder];
        [self _informDelegateDidHidePicker];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self _informDelegateWillHidePicker];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self _informDelegateDidHidePicker];
    }];
    [self becomeFirstResponder];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        return;
    }
    else if (buttonIndex == 1)
    {
        [self _selectImageFromGallery:nil];
    }
    else if (buttonIndex == 2)
    {
        [self _selectImageFromCamera:nil];
    }
}

@end

@implementation UITextView (Helper)

- (void)addSelectImageMenuText:(NSString *)selectImageMenuText
{
    [self _addSelectImageMenuText:selectImageMenuText];
}

- (void)addSelectImageMenuText:(NSString *)selectImageMenuText cameraMenuText:(NSString *)cameraMenuText
{
    [self _addSelectImageMenuText:selectImageMenuText cameraMenuText:cameraMenuText];
}

- (void)setImagePickerDelegate:(id<TextViewImagePickerDelegate>)imagePickerDelegate
{
    objc_setAssociatedObject(self, TextViewImagePickerDelegatePropertyKey, imagePickerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<TextViewImagePickerDelegate>)imagePickerDelegate
{
    return objc_getAssociatedObject(self, TextViewImagePickerDelegatePropertyKey);
}

@end
