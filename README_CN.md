Language: [English](README.md) | [中文简体](README_CN.md)

# smooth_corner

[![Pub](https://img.shields.io/badge/pub-1.0.0-blue?style=flat-square)](https://pub.dev/packages/smooth_corner) ![](https://img.shields.io/badge/platform-flutter%7Cflutter--web-red?style=flat-square)

## 项目介绍

在 Flutter 中实现 iOS 的平滑圆角，模仿了 Figma 的 「corner smoothing」 功能，算法也来自于 Figma 的blog「[Desperately seeking squircles](https://www.figma.com/blog/desperately-seeking-squircles/)」。

原理是用两段贝塞尔曲线和一端圆弧拼接而成，和 Figma 相同，平滑度可变，当参数 smoothness 为 0 时即为正常的圆角矩形，当参数为 1 时，圆角仅由两段贝塞尔曲线组成，接近超椭圆。

你可以在 example 工程中查看我写的 Debug 圆角组件和图片示例，调整其平滑度和圆角大小，来查看其中圆角曲线的变化。

<img width="720" alt="Example screen shot" src="https://user-images.githubusercontent.com/17538852/148490341-82821630-e4e7-4858-862d-d74049bd4002.png">



## Usage



### 依赖 package

```yaml
dependencies:
  smooth_corner: ^1.0.0
```


### 内置组件

该库提供了数个可以调整平滑圆角的常用 Widget。

均额外提供了三个参数 `smoothness、side、borderRadius`，用于控制平滑圆角和边框。

`smoothness` 代表平滑度，范围为 [0, 1.0]，按照 Figma 的标准，0.6 最接近 iOS 的圆角曲线。

![](https://user-images.githubusercontent.com/17538852/148515898-79b29e88-c709-481c-b326-2ff92246cfa2.png)

`side` 的类型为 `BorderSide`，用于设置边框。

`borderRadius` 用于设置圆角半径，需要注意的是，radius 的 x 和 y 值如果不相等，会选择最小的那个。



#### SmoothContainer

`SmoothContainer` 包含 Container 的所有参数

```dart
SmoothContainer(
  width: 200,
  height: 200,
  smoothness: 0.6,
  side: BorderSide(color: Colors.cyan, width: 2),
  borderRadius: BorderRadius.circular(40),
  child: child,
  alignment: Alignment.center,
),
```



#### SmoothImage

为了实现图片也可以添加边框，提供了`SmoothImage`，image 参数接受一个 Image Widget
```dart
SmoothImage(
  smoothness: 0.6,
  side: BorderSide(color: Colors.deepOrange, width: 4),
  borderRadius: BorderRadius.circular(40),
  image: Image.network(
    url,
    fit: BoxFit.cover,
  ),
```



#### SmoothCard

`SmoothCard` 包含 Card 的所有参数

```dart
SmoothCard(
  smoothness: 0.6,
  borderRadius: BorderRadius.circular(40),
  elevation: 6,
  child: child,
),
```



### 自定义组件

上述组件的平滑圆角能力均由 `SmoothRectangleBorder` 实现，你可以使用这个 ShapeBorder 自由定制你的平滑圆角组件

#### ShapeDecoration

```dart
Container(
  width: 200,
  height: 200,
  alignment: Alignment.center,
  decoration: ShapeDecoration(
    shape: SmoothRectangleBorder(
      borderRadius: BorderRadius.circular(40),
      smoothness: 0.6,
    ),
    color: Colors.amber,
  ),
  child: Text(''),
),
```

#### ShapeBorderClipper

```dart
Container(
  width: 200,
  height: 200,
  child: ClipPath(
    clipper: ShapeBorderClipper(
      shape: SmoothRectangleBorder(
        smoothness: 0.6,
        borderRadius:
            BorderRadius.circular(40),
      ),
    ),
    child: Image.network(url),
  ),
),
```
