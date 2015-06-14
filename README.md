# TextviewImages
Textview Images is a Category on textview that enables functionality of selecting images in textview.


# TextviewImages Example 
Download this project and run it to see how easy it is to do that.

# Usage Podfile
```
platform :ios, '7.0'
pod 'TextviewImages', :git => 'git@github.com:ibhupi/TextviewImages.git'
```

# How to use example
To add image select option menu in text view just writing these two lines of code is enough. Add following in your View Controller or Class which has outlet or refresh to UITextView.
```
#import "UITextView+Helper.h"
[self.textView addSelectImageMenuText:@"🌅 📷"];
```

# Actual method to call
```
/**
 * Add menu item option to select image. 
 * When user will tap on this it will ask user to select image source as camera roll or camera.
 * @param selectImageMenuText, NSString menu text to show option to select image
 */
- (void)addSelectImageMenuText:(NSString *)selectImageMenuText;

```

# Screenshots

Screen with Long tap to select images<br />
<img src="https://raw.githubusercontent.com/ibhupi/TextviewImages/develop/Screenshots/Screen1.png" width="250" alt="creen with Long tap to select images"/><<br /><br />

Alert to select image source type when there is only one option in menu to select images<br />
<img src="https://raw.githubusercontent.com/ibhupi/TextviewImages/develop/Screenshots/Screen2.png" width="250" alt="image source type"/><br /><br />

Screen when showing images to select<br />
<img src="https://raw.githubusercontent.com/ibhupi/TextviewImages/develop/Screenshots/Screen3.png" width="250" alt="showing images to select"/><br /><br />

Screen after image is selected and added in text view. And ready to select more images<br />
<img src="https://raw.githubusercontent.com/ibhupi/TextviewImages/develop/Screenshots/Screen4.png" width="250" alt="image is selected and added in text view"/><br /><br />
</b>

Sample code to be used in main project to add functionality in text view that can provide <b>option to select images either from Camera Roll & Album or Camera or Both </b>.
```
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textView addSelectImageMenuText:@"🌅 📷"]; // Yes you can add emojis if you want.
}

```
