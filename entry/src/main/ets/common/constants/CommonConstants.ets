export class CommonConstants {
  static readonly BASE_URL: string = 'http://192.168.5.7:3000';
  static readonly DEVICE_URL: string = `${CommonConstants.BASE_URL}/devices`;
  static readonly DUST_URL: string = `${CommonConstants.BASE_URL}/dusts`;
  static readonly WORKER_URL: string = `${CommonConstants.BASE_URL}/workers`;
}