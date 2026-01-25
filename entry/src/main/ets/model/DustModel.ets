import { CommonConstants } from '../common/constants/CommonConstants';
import { HttpUtil } from '../common/utils/HttpUtil';

// 设备状态枚举
export enum DustStatus {
  NORMAL = 0,
  WARNING = 1,
}
export interface DustItem {
  id: number;
  area: string;
  pm25: number;
  pm10: number;
  status: DustStatus;
}
export class DustService {
  // 使用泛型 Promise<DeviceItem[]> 约束返回值
  static async getDustList(): Promise<DustItem[]> {
    // 调用封装好的 HttpUtil，传入泛型参数 DustItem[]
    // 这样 TS 就能自动推断出返回的是设备数组
    return await HttpUtil.get<DustItem[]>(CommonConstants.DUST_URL);
  }
}