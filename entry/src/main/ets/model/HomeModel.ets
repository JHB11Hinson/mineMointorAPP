import { Request } from '../common/utils/Request';
import { CommonConstants } from '../common/constants/CommonConstants'; // 新增引入
import { DeviceItem, DeviceService, DeviceStatus } from './DeviceModel';
import { WorkerItem, WorkerService, WorkerStatus } from './WorkerModel';
import { DustItem, DustService, DustStatus } from './DustModel';

// 警报数据接口
export interface WarningItem {
  id: string;
  source: string;
  type: string;
  content: string;
  level: number;
  originalId: number;
  category: 'device' | 'worker' | 'dust';
  timestamp: string;
  isReported: boolean;
}

// 历史记录接口
export interface RecordItem {
  id: number;
  handler: string;
  source: string;
  result: string;
  time: string;
}

type SourceItem = DeviceItem | WorkerItem | DustItem;

export class HomeService {
  // 获取聚合的异常列表
  static async getWarningList(): Promise<WarningItem[]> {
    try {
      // 获取原始数据
      const result = await Promise.all([
        DeviceService.getDeviceList(),
        WorkerService.getWorkerList(),
        DustService.getDustList()
      ]);

      const devices = result[0] as DeviceItem[];
      const workers = result[1] as WorkerItem[];
      const dusts = result[2] as DustItem[];

      const warnings: WarningItem[] = [];
      const now = new Date().toLocaleTimeString();

      // 聚合逻辑
      // 设备
      if (devices) {
        devices.forEach((dev: DeviceItem) => {
          if (dev.status !== DeviceStatus.NORMAL && !dev.isReported) {
            warnings.push({
              id: `device_${dev.id}`,
              source: dev.name,
              type: dev.status === DeviceStatus.DANGER ? '设备故障/高危' : '数值预警',
              content: `当前值:${dev.value}${dev.unit}`,
              level: dev.status,
              originalId: dev.id,
              category: 'device',
              timestamp: now,
              isReported: false
            });
          }
        });
      }

      // 工人
      if (workers) {
        workers.forEach((w: WorkerItem) => {
          if (w.status !== WorkerStatus.NORMAL && !w.isReported) {
            warnings.push({
              id: `worker_${w.id}`,
              source: `${w.name} (${w.role})`,
              type: w.status === WorkerStatus.DANGER ? '生命体征危急' : '疲劳作业',
              content: `心率异常:${w.heartRate}bpm`,
              level: w.status,
              originalId: w.id,
              category: 'worker',
              timestamp: now,
              isReported: false
            });
          }
        });
      }

      // 粉尘
      if (dusts) {
        dusts.forEach((d: DustItem) => {
          if (d.status !== DustStatus.NORMAL && !d.isReported) {
            warnings.push({
              id: `dust_${d.id}`,
              source: d.area,
              type: '空气质量超标',
              content: `PM2.5:${d.pm25}`,
              level: 1,
              originalId: d.id,
              category: 'dust',
              timestamp: now,
              isReported: false
            });
          }
        });
      }

      return warnings;

    } catch (error) {
      console.error('Fetch home data failed:', JSON.stringify(error));
      return [];
    }
  }

  // 获取历史记录
  static async getRecordList(): Promise<RecordItem[]> {
    try {
      // 显式传入泛型 <RecordItem[]>
      return await Request.get<RecordItem[]>('/records?_sort=id&_order=desc');
    } catch (e) {
      return [];
    }
  }

  // 处理异常逻辑
  static async handleWarning(item: WarningItem, note: string): Promise<boolean> {
    try {
      // 上报历史记录
      const newRecord: RecordItem = {
        id: new Date().getTime(),
        handler: "我 (安全员)",
        source: item.source,
        result: note,
        time: new Date().toLocaleString()
      };

      // 显式传入泛型 <RecordItem>
      await Request.post<RecordItem>('/records', newRecord);

      // 更新源数据状态
      let url = '';
      // 使用绝对路径
      if (item.category === 'device') {
        url = `${CommonConstants.BASE_URL}/devices/${item.originalId}`;
      } else if (item.category === 'worker') {
        url = `${CommonConstants.BASE_URL}/workers/${item.originalId}`;
      } else if (item.category === 'dust') {
        url = `${CommonConstants.BASE_URL}/dusts/${item.originalId}`;
      }

      if (url) {
        // 显式传入泛型 <SourceItem>
        // 先查完整数据
        const fullData = await Request.get<SourceItem>(url);
        // 改状态为已上报
        fullData.isReported = true;
        // 再更新回去
        await Request.put<SourceItem>(url, fullData);
      }

      return true;
    } catch (error) {
      console.error('Handle warning failed:', JSON.stringify(error));
      return false;
    }
  }
}