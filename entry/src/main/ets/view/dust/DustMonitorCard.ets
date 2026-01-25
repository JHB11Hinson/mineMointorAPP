import { DustItem, DustStatus } from '../../model/DustModel';

@Component
export struct DustMonitorCard {
  // 接收父组件传来的单条数据
  @Prop dust: DustItem;

  build() {
    Row() {
      // 左侧：自定义图标区域
      Column() {
        // 使用Circle组件创建圆形图标，代替图片
        Stack() {
          // 外圈圆形
          Circle()
            .width(36)
            .height(36)
            .fill(this.getStatusColor(this.dust.status))
            .opacity(0.2) // 半透明背景

          // 内圈圆形
          Circle()
            .width(24)
            .height(24)
            .fill(this.getStatusColor(this.dust.status))

          // 图标中间的文本
          Text(this.getIconText(this.dust.status))
            .fontSize(12)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
        .width(40)
        .height(40)
      }
      .width('15%')
      .justifyContent(FlexAlign.Center)

      // 中间：核心数据 - 区域和PM值
      Column() {
        // 区域名称
        Text(this.dust.area)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')

        // PM2.5 和 PM10 数值
        Row() {
          // PM2.5
          Column() {
            Text('PM2.5')
              .fontSize(12)
              .fontColor('#666')
            Text(`${this.dust.pm25}`)
              .fontSize(16)
              .fontColor(this.getPm25Color(this.dust.pm25))
              .fontWeight(FontWeight.Medium)
          }
          .margin({ right: 16 })

          // 分隔线
          Divider()
            .vertical(true)
            .height(20)
            .color('#E0E0E0')
            .margin({ right: 16 })

          // PM10
          Column() {
            Text('PM10')
              .fontSize(12)
              .fontColor('#666')
            Text(`${this.dust.pm10}`)
              .fontSize(16)
              .fontColor(this.getPm10Color(this.dust.pm10))
              .fontWeight(FontWeight.Medium)
          }
        }
        .margin({ top: 4 })
      }
      .width('60%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      // 右侧：状态标签
      Column() {
        // 状态标签
        Row() {
          // 状态指示圆点
          Circle()
            .width(6)
            .height(6)
            .fill(this.getStatusColor(this.dust.status))
            .margin({ right: 4 })

          Text(this.getStatusText(this.dust.status))
            .fontSize(14)
            .fontColor(this.getStatusColor(this.dust.status))
            .fontWeight(FontWeight.Medium)
        }
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .border({
          width: 1,
          color: this.getStatusColor(this.dust.status),
          radius: 12
        })

        // 空气质量提示
        Text(this.getAirQualityHint(this.dust.pm25, this.dust.pm10))
          .fontSize(11)
          .fontColor('#999')
          .margin({ top: 6 })
          .maxLines(1)
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

  // 辅助函数：根据状态返回图标中的文字
  private getIconText(status: DustStatus): string {
    if (status === DustStatus.WARNING) return '!';
    return '✔'; // 表示"空气"
  }

  // 辅助函数：根据状态返回颜色
  private getStatusColor(status: DustStatus): string {
    if (status === DustStatus.WARNING) return '#FAAD14'; // 黄色警告
    return '#52C41A'; // 绿色正常
  }

  // 辅助函数：根据状态返回文本
  private getStatusText(status: DustStatus): string {
    if (status === DustStatus.WARNING) return '警告';
    return '正常';
  }

  // 辅助函数：根据PM2.5值返回颜色
  private getPm25Color(pm25: number): string {
    if (pm25 > 150) return '#FF4D4F'; // 红色：重度污染
    if (pm25 > 75) return '#FAAD14';  // 黄色：中度污染
    if (pm25 > 35) return '#FADB14';  // 浅黄色：轻度污染
    return '#52C41A';                 // 绿色：良好
  }

  // 辅助函数：根据PM10值返回颜色
  private getPm10Color(pm10: number): string {
    if (pm10 > 200) return '#FF4D4F'; // 红色：重度污染
    if (pm10 > 150) return '#FAAD14'; // 黄色：中度污染
    if (pm10 > 50) return '#FADB14';  // 浅黄色：轻度污染
    return '#52C41A';                 // 绿色：良好
  }

  // 辅助函数：根据PM值返回空气质量提示
  private getAirQualityHint(pm25: number, pm10: number): string {
    const maxPm = Math.max(pm25, pm10);
    if (maxPm > 150) return '空气污染严重';
    if (maxPm > 75) return '空气轻度污染';
    return '空气质量良好';
  }
}