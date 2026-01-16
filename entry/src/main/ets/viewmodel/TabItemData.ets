export interface TabItemInterface {
  index: number;
  title: string;
  imageActivated: Resource; // 选中时的图标
  imageOriginal: Resource;  // 未选中时的图标
}

// 这里的图标暂时使用系统自带的，后面你可以换成UI切图
// 系统的图标资源通常在 $r('sys.media.xxx')
export const TabListData: TabItemInterface[] = [
  {
    index: 0,
    title: '设备监控',
    imageActivated: $r('sys.media.ohos_ic_public_device_phone'), // 示例图标
    imageOriginal: $r('sys.media.ohos_ic_public_device_phone'),
  },
  {
    index: 1,
    title: '粉尘监控',
    imageActivated: $r('sys.media.ohos_ic_public_device_phone'),
    imageOriginal: $r('sys.media.ohos_ic_public_device_phone'),
  },
  {
    index: 2,
    title: '工人监控',
    imageActivated: $r('sys.media.ohos_ic_public_device_phone'),
    imageOriginal: $r('sys.media.ohos_ic_public_device_phone'),
  },
  {
    index: 3,
    title: '我的', // 预留一个设置页，演示扩展性
    imageActivated: $r('sys.media.ohos_ic_public_device_phone'),
    imageOriginal: $r('sys.media.ohos_ic_public_device_phone'),
  }
]