import { DeviceItem, DeviceService, DeviceStatus } from '../model/DeviceModel';
import { DeviceMonitorCard } from '../view/device/DeviceMonitorCard';
import { promptAction } from '@kit.ArkUI';
import { HMRouterMgr } from '@hadss/hmrouter';
import { UserAuthUtil } from '../common/utils/UserAuthUtil';

@CustomDialog
struct EditThresholdDialog {
  controller: CustomDialogController;
  device: DeviceItem | null = null;
  @State newThreshold: string = '';
  confirm: (val: number) => void = () => {};

  aboutToAppear() {
    if (this.device) {
      this.newThreshold = this.device.threshold.toString();
    }
  }

  build() {
    Column() {
      Text('修改报警阈值')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      Text(`当前设备：${this.device?.name}`)
        .fontSize(14)
        .fontColor('#666')
        .margin({ bottom: 20 })

      TextInput({ text: this.newThreshold, placeholder: '请输入新的阈值' })
        .type(InputType.Number)
        .onChange((value) => {
          this.newThreshold = value;
        })
        .width('90%')
        .margin({ bottom: 20 })

      Row() {
        Button('取消')
          .backgroundColor('#F5F5F5')
          .fontColor('#666')
          .width('40%')
          .onClick(() => {
            this.controller.close();
          })

        Button('保存')
          .backgroundColor($r('sys.color.brand'))
          .width('40%')
          .onClick(() => {
            const val = parseFloat(this.newThreshold);
            if (isNaN(val)) {
              promptAction.showToast({ message: '请输入有效的数字' });
              return;
            }
            this.confirm(val);
            this.controller.close();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({ bottom: 20 })
    }
    .backgroundColor(Color.White)
    .borderRadius(16)
    .width('80%')
  }
}

// --- 主页面 ---
@Entry
@Component
export struct DeviceMonitoringPage {
  @State deviceList: DeviceItem[] = [];
  @State isLoading: boolean = false;
  dialogController: CustomDialogController | null = null;

  aboutToAppear() {
    this.fetchData();
  }

  // 拉取数据
  async fetchData() {
    this.isLoading = true;
    try {
      // Service 内部已经帮我们把 status 算好了，直接用
      this.deviceList = await DeviceService.getDeviceList();
    } catch (error) {
      console.error('获取设备列表失败:', error);
      promptAction.showToast({
        message: '网络请求失败，请检查 json-server',
        duration: 2000
      });
    } finally {
      this.isLoading = false;
    }
  }

  // 打开编辑弹窗
  openEditDialog(item: DeviceItem) {
    this.dialogController = new CustomDialogController({
      builder: EditThresholdDialog({
        device: item,
        confirm: (newVal: number) => {
          this.handleSave(item, newVal);
        }
      }),
      alignment: DialogAlignment.Center,
      autoCancel: true
    });
    this.dialogController.open();
  }

  // 保存逻辑
  async handleSave(item: DeviceItem, newVal: number) {
    const isAuthPassed = await UserAuthUtil.startAuth(`验证管理员身份以修改${item.name}`);
    if (!isAuthPassed) {
      promptAction.showToast({ message: '操作已取消或验证失败' });
      return;
    }

    try {
      // 调用 Service 计算新状态
      const newStatus = DeviceService.determineStatus(item.value, newVal);

      const updatedDevice: DeviceItem = {
        id: item.id,
        name: item.name,
        value: item.value,
        unit: item.unit,
        threshold: newVal, // 更新阈值
        status: newStatus, // 更新计算后的状态
        updateTime: item.updateTime,
        location: item.location,
        isReported: item.isReported
      };

      // 乐观更新
      const index = this.deviceList.findIndex(d => d.id === item.id);
      if (index !== -1) {
        this.deviceList[index] = updatedDevice;
        this.deviceList = [...this.deviceList]; // 触发 ArkUI 刷新
      }

      // 发送网络请求
      await DeviceService.updateDevice(updatedDevice);

      promptAction.showToast({ message: '参数已下发，系统状态已重置' });

    } catch (error) {
      console.error('更新失败:', error);
      promptAction.showToast({ message: '更新失败，正在回滚...' });
      this.fetchData(); // 失败后重新拉取数据
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

      // 列表区域
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(50).height(50).color(Color.Blue)
          Text('正在同步设备节点...').fontSize(14).fontColor('#999').margin({ top: 10 })
        }
        .height('80%')
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.deviceList, (item: DeviceItem) => {
            ListItem() {
              DeviceMonitorCard({ device: item })
              // 点击查看地图
                .onClick(() => {
                  HMRouterMgr.push({
                    pageUrl: 'DeviceMapDialog',
                    param: item
                  });
                })
                // 长按修改阈值
                .gesture(
                  LongPressGesture({ repeat: false })
                    .onAction(() => {
                      this.openEditDialog(item);
                    })
                )
            }
          }, (item: DeviceItem) => item.id.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 10 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.point_color_checked'))
  }
}