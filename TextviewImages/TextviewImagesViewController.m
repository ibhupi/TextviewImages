//
//  TextviewImagesViewController.m
//  TextviewImages
//
//  Created by Bhupendra Singh on 6/8/15.
//  Copyright (c) 2015 Bhupendra Singh. All rights reserved.
//

#import "TextviewImagesViewController.h"
#import "UITextView+Helper.h"

@interface TextviewImagesViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) UIEdgeInsets textViewEdgeInsets;

- (IBAction)showImagesButtonTapped:(id)sender;

@end

@implementation TextviewImagesViewController

- (void)dealloc
{
    [self _removeKeyboardObservers];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textView addSelectImageMenuText:@"🌅 📷"];
    [self _addKeyBoardObservers];
}

#pragma mark - Helpers

- (void)_addKeyBoardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)_removeKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (CGRect)_keyboardFrameEndForNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    return keyboardFrameBeginRect;
}

- (void)_keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [self _keyboardFrameEndForNotification:notification];
    UIEdgeInsets contentInset = self.textView.contentInset;
    contentInset.bottom = CGRectGetHeight(keyboardFrame) + 5;
    self.textView.contentInset = contentInset;
    [self _scrollToCursor];
}

- (void)_keyboardWillHide:(NSNotification *)notification
{
    self.textView.contentInset = self.textViewEdgeInsets;
    [self _scrollToCursor];
}

- (void)_scrollToCursor
{
    UITextView *textView = self.textView;
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:YES];
}

- (IBAction)showImagesButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    NSArray *images  = self.textView.attachedImages;
    if (images.count)
    {
        alertView.title = @"Attached Images";
        alertView.message = nil;
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        view.autoresizesSubviews = NO;
        CGRect frame = view.frame;
        for (UIImage *image in images)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            CGRect imageViewFrame = imageView.frame;
            frame = view.frame;
            imageViewFrame.origin.x = frame.size.width;
            frame.size.width += imageView.frame.size.width + 1;
            frame.size.height = frame.size.height < imageView.frame.size.height ? imageView.frame.size.height : frame.size.height;
            
            view.frame = frame;
            imageView.frame = imageViewFrame;
            [view addSubview:imageView];
        }
        view.autoresizesSubviews = YES;
        frame.size.width = frame.size.width > 300 ? 300 : frame.size.width;
        view.frame = frame;
        [alertView setValue:view forKey:@"accessoryView"];
    }
    else
    {
        alertView.title = @"No image in text view";
        alertView.message = @"Text view does not has any imagge. Please attach image";
    }
    [alertView show];
}

@end
