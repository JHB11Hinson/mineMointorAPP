import axios, { AxiosInstance, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { CommonConstants } from '../constants/CommonConstants';

// 创建 axios 实例
const instance: AxiosInstance = axios.create({
  baseURL: CommonConstants.BASE_URL,
  timeout: 5000,
});

// 响应拦截器：脱壳，直接返回 data
instance.interceptors.response.use((response: AxiosResponse) => {
  if (response.status >= 200 && response.status < 300) {
    return response.data;
  }
  return Promise.reject(response.data);
}, (error: Object) => {
  return Promise.reject(error);
});

export class Request {
  /**
   * GET 请求
   * @param url 接口地址
   * @param params 请求参数
   * 泛型说明：
   * T: 响应数据类型
   * 第二个泛型 T: 响应体(R)就是 T
   */
  static async get<T>(url: string, params?: Object): Promise<T> {
    // 显式传入三个泛型：<T, R, D>，其中 R=T, D=null
    return instance.get<T, T, null>(url, { params: params });
  }

  /**
   * POST 请求
   * @param url 接口地址
   * @param data 请求体数据
   */
  static async post<T>(url: string, data?: Object): Promise<T> {
    // 显式传入三个泛型：<T, R, D>
    return instance.post<T, T, Object>(url, data);
  }

  /**
   * PUT 请求
   * @param url 接口地址
   * @param data 请求体数据
   */
  static async put<T>(url: string, data?: Object): Promise<T> {
    // 显式传入三个泛型：<T, R, D>
    return instance.put<T, T, Object>(url, data);
  }

  /**
   * DELETE 请求
   * @param url 接口地址
   */
  static async delete<T>(url: string): Promise<T> {
    return instance.delete<T, T, null>(url);
  }
}