//
//  DetailViewController.h
//  Feeds
//
//  Created by Aneesh on 06/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface DetailViewController : UIViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate> {
    NSString *content;
    NSString *link;
    NSString *media;
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *linkLbl;
    IBOutlet UIImageView *imgView;
    NSString *text;
}
@property(nonatomic,retain) NSString *content;
@property(nonatomic,retain) NSString *link;
@property(nonatomic,retain) NSString *media;
@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property(nonatomic,retain) IBOutlet UILabel *linkLbl;
@property(nonatomic,retain) IBOutlet UIImageView *imgView;
//IBAction methods
-(IBAction)back:(id) sender;
-(IBAction)showPicker:(id)sender;
//other methods
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(NSString *)stringByStrippingHTML:(NSString *)str;
@end
