Language: [English](README.md) | [中文简体](README_CN.md)

# smooth_corner

[![Pub](https://img.shields.io/badge/pub-1.0.0-blue?style=flat-square)](https://pub.dev/packages/smooth_corner) ![](https://img.shields.io/badge/platform-flutter%7Cflutter--web-red?style=flat-square)

The smooth rounded corners of iOS are implemented in Flutter, imitating Figma's "corner smoothing" function. The algorithm also comes from Figma's blog "[Desperately seeking squircles](https://www.figma.com/blog/desperately-seeking-squircles/)".

The principle is spliced by two segments of Bezier curve and one segment of arc, which is the same as Figma, with variable smoothness. When the parameter smoothness is 0, it is a normal rounded rectangle. When the parameter is 1, the rounded corners are only It is composed of two Bezier curves and is close to a hyperellipse.

You can view the Debug rounded corner widget and picture examples that I wrote in the sample project, adjust the smoothness and rounded corner size, and you can see the changes in the rounded corner curve.

<img width="720" alt="Example screen shot" src="https://user-images.githubusercontent.com/17538852/148490341-82821630-e4e7-4858-862d-d74049bd4002.png">



## Usage

### Add dependency 

```yaml
dependencies:
  smooth_corner: ^1.0.0
```



### Built-in Widgets

The library provides several commonly used widgets that can adjust smooth rounded corners.

These widgets provide three additional parameters "smoothness, side, borderRadius" to control smooth rounded corners and borders.

`smoothness` represents smoothness, the range is [0, 1.0]. According to Figma's standard, the rounded curve closest to iOS when the smoothness is equal to 0.6.

![](https://user-images.githubusercontent.com/17538852/148515898-79b29e88-c709-481c-b326-2ff92246cfa2.png)

The type of `side` is `BorderSide`, which is used to set the border.

`borderRadius` is used to set the corner radius. Note that if the x and y values of the radius are not equal, the smallest value will be selected.



#### SmoothContainer

`SmoothContainer` contains all the parameters of `Container`.

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

In order to achieve that the picture can also add a border, `SmoothImage` is provided, and the image parameter accepts an `Image`.
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

`SmoothCard` contains all the parameters of `Card`

```dart
SmoothCard(
  smoothness: 0.6,
  borderRadius: BorderRadius.circular(40),
  elevation: 6,
  child: child,
),
```



### 自定义组件

The smooth rounding capabilities of the above widgets are all implemented by `SmoothRectangleBorder`, you can use this ShapeBorder to customize your smooth rounded widgets freely.



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
