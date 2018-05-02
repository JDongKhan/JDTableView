# JDTableView

对tableview的拓展，利用runtime的class_addMethod动态实现datasource和delegate方法，不用实现一个方法即可展示数据，当然你可以根据自己的喜好来实现也行！


 >IOS项目用的最多的控件中tableview恐怕是有着举足轻重位置，可是你如果还在自己实现tableview的delegate和datasource恐怕就low了，尤其是delegate和datasource逻辑大同小异，而本项目就是针对一个数组来分析实现掉delegate和datasource，甚至完全靠一个数组源都能全部处理掉tableview的渲染和事件处理。
 
 这种写法也能帮开发者只关注数据和界面，不需要考虑tableview的渲染逻辑


# -------惯例先上图，图丑但是它不是重点------
此效果图的实现可看代码，及其简单，不用实现一行协议代码

![](https://github.com/wangjindong/JDTableView/blob/master/tableview.gif)



设计理念：动态添加委托方法，实现tableview的委托，不需要程序猿实现任何接口方法，所有可能来源均有数据结构（即数组）提供！

该方法支持在数据里面增加tableview的选择事件，默认的cell样式、accessoryView,block等等！


如果你有好的建议请联系我:419591321@qq.com,其实自己仔细琢磨更有意思！

 
# CocoaPods

1、在 Podfile 中添加 `pod 'JDTableView'`。

2、执行 `pod install` 或 `pod update`。

3、导入 \<JDTableView/JDTableView.h\>。
