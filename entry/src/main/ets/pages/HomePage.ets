import { WarningItem, RecordItem, HomeService } from '../model/HomeModel';
import { ListView, RefreshController } from '@abner/refresh';
import { promptAction } from '@kit.ArkUI';

// --- 自定义弹窗组件 ---
@CustomDialog
struct HandleDialog {
  controller: CustomDialogController;
  item: WarningItem | null = null;
  @State note: string = ''; // 用户输入的内容
  onConfirm: (note: string) => void = () => {};

  build() {
    Column() {
      Text('异常处理上报')
        .fontSize(18).fontWeight(FontWeight.Bold).margin({ top: 20, bottom: 10 })

      Text(`正在处理：${this.item?.source}`)
        .fontSize(14).fontColor('#666').margin({ bottom: 10 })

      TextInput({ placeholder: '请输入处理结果(10字以内)' })
        .maxLength(10)
        .onChange((value) => {
          this.note = value;
        })
        .margin({ bottom: 20 })
        .width('90%')

      Row() {
        Button('取消')
          .backgroundColor('#F5F5F5').fontColor('#666')
          .onClick(() => this.controller.close())
          .width('40%')

        Button('确认')
          .backgroundColor('#007DFF')
          .onClick(() => {
            if(!this.note){
              promptAction.showToast({message:'请输入处理内容'});
              return;
            }
            this.onConfirm(this.note);
            this.controller.close();
          })
          .width('40%')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({ bottom: 20 })
    }
    .backgroundColor(Color.White)
    .borderRadius(12)
    .width('80%')
  }
}

// --- 主页面 ---
@Component
export struct HomePage {
  @State warningList: WarningItem[] = [];
  @State recordList: RecordItem[] = [];
  refreshController: RefreshController = new RefreshController();

  // 弹窗控制器
  handleDialogController: CustomDialogController | null = null;

  aboutToAppear() {
    this.loadData();
  }

  // 打开弹窗
  openHandleDialog(item: WarningItem) {
    this.handleDialogController = new CustomDialogController({
      builder: HandleDialog({
        item: item,
        onConfirm: async (note: string) => {
          // 调用 Service 处理
          const success = await HomeService.handleWarning(item, note);
          if (success) {
            promptAction.showToast({ message: '上报成功' });
            this.loadData(); // 刷新数据
          } else {
            promptAction.showToast({ message: '上报失败' });
          }
        }
      }),
      alignment: DialogAlignment.Center
    });
    this.handleDialogController.open();
  }

  async loadData() {
    this.warningList = await HomeService.getWarningList();
    this.recordList = await HomeService.getRecordList();
    this.refreshController.finishRefresh();
  }

  // 卡片构建器
  @Builder WarningCard(item: WarningItem) {
    Row() {
      // 1. 左侧图标
      Column() {
        Image($r('sys.media.ohos_ic_public_fail'))
          .width(32).height(32)
          .fillColor(item.level === 2 ? '#FF4D4F' : '#FAAD14')
      }
      .width('15%')
      .justifyContent(FlexAlign.Center)

      // 2. 中间信息
      Column() {
        Row() {
          Text(item.source)
            .fontWeight(FontWeight.Bold)
            .fontSize(16)
            .fontColor('#333')

          // 分类标签
          Text(item.category === 'device' ? '设备' : (item.category === 'worker' ? '人员' : '环境'))
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#999')
            .borderRadius(4)
            .padding({ left: 4, right: 4 })
            .margin({ left: 6 })

          // 状态标签 (新增)
          if (item.isReported) {
            Text('已上报')
              .fontSize(10)
              .fontColor('#52C41A')
              .border({ width: 1, color: '#52C41A' })
              .borderRadius(4)
              .padding({ left: 4, right: 4 })
              .margin({ left: 6 })
          } else {
            Text('未上报')
              .fontSize(10)
              .fontColor('#FF4D4F')
              .border({ width: 1, color: '#FF4D4F' })
              .borderRadius(4)
              .padding({ left: 4, right: 4 })
              .margin({ left: 6 })
          }
        }

        Text(item.content)
          .fontSize(14)
          .fontColor('#666')
          .margin({ top: 6 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(item.timestamp)
          .fontSize(12)
          .fontColor('#999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 8 })

      // 3. 右侧按钮
      Column() {
        Button(item.isReported ? '更新' : '处理')
          .height(32)
          .fontSize(13)
          // 如果已上报，用灰色；如果未上报，用红色或黄色
          .backgroundColor(item.isReported ? '#CCCCCC' : (item.level === 2 ? '#FF4D4F' : '#FAAD14'))
          .onClick(() => this.openHandleDialog(item))
      }
      .width('20%')
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ bottom: 12 })
    .shadow({ radius: 6, color: '#0D000000', offsetY: 2 })
  }

  // 历史记录单条视图
  @Builder RecordItemView(item: RecordItem) {
    Row() {
      Column() {
        Text(item.source)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333')
        Text(item.time)
          .fontSize(12)
          .fontColor('#999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text(item.result)
          .fontSize(13)
          .fontColor('#52C41A')
          .textAlign(TextAlign.End)
        Text(item.handler)
          .fontSize(11)
          .fontColor('#ccc')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 8 })
  }

  // 头部视图
  @Builder HeaderSection() {
    Column() {
      Text('欢迎您，王安全员')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)

      Text('今天是 2026年1月25日 | 系统运行正常')
        .fontSize(13)
        .fontColor('#CCFFFFFF')
        .margin({ top: 8 })
    }
    .width('100%')
    .height(140)
    .backgroundColor('#007DFF')
    .backgroundImage($r('sys.media.ohos_ic_public_device_phone'))
    .backgroundImageSize(ImageSize.Cover)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 24, bottom: 20 })
  }

  // 空视图
  @Builder EmptyView() {
    Column() {
      Image($r('sys.media.ohos_ic_public_ok')).width(60).fillColor('#ddd')
      Text('暂无待处理警报，一切正常').fontSize(14).fontColor('#999').margin({top:10})
    }.height(150).justifyContent(FlexAlign.Center).width('100%')
  }

  build() {
    Column() {
      this.HeaderSection()

      Column() {
        Row() {
          Text('待处理警报')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')

          if (this.warningList.length > 0) {
            Text(`${this.warningList.length}`)
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#FF4D4F')
              .borderRadius(10)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .margin({ left: 8 })
          }
        }
        .width('100%')
        .margin({ top: 20, bottom: 12 })

        ListView({
          items: this.warningList,
          itemLayout: (item: Object, index: number) => {
            this.WarningCard(item as WarningItem)
          },
          controller: this.refreshController,
          onRefresh: () => {
            this.loadData();
          },
          isLazyData: false,
          emptyLayout: () => {
            this.EmptyView()
          }
        })
          .layoutWeight(1)

        Column() {
          Divider().margin({ top: 10, bottom: 10 })
          Text('近期处理历史').fontSize(16).fontWeight(FontWeight.Bold).width('100%').margin({ bottom: 8 })

          List() {
            ForEach(this.recordList, (rec: RecordItem) => {
              ListItem() {
                this.RecordItemView(rec)
              }
            })
          }
          .height('30%')
          .width('100%')
        }
        .width('100%')
        .padding({bottom: 10})
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F7F9')
      .borderRadius({ topLeft: 24, topRight: 24 })
      .margin({ top: -24 })
      .padding({ left: 16, right: 16 })
      .clip(true)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#007DFF')
  }
}