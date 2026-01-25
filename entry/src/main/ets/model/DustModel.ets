import { CommonConstants } from '../common/constants/CommonConstants';
import { Request } from '../common/utils/Request';

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
  isReported?: boolean;
}

export class DustService {
  static async getDustList(): Promise<DustItem[]> {
    return await Request.get<DustItem[]>(CommonConstants.DUST_URL);
  }
}