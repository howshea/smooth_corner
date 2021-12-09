# smooth_corner
## 项目介绍

在 Flutter 中实现 iOS 的平滑圆角，模仿了 Figma 的 「corner smoothing」 功能，算法也来自于 Figma 的blog「[Desperately seeking squircles](https://www.figma.com/blog/desperately-seeking-squircles/)」。

原理是用两段贝塞尔曲线和一端圆弧拼接而成，和 Figma 相同，平滑度可变，当参数 smoothness 为 0 时即为正常的圆角矩形，当参数为 1 时，圆角仅由两段贝塞尔曲线组成，接近超椭圆。

你可以在 example 工程中查看我写的 Debug 圆角组件和图片示例，调整其平滑度和圆角大小，来查看其中圆角曲线的变化。

![example project screenshot](https://user-images.githubusercontent.com/17538852/144412038-f05d33dd-e547-4b23-847f-d52414f79b5e.png)

## Usage
### 依赖 package
```yaml
dependencies:
  smooth_corner: ^1.0.0
```

### 普通控件
在 shapeDecoration 中传入 SmoothRectangleBorder，设置你需要的圆角和平滑度（0.0 - 1.0)
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

### 图片控件切割
在Image 外层包裹 ClipPath，其参数 clipper 使用 ShapeBorderClipper，接着传入 SmoothRectangleBorder
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
    child: Image.network(''),
  ),
),
```