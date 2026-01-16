
import { DeviceItem, DeviceStatus } from '../../model/DeviceModel';

@Component
export struct DeviceMonitorCard {
  // 接收父组件传来的单条数据，使用 @Prop (单向同步即可，列表一般只需展示)
  @Prop device: DeviceItem;

  build() {
    Row() {
      // 左侧：图标与状态
      Column() {
        // 根据状态动态改变图标颜色
        Image(this.getIconResource(this.device.status))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          // 这里简单用颜色区分，实际可以用不同图片
          .fillColor(this.getStatusColor(this.device.status))
      }
      .width('15%')
      .justifyContent(FlexAlign.Center)

      // 中间：核心数据
      Column() {
        Text(this.device.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')

        Row() {
          Text(`当前值: ${this.device.value} ${this.device.unit}`)
            .fontSize(14)
            .fontColor('#666')
            .margin({ top: 4 })

          // 阈值提示
          Text(`(阈值: ${this.device.threshold})`)
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 5, top: 4 })
        }
      }
      .width('60%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      // 右侧：位置与时间
      Column() {
        Text(this.device.location)
          .fontSize(12)
          .fontColor($r('sys.color.brand')) // 科技蓝
          .backgroundColor('#E6F2FF')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)

        Text(this.device.updateTime)
          .fontSize(12)
          .fontColor('#999')
          .margin({ top: 8 })
      }
      .width('25%')
      .alignItems(HorizontalAlign.End)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(80)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .padding(10)
    .margin({ bottom: 10 })
    .shadow({ radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 })
  }

  // 辅助函数：根据状态返回颜色
  private getStatusColor(status: DeviceStatus): string {
    if (status === DeviceStatus.DANGER) return '#FF4D4F'; // 红
    if (status === DeviceStatus.WARNING) return '#FAAD14'; // 黄
    return '#52C41A'; // 绿
  }

  private getIconResource(_status: DeviceStatus): Resource {
    return $r('sys.media.ohos_ic_public_device_phone');
  }
}