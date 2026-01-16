import { WorkerItem, WorkerStatus } from '../../model/WorkerModel';

@Component
export struct WorkerListCard {
  // 接收父组件传递的单条工人数据
  @Prop worker: WorkerItem;

  build() {
    Row() {
      // 1. 左侧：头像与岗位
      Column() {
        // 实际项目可用 Image 组件
        Stack({ alignContent: Alignment.Center }) {
          Circle({ width: 50, height: 50 })
            .fill(this.getAvatarColor(this.worker.status))

          Text(this.worker.name.substring(0, 1)) // 取名字首字
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }

        Text(this.worker.role)
          .fontSize(12)
          .fontColor('#666')
          .margin({ top: 6 })
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .backgroundColor('#F0F0F0')
          .borderRadius(10)
      }
      .width('20%')
      .justifyContent(FlexAlign.Center)

      // 2. 中间：详细信息
      Column() {
        Text(this.worker.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
          .margin({ bottom: 8 })

        Row() {
          Image($r('sys.media.ohos_ic_public_location')) // 系统定位图标
            .width(14)
            .height(14)
            .fillColor('#999')
          Text(this.worker.location)
            .fontSize(14)
            .fontColor('#666')
            .margin({ left: 4 })
        }
      }
      .width('50%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .padding({ left: 10 })

      // 3. 右侧：生命体征 (心率)
      Column() {
        Row() {
          Text(this.worker.heartRate.toString())
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            // 危险状态下心率变红
            .fontColor(this.worker.status === WorkerStatus.DANGER ? '#FF4D4F' : '#007DFF')

          Text('bpm')
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 4, top: 8 })
        }

        // 状态标签
        Text(this.getStatusText(this.worker.status))
          .fontSize(12)
          .fontColor(this.getStatusColor(this.worker.status))
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(this.getStatusBgColor(this.worker.status))
          .borderRadius(4)
          .margin({ top: 6 })
      }
      .width('30%')
      .alignItems(HorizontalAlign.End)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(100)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .padding(12)
    .margin({ bottom: 12 })
    // 如果是危险状态，加个红色阴影
    .shadow(this.worker.status === WorkerStatus.DANGER ?
      { radius: 8, color: '#4DFF4D4F', offsetX: 0, offsetY: 2 } :
      { radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 }
    )
  }

  // --- 辅助样式函数 ---

  private getAvatarColor(status: WorkerStatus): string {
    if (status === WorkerStatus.DANGER) return '#FF4D4F';
    if (status === WorkerStatus.FATIGUE) return '#FAAD14';
    return '#007DFF'; // 正常蓝色
  }

  private getStatusText(status: WorkerStatus): string {
    switch (status) {
      case WorkerStatus.DANGER: return '高危预警';
      case WorkerStatus.FATIGUE: return '疲劳作业';
      default: return '状态良好';
    }
  }

  private getStatusColor(status: WorkerStatus): string {
    if (status === WorkerStatus.DANGER) return '#FF4D4F';
    if (status === WorkerStatus.FATIGUE) return '#FAAD14';
    return '#52C41A';
  }

  private getStatusBgColor(status: WorkerStatus): string {
    if (status === WorkerStatus.DANGER) return '#FFF1F0';
    if (status === WorkerStatus.FATIGUE) return '#FFFBE6';
    return '#F6FFED';
  }
}