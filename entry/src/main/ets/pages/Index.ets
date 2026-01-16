import { TabItemInterface, TabListData } from '../viewmodel/TabItemData';
import { DeviceMonitoringPage } from './DeviceMonitoringPage';
import { DustMonitoringPage } from './DustMonitoringPage';
import { WorkerMonitoringPage } from './WorkerMonitoringPage';

@Entry
@Component
struct Index {
  // 当前选中的 Tab 索引
  @State currentIndex: number = 0;
  // 控制 Tabs 切换的控制器
  private tabsController: TabsController = new TabsController();

  // 自定义 TabBar 的构建函数
  @Builder TabBuilder(item: TabItemInterface) {
    Column() {
      Divider()
        .strokeWidth(0.5)
        .color('#E3E3E3') // 浅灰色
        .width('100%')    // 撑满宽度

      Column() {
        Image(this.currentIndex === item.index ? item.imageActivated : item.imageOriginal)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .fillColor(this.currentIndex === item.index ? '#007DFF' : '#999999')
          .margin({ bottom: 4 })
          .scale({
            x: this.currentIndex === item.index ? 1.2 : 1.0,
            y: this.currentIndex === item.index ? 1.2 : 1.0
          })
          .animation({ duration: 300, curve: Curve.EaseOut })

        Text(item.title)
          .fontColor(this.currentIndex === item.index ? '#007DFF' : '#999999')
          .fontSize(10)
          .fontWeight(this.currentIndex === item.index ? 500 : 400)
          .animation({ duration: 300 })
      }
      .height('100%')
      .justifyContent(FlexAlign.Center) // 内容垂直居中
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .onClick(() => {
      this.currentIndex = item.index;
      this.tabsController.changeIndex(item.index);
    })
  }

  build() {
    // BarPosition.End
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {

      // 1. 设备监控 Tab
      TabContent() {
        DeviceMonitoringPage()
      }
      .tabBar(this.TabBuilder(TabListData[0]))

      // 2. 粉尘监控 Tab
      TabContent() {
        DustMonitoringPage()
      }
      .tabBar(this.TabBuilder(TabListData[1]))

      // 3. 工人监控 Tab
      TabContent() {
        WorkerMonitoringPage()
      }
      .tabBar(this.TabBuilder(TabListData[2]))

      // 4. 我的/设置 Tab (演示扩展性)
      TabContent() {
        Column() {
          Text("设置页面").fontSize(30)
        }.justifyContent(FlexAlign.Center).width('100%').height('100%')
      }
      .tabBar(this.TabBuilder(TabListData[3]))

    }
    // 开启左右滑动切换
    .scrollable(true)
    // 隐藏系统默认的 TabBar 线条，因为我们自定义了
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      // 监听滑动事件，同步更新 currentIndex，触发 UI 动效
      this.currentIndex = index;
    })
  }
}