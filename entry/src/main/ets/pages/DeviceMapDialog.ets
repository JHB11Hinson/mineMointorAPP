// src/main/ets/pages/DeviceMapDialog.ets
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { webview } from '@kit.ArkWeb';
import { DeviceItem } from '../model/DeviceModel';

// 模拟经纬度映射 (因为db.json里只有中文位置)
// 基于重庆大学大致坐标 Mock 数据
const LocationMap: Record<string, number[]> = {
  'A区巷道': [106.464673, 29.569537],
  'B区挖掘面': [106.466173, 29.568137],
  'C区传送带': [106.463273, 29.570137]
};

@HMRouter({
  pageUrl: 'DeviceMapDialog',
  dialog: true, // 关键：标记为弹窗类型
  // 设置转场动画（可选）
  animator: 'dialogAnimator'
})
@Component
export struct DeviceMapDialog {
  // 获取传递过来的设备参数
  @State device: DeviceItem | null = null;

  // WebView 控制器
  controller: webview.WebviewController = new webview.WebviewController();

  aboutToAppear() {
    // 获取参数
    const params = HMRouterMgr.getCurrentParam();
    if (params) {
      this.device = params as DeviceItem;
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 1. 蒙层 (点击空白处关闭)
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => {
          HMRouterMgr.pop();
        })

      // 2. 弹窗主体内容
      Column() {
        // 标题栏
        Row() {
          Text('设备定位监控')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          // 关闭按钮
          Image($r('sys.media.ohos_ic_public_cancel'))
            .width(24)
            .height(24)
            .fillColor('#999')
            .onClick(() => HMRouterMgr.pop())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .border({ width: { bottom: 1 }, color: '#EEE' })

        // 地图区域
        if (this.device) {
          Web({
            src: $rawfile('device_map.html'),
            controller: this.controller
          })
            .width('100%')
            .height('400vp') // 地图高度
            .onPageEnd(() => {
              // 页面加载完成后，调用 JS 方法打点
              this.updateMapLocation();
            })
            .javaScriptAccess(true) // 允许 JS 执行
            .domStorageAccess(true)
        } else {
          Text('未获取到设备信息').padding(20)
        }

        // 底部信息
        Column() {
          Text(`设备名称: ${this.device?.name}`)
            .fontSize(14).fontColor('#333').margin({bottom: 4})
          Text(`当前位置: ${this.device?.location}`)
            .fontSize(12).fontColor('#666')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(16)
        .backgroundColor('#F9F9F9')

      }
      .width('90%') // 弹窗宽度
      .backgroundColor(Color.White)
      .borderRadius(16)
      .clip(true)
      // 阻止点击弹窗内容时关闭弹窗
      .onClick(() => {})
    }
    .width('100%')
    .height('100%')
  }

  // 调用 H5 方法
  updateMapLocation() {
    if (!this.device) return;

    // 获取模拟坐标，默认坐标设为重大
    const coords = LocationMap[this.device.location] || [106.464673, 29.569537];
    const lng = coords[0];
    const lat = coords[1];

    // 构建 JS 调用字符串
    // setDeviceLocation(lng, lat, name, status)
    const script = `setDeviceLocation(${lng}, ${lat}, '${this.device.name}', ${this.device.status})`;

    // 执行 JS
    try {
      this.controller.runJavaScript(script);
    } catch (error) {
      console.error('Map execution failed:', error);
    }
  }
}