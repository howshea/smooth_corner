# smooth_corner
## 项目介绍

在 Flutter 中实现 iOS 的平滑圆角，模仿了 Figma 的 「corner smoothing」 功能，算法也来自于 Figma 的blog「[Desperately seeking squircles](https://www.figma.com/blog/desperately-seeking-squircles/)」。

原理是用两段贝塞尔曲线和一端圆弧拼接而成，当参数 smoothness 为 0 时即为正常的圆角矩形，当参数为 1 时，圆角仅由两段贝塞尔曲线组成，接近超椭圆。

你可以在 example 工程中查看我写的 Debug 圆角组件，调整其平滑度和圆角大小，来查看其中的变化。
