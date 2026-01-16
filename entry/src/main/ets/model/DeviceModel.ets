import { CommonConstants } from '../common/constants/CommonConstants';
import { HttpUtil } from '../common/utils/HttpUtil';

// 设备状态枚举
export enum DeviceStatus {
  NORMAL = 0,
  WARNING = 1,
  DANGER = 2
}

// 设备数据接口
export interface DeviceItem {
  id: number;
  name: string;
  value: number;
  unit: string;
  threshold: number;
  status: DeviceStatus;
  updateTime: string;
  location: string;
}

// 3. 获取设备列表的服务函数
export class DeviceService {
  // 使用泛型 Promise<DeviceItem[]> 约束返回值
  static async getDeviceList(): Promise<DeviceItem[]> {
    // 调用封装好的 HttpUtil，传入泛型参数 DeviceItem[]
    // 这样 TS 就能自动推断出返回的是设备数组
    return await HttpUtil.get<DeviceItem[]>(CommonConstants.DEVICE_URL);
  }
}