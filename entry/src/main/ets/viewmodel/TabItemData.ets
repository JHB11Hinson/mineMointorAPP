export interface TabItemInterface {
  index: number;
  title: string;
  imageActivated: Resource;
  imageOriginal: Resource;
}

export const TabListData: TabItemInterface[] = [
  {
    index: 0,
    title: '首页',
    imageActivated: $r('sys.media.ohos_ic_public_albums'),
    imageOriginal: $r('sys.media.ohos_ic_public_albums'),
  },
  {
    index: 1,
    title: '设备监控',
    imageActivated: $r('sys.media.ohos_ic_public_device_phone'),
    imageOriginal: $r('sys.media.ohos_ic_public_device_phone'),
  },
  {
    index: 2,
    title: '粉尘监控',
    imageActivated: $r('sys.media.ohos_ic_public_scan'),
    imageOriginal: $r('sys.media.ohos_ic_public_scan'),
  },
  {
    index: 3,
    title: '工人监控',
    imageActivated: $r('sys.media.ohos_user_auth_icon_face'),
    imageOriginal: $r('sys.media.ohos_user_auth_icon_face'),
  }
]