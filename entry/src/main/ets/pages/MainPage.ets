import { HMRouter } from '@hadss/hmrouter';
import { TabItemInterface, TabListData } from '../viewmodel/TabItemData';
import { DeviceMonitoringPage } from './DeviceMonitoringPage';
import { DustMonitoringPage } from './DustMonitoringPage';
import { WorkerMonitoringPage } from './WorkerMonitoringPage';
import { HomePage } from './HomePage';

// 添加 @HMRouter 注解
@HMRouter({
  pageUrl: 'MainPage',
  lifecycle: 'ExitAppLifecycle'
})
@Component
export struct MainPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(item: TabItemInterface) {
    Column() {
      Divider().strokeWidth(0.5).color('#E3E3E3').width('100%')
      Column() {
        Image(this.currentIndex === item.index ? item.imageActivated : item.imageOriginal)
          .width(24).height(24)
          .fillColor(this.currentIndex === item.index ? '#007DFF' : '#999999')
          .margin({ bottom: 4, top: 6 })
        Text(item.title)
          .fontColor(this.currentIndex === item.index ? '#007DFF' : '#999999')
          .fontSize(10)
      }.height('100%').justifyContent(FlexAlign.Center)
    }.width('100%').height(56).backgroundColor(Color.White)
    .onClick(() => {
      this.currentIndex = item.index;
      this.tabsController.changeIndex(item.index);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      // 首页
      TabContent() { HomePage() }.tabBar(this.TabBuilder(TabListData[0]))
      // 设备
      TabContent() { DeviceMonitoringPage() }.tabBar(this.TabBuilder(TabListData[1]))
      // 粉尘
      TabContent() { DustMonitoringPage() }.tabBar(this.TabBuilder(TabListData[2]))
      // 工人
      TabContent() { WorkerMonitoringPage() }.tabBar(this.TabBuilder(TabListData[3]))
    }
    .scrollable(false)
    .barMode(BarMode.Fixed)
    .barHeight(56)
  }
}