import { CommonConstants } from '../common/constants/CommonConstants';
import { Request } from '../common/utils/Request';

export enum WorkerStatus {
  NORMAL = 0,
  FATIGUE = 1,
  DANGER = 2
}

export interface WorkerItem {
  id: number;
  name: string;
  role: string;
  location: string;
  heartRate: number;
  status: WorkerStatus;
  isReported?: boolean;
}

export class WorkerService {
  static async getWorkerList(): Promise<WorkerItem[]> {
    return await Request.get<WorkerItem[]>(CommonConstants.WORKER_URL);
  }
}