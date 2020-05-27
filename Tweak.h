#import <Foundation/Foundation.h>
#include <objc/objc-runtime.h>
#import <libhdev/HUtilities/HDownloadMedia.h>

#define PLIST_PATH "/var/mobile/Library/Preferences/com.haoict.twitternoadspref.plist"
#define PREF_CHANGED_NOTIF "com.haoict.twitternoadspref/PrefChanged"

@interface TFNItemsDataViewController : NSObject
@property(copy, nonatomic) NSArray *sections;
- (id)itemAtIndexPath:(id)arg1;
@end

@interface TFSTwitterEntityMediaVideoVariant : NSObject
@property(readonly, nonatomic) long long bitrate;
@property(readonly, copy, nonatomic) NSString *contentType;
@property(readonly, copy, nonatomic) NSString *url;
@end

@interface TFSTwitterEntityMediaVideoInfo : NSObject
@property(readonly, copy, nonatomic) NSArray *variants;
@end

@interface TFSTwitterEntityMedia : NSObject
@property(readonly, nonatomic) TFSTwitterEntityMediaVideoInfo *videoInfo; 
@end

@interface TFSTwitterMediaInfo : NSObject
@property(retain, nonatomic) TFSTwitterEntityMedia *mediaEntity;
@end

@protocol T1StatusViewModel
@property(readonly, nonatomic) TFSTwitterMediaInfo *primaryMediaInfo;
@end

@interface TFNTwitterStatus : NSObject<T1StatusViewModel>
@property (nonatomic, readonly, strong) NSString *primaryMediaVideoURL;
@end

// @interface T1StatusInlineMediaViewModel : NSObject
// @property(readonly, nonatomic) id<T1StatusViewModel> viewModel;
// @end

// @interface T1InlineMediaContainerView : UIView
// @property (nonatomic, readonly, strong) UIViewController *tfn_viewController;
// @end

// @interface T1InlineMediaView : UIView
// @property(readonly, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
// @property(retain, nonatomic) T1StatusInlineMediaViewModel *viewModel;
// @end

@interface T1SlideshowViewController : UIViewController
@property (nonatomic, readonly, strong) id<T1StatusViewModel> slideStatus;
@end

@interface T1URTFooterViewModel : NSObject
@property(nonatomic, readonly) NSURL *url;
@end

@interface TFNTwitterModuleFooter : NSObject
@property(nonatomic, readonly) NSURL *url;
@end