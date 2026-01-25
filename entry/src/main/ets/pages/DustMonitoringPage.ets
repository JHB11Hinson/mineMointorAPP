import { DustItem, DustService } from '../model/DustModel';
import { DustMonitorCard } from '../view/dust/DustMonitorCard';
import { promptAction } from '@kit.ArkUI'; // 用于弹窗提示错误
import { HMRouterMgr } from '@hadss/hmrouter';

@Entry
@Component
export struct DustMonitoringPage {
  @State dustList: DustItem[] = [];
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.fetchData();
  }

  // 获取数据的方法
  async fetchData() {
    this.isLoading = true;
    try {
      // 调用静态方法获取灰尘监测数据
      this.dustList = await DustService.getDustList();

    } catch (error) {
      console.error('获取灰尘监测数据失败:', error);
      // 错误提示
      promptAction.showToast({
        message: '获取灰尘监测数据失败，请检查网络连接',
        duration: 2000
      });
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('灰尘监测数据')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')

        Button('刷新')
          .height(30)
          .fontSize(12)
          .backgroundColor('#1890FF')
          .fontColor(Color.White)
          .onClick(() => {
            this.fetchData();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(Color.White)
      .shadow({ radius: 2, color: '#1A000000', offsetX: 0, offsetY: 1 })

      // 统计信息栏
      Row() {
        // 正常区域数量
        Column() {
          Text(this.getNormalAreaCount().toString())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#52C41A')
          Text('正常区域')
            .fontSize(12)
            .fontColor('#666')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        // 分隔线
        Divider()
          .vertical(true)
          .height(20)
          .color('#E8E8E8')

        // 警告区域数量
        Column() {
          Text(this.getWarningAreaCount().toString())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FAAD14')
          Text('警告区域')
            .fontSize(12)
            .fontColor('#666')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        // 分隔线
        Divider()
          .vertical(true)
          .height(20)
          .color('#E8E8E8')

        // 总区域数量
        Column() {
          Text(this.dustList.length.toString())
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1890FF')
          Text('总监测点')
            .fontSize(12)
            .fontColor('#666')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height(60)
      .backgroundColor(Color.White)
      .margin({ bottom: 8 })

      // 列表内容
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color('#1890FF')
          Text('正在加载监测数据...')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 10 })
        }
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else if (this.dustList.length === 0) {
        // 无数据时的显示
        Column() {
          // 使用图形组件代替图片
          Column() {
            Circle()
              .width(80)
              .height(80)
              .fill('#E8E8E8')
            Text('无数据')
              .fontSize(16)
              .fontColor('#999')
              .margin({ top: 12 })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Text('暂无灰尘监测数据')
            .fontSize(16)
            .fontColor('#999')
            .margin({ bottom: 8, top: 20 })
          Text('请点击刷新按钮或稍后再试')
            .fontSize(14)
            .fontColor('#999')
        }
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.dustList, (item: DustItem) => {
            ListItem() {
              DustMonitorCard({ dust: item })
                .onClick(() => {
                  HMRouterMgr.push({
                    pageUrl: 'DustDetailPage',
                    param: item // 传递整个对象
                  })
                })
            }
          }, (item: DustItem) => item.id.toString())
        }
        .width('100%')
        .layoutWeight(1) // 自动占满剩余空间
        .padding({ left: 16, right: 16 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 获取正常区域数量
  private getNormalAreaCount(): number {
    return this.dustList.filter(item => item.status === 0).length;
  }

  // 获取警告区域数量
  private getWarningAreaCount(): number {
    return this.dustList.filter(item => item.status === 1).length;
  }
}