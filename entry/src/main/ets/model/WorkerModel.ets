import { CommonConstants } from '../common/constants/CommonConstants';
import { HttpUtil } from '../common/utils/HttpUtil';

export enum WorkerStatus {
  NORMAL = 0,   // 正常
  FATIGUE = 1,  // 疲劳/警告
  DANGER = 2    // 危险/求救
}

export interface WorkerItem {
  id: number;
  name: string;
  role: string;       // 岗位：如安全员、爆破手
  location: string;   // 当前位置
  heartRate: number;  // 实时心率
  status: WorkerStatus;
}

// 工人服务类
export class WorkerService {
  // 明确告诉调用者：我会返回一个工人数组
  static async getWorkerList(): Promise<WorkerItem[]> {
    // 调用通用网络工具，传入泛型参数，自动解析 JSON
    return await HttpUtil.get<WorkerItem[]>(CommonConstants.WORKER_URL);
  }
}