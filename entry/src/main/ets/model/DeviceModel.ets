import { CommonConstants } from '../common/constants/CommonConstants';
import { Request } from '../common/utils/Request';

export enum DeviceStatus {
  NORMAL = 0,
  WARNING = 1,
  DANGER = 2
}

export interface DeviceItem {
  id: number;
  name: string;
  value: number;
  unit: string;
  threshold: number;
  status: DeviceStatus;
  updateTime: string;
  location: string;
  isReported?: boolean;
}

export class DeviceService {
  /**
   * 根据当前值和阈值，计算设备状态
   */
  static determineStatus(value: number, threshold: number): DeviceStatus {
    if (value >= threshold) {
      return DeviceStatus.DANGER;
    } else if (value >= threshold * 0.8) {
      return DeviceStatus.WARNING;
    }
    return DeviceStatus.NORMAL;
  }

  // 获取设备列表
  static async getDeviceList(): Promise<DeviceItem[]> {
    const list = await Request.get<DeviceItem[]>(CommonConstants.DEVICE_URL);
    return list.map((item: DeviceItem) => {
      item.status = DeviceService.determineStatus(item.value, item.threshold);
      return item;
    });
  }

  // 更新设备
  static async updateDevice(device: DeviceItem): Promise<DeviceItem> {
    device.status = DeviceService.determineStatus(device.value, device.threshold);

    // 调用 PUT 接口更新数据
    return await Request.put<DeviceItem>(`${CommonConstants.DEVICE_URL}/${device.id}`, device);
  }
}