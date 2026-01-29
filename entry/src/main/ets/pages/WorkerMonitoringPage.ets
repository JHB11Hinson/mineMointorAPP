import { WorkerItem, WorkerService } from '../model/WorkerModel';
import { WorkerListCard } from '../view/worker/WorkerListCard';
import { promptAction } from '@kit.ArkUI';

@Component
export struct WorkerMonitoringPage {
  // 定义状态变量
  @State workerList: WorkerItem[] = [];
  @State isLoading: boolean = false;

  // 统计数据 (用于页面顶部展示)
  @State totalWorkers: number = 0;
  @State dangerCount: number = 0;

  // 组件挂载时获取数据
  aboutToAppear() {
    this.fetchData();
  }

  async fetchData() {
    this.isLoading = true;
    try {
      // 发起网络请求
      const data = await WorkerService.getWorkerList();
      this.workerList = data;

      // 本地计算：统计总人数和危险人数
      this.totalWorkers = this.workerList.length;
      this.dangerCount = this.workerList.filter(w => w.status === 2).length;

    } catch (error) {
      console.error('Fetch worker error:', error);
      promptAction.showToast({ message: '获取工人数据失败', duration: 2000 });
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 顶部标题栏 (带简单的统计信息)
      Column() {
        Text('人员安全监控')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        // 统计摘要条
        Row() {
          Text(`当前井下作业: ${this.totalWorkers} 人`)
            .fontSize(14)
            .fontColor('#666')

          Blank() // 撑开中间间距

          if (this.dangerCount > 0) {
            Row() {
              Image($r('sys.media.ohos_ic_public_device_phone')) // 警告图标
                .width(16)
                .height(16)
                .fillColor('#FF4D4F')
              Text(` ${this.dangerCount} 人高危预警`)
                .fontSize(14)
                .fontColor('#FF4D4F')
                .fontWeight(FontWeight.Bold)
            }
          } else {
            Text('全员安全')
              .fontSize(14)
              .fontColor('#52C41A')
          }
        }
        .width('100%')
        .margin({ top: 10 })
      }
      .padding(16)
      .backgroundColor(Color.White)

      // 分割线
      Divider().strokeWidth(1).color('#E3E3E3')

      // 列表内容区域
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40)
          Text('正在同步人员定位...').fontSize(12).fontColor('#999').margin({ top: 10 })
        }
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.workerList, (item: WorkerItem) => {
            ListItem() {
              WorkerListCard({ worker: item })
            }
          }, (item: WorkerItem) => item.id.toString())
        }
        .width('100%')
        .layoutWeight(1) // 占满剩余高度
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}