@interface TFNTwitterStatus : NSObject 
- (BOOL) isPromoted;
@end

@interface TFNItemsDataViewController : NSObject
- (id)itemAtIndexPath:(id)arg1;
@end

%hook TFNItemsDataViewController
- (id)tableViewCellForItem:(id)arg1 atIndexPath:(id)arg2 {
  UITableViewCell *tbvCell = %orig;
  id item = [self itemAtIndexPath: arg2];

  if([NSStringFromClass([item classForCoder]) isEqual:@"TFNTwitterStatus"]){
    TFNTwitterStatus *status = item;
    if ([status isPromoted]) {
      [tbvCell setHidden: YES];
    }
  }

  return tbvCell;  
}

- (double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 {
  id item = [self itemAtIndexPath: arg2];

  if([NSStringFromClass([item classForCoder]) isEqual:@"TFNTwitterStatus"]){
    TFNTwitterStatus *status = item;
    if ([status isPromoted]) {
      return 0;
    }
  }

  return %orig;
}
%end