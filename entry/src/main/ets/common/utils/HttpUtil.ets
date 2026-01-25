import { http } from '@kit.NetworkKit';

export class HttpUtil {
  static readonly TIMEOUT = 5000;

  // GET 请求
  static async get<T>(url: string): Promise<T> {
    return HttpUtil.request<T>(url, http.RequestMethod.GET);
  }
  // POST 请求
  static async post<T>(url: string, data: Record<string, string | number | boolean>): Promise<T> {
    return HttpUtil.request<T>(url, http.RequestMethod.POST, data);
  }

  // PUT 请求
  static async put<T>(url: string, data: Record<string, string | number | boolean>): Promise<T> {
    return HttpUtil.request<T>(url, http.RequestMethod.PUT, data);
  }

  // 通用请求实现
  private static async request<T>(url: string, method: http.RequestMethod, extraData?: Record<string, string | number | boolean>): Promise<T> {
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(url, {
        method: method,
        extraData: extraData, // 发送的数据
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: HttpUtil.TIMEOUT,
        readTimeout: HttpUtil.TIMEOUT,
        header: {
          'Content-Type': 'application/json'
        }
      });

      if (response.responseCode >= 200 && response.responseCode < 300) {
        const result = response.result as string;
        // 如果返回为空，直接返回 null 或 undefined
        if (!result) {
          return null as T;
        }
        return JSON.parse(result) as T;
      } else {
        return Promise.reject(`HTTP Error: ${response.responseCode}`);
      }
    } catch (err) {
      return Promise.reject(err);
    } finally {
      httpRequest.destroy();
    }
  }
}