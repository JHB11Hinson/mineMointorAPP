// entry/src/main/ets/common/utils/HttpUtil.ets
import http from '@ohos.net.http';

// 定义泛型接口，约束后端返回的数据结构
export class HttpUtil {

  /**
   * 发起 GET 请求
   * @param url 请求地址
   * @returns Promise<T> 返回泛型 T
   */
  static async get<T>(url: string): Promise<T> {
    const httpRequest = http.createHttp();

    try {
      // 发起请求
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING, // 接收字符串后续手动转 JSON
        connectTimeout: 5000,
        readTimeout: 5000
      });

      // 检查状态码
      if (response.responseCode === 200) {
        // 解析结果
        const result = response.result as string;
        // 这里使用泛型断言，将解析后的 JSON 视为 T 类型
        return JSON.parse(result) as T;
      } else {
        console.error('Http request failed:', response.responseCode);
        return Promise.reject(`HTTP Error: ${response.responseCode}`);
      }
    } catch (err) {
      console.error('Http request error:', JSON.stringify(err));
      return Promise.reject(err);
    } finally {
      // 销毁请求对象，释放资源
      httpRequest.destroy();
    }
  }
}