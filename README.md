# PopMenu-Tool
弹出菜单工具
示例代码:
    UITableViewController *menuVc = [[UITableViewController alloc] init];
    
    menuVc.view.autoresizingMask = UIViewAutoresizingNone;
    
    CGRect frame = menuVc.view.frame;
    
    frame.size = CGSizeMake(200, 200);
    
    menuVc.view.frame = frame;
    
    [SCPopMenu popFromView:self.navigationItem.titleView contentVc:menuVc dismiss:^{
    
    // 菜单销毁的时候想做的事情
    
    }];
    
