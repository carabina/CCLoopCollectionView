# CCLoopCollectionView
Loop UICollectionView(include UIPageControl) for swift.

一、纯代码：

//根据frame创建view

let v = CCLoopCollectionView(frame: CGRect(x: 30, y: 60, width: 175, height: 100)) 
//给轮播图赋值内容（可以为UIImage或UIString）
v.contentAry = tempAry as [AnyObject]
//是否开始自动循环
v.enableAutoScroll = true
//循环间隔时间
v.timeInterval = 2.0
//UIPageControl当前颜色
v.currentPageControlColor = UIColor.brown
//UIPageControl其它颜色
v.pageControlTintColor = UIColor.cyan
//添加到父视图
view.addSubview(v)

二、storyboard：
1.拖拽一个UIView到VC上，将其class改为CCLoopCollectionView，并赋值IBOutlet。
2.在对应的swift文件中添加如下代码：
//给轮播图赋值内容（可以为UIImage或UIString）
v.contentAry = tempAry as [AnyObject]
//是否开始自动循环
v.enableAutoScroll = true
//循环间隔时间
v.timeInterval = 2.0
//UIPageControl当前颜色
v.currentPageControlColor = UIColor.red
//UIPageControl其它颜色
v.pageControlTintColor = UIColor.black

