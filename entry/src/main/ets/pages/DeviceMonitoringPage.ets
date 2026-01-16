// entry/src/main/ets/pages/DeviceMonitoringPage.ets
import { DeviceItem, DeviceService } from '../model/DeviceModel';
import { DeviceMonitorCard } from '../view/device/DeviceMonitorCard';
import { promptAction } from '@kit.ArkUI'; // 用于弹窗提示错误

@Entry
@Component
export struct DeviceMonitoringPage {
  @State deviceList: DeviceItem[] = [];
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.fetchData();
  }

  // 获取数据的方法
  async fetchData() {
    this.isLoading = true;
    try {
      // 调用静态方法获取数据，现在的 request 已经是真的网络请求了
      // 这里的 await 会等待 HttpUtil.get 返回结果
      this.deviceList = await DeviceService.getDeviceList();

    } catch (error) {
      console.error('获取设备列表失败:', error);
      // 简单的错误提示
      promptAction.showToast({
        message: '网络请求失败，请检查 json-server 是否启动及 IP 配置',
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
        Text('设备实时监控')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Button('刷新')
          .height(30)
          .fontSize(12)
          .onClick(() => {
            this.fetchData();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(16)
      .backgroundColor($r('sys.color.point_color_checked'))

      // 列表内容
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(50).height(50).color(Color.Blue)
          Text('正在请求 Mock 数据...').fontSize(14).fontColor('#999').margin({ top: 10 })
        }
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.deviceList, (item: DeviceItem) => {
            ListItem() {
              // 这里的组件代码复用之前的，不需要改
              DeviceMonitorCard({ device: item })
            }
          }, (item: DeviceItem) => item.id.toString())
        }
        .width('100%')
        .layoutWeight(1) // 自动占满剩余空间
        .padding({ left: 16, right: 16, top: 10 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.point_color_checked'))
  }
}