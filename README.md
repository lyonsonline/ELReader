# ELReader
![demoGif](https://github.com/lyonsonline/ELReader/blob/master/ELReader.gif)
## Requirements
- iOS 8.0+
- Alamofire / SnapKit / Fuzi
- Carthage
- Xcode 8.0+
- Swift 3.0+

## Usage
进入项目终端`carthage update`安装第三方.
>详细使用,这里有介绍[Carthage](https://github.com/Carthage/Carthage)

## Introduction
从小说网站爬取数据,并展示.使用 `UIPageViewController` 展示数据.使用 `Fuzi`解析 XML.
使用了传闭包的方法处理页面跳转,具体请看`AppTransfrom.swift`.
>我觉得这样处理看起来还是比较整洁的.把所有跳转的逻辑都放到了一个类里面,方便管理
