# JSONEXport中文版

  Mac下JSON字符串转Model对象工具。
  JSONExport是适用于Mac OS X的桌面应用程序，它使您能够将JSON对象作为模型类导出，并使用您喜欢的语言创建相关的构造函数，实用程序方法，setter和getter。
  
#### JSONExport是用Swift编写的Mac OS X桌面应用程序。使用JSONExport，您将能够：

  * 将任何有效的JSON对象转换为当前支持的语言之一的类。
  * 在保存之前预览生成的内容。
  * 仅包含构造函数，仅包含实用程序方法，包括两者或不包含。
  * 更改根类名，默认RootClass。
  * 为生成的类设置类名前缀。
  * 设置Java文件的包名称。
  
## 生成的文件

#### 每个生成的文件，besid getter和setter（对于Java）都可以包括：

  * 一个构造函数，它接受一个NSDictionary，JSON，JSONObject实例的实例，具体取决于文件语言，该类将使用该对象来填充其属性数据。
  * 一种实用程序方法，它将类数据再次转换为字典。

## 目前支持编程的语言

#### 目前，您可以将JSON对象转换为以下语言之一：

1. Java Gson for Android.
2. Java Realm for Android.
3. Java for Android
4. Objective-C - CoreData.
5. Objective-C - MAC.
6. Objective-C - Realm.
7. Objective-C - iOS.
8. Swift Classe.
5. Swift Classes for SwiftyJSON library.
6. Swift Classes for Realm.
7. Swift - CoreData.
8. Swift Structures.
9. Swift Structures for Gloss
10. Swift Mappable Classes for (Swift 3) ObjectMapper
11. Swift Structures for Unbox

  屏幕截图显示了用于Twitter时间轴JSON的片段并将其转换为Swift-CoreData的JSONExport。
![blockchain](https://github.com/JinlongLu-iOS/MyImage/blob/master/屏幕快照%202019-08-14%20下午4.56.34.png)

安装
========================
请克隆项目，并使用xCode 8及更高版本构建它。


已知限制:
========================
* 导出到NSManagedObject的子类时，无法导出某些数据类型。例如，核心数据没有“字符串数组”的数据类型;反过来，如果您的JSON包含字符串数组，则导出的文件将无法在不修复类型不匹配的情况下进行编译。
* 导出RLMObject的子类时，必须手动输入premitive类型的默认值。这是因为动态属性限制会阻止您使用可选的premitive类型。
* 导出到CoreData或Realm并且您想要使用实用程序方法时，您需要手动监视深层关系循环调用;也就是说，当您将对象转换为字典时，此对象会尝试将其关系之一转换为字典，并且该关系会尝试将原始对象转换为字典，这将导致一种循环，其中每个对象都调用另一个对象的toDictionary方法无穷无尽......
* 不要尝试使用空值对JSON对象建模，因为JSONExport不理解空值并且无法猜测它们的类型。
* 数组和对象的深度嵌套不会导出到适当的模型文件中。



最后 说明
========================
该应用程序仍处于早期阶段。请报告任何问题，以便我可以改进它。






