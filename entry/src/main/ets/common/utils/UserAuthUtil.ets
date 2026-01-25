// src/main/ets/common/utils/UserAuthUtil.ets
import { userAuth } from '@kit.UserAuthenticationKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class UserAuthUtil {
  /**
   * 发起用户身份认证
   */
  static async startAuth(title: string = '请验证身份以继续'): Promise<boolean> {
    const challenge = new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8]);

    const authType: userAuth.UserAuthType[] = [
      userAuth.UserAuthType.PIN,
      userAuth.UserAuthType.FACE,
      userAuth.UserAuthType.FINGERPRINT
    ];

    // 准备信任等级
    const authTrustLevel: userAuth.AuthTrustLevel = userAuth.AuthTrustLevel.ATL1;

    try {
      // 构造 AuthParam 对象
      const authParam: userAuth.AuthParam = {
        challenge: challenge,
        authType: authType,
        authTrustLevel: authTrustLevel
      };

      // 构造 WidgetParam 对象
      const widgetParam: userAuth.WidgetParam = {
        title: title
      };

      // 获取认证实例
      const userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
      console.info('获取认证实例成功');

      // 启动认证
      return new Promise<boolean>((resolve) => {
        // 定义回调
        const callback: userAuth.IAuthCallback = {
          onResult: (result: userAuth.UserAuthResult) => {
            console.info('UserAuth result: ' + JSON.stringify(result));

            // 判断结果是否成功
            if (result.result === userAuth.UserAuthResultCode.SUCCESS) {
              resolve(true);
            } else {
              resolve(false);
            }

            // 认证结束，释放资源
            try {
              userAuthInstance.off('result', callback);
            } catch (e) {
              // 忽略解绑错误
            }
          }
        };

        // 订阅结果
        userAuthInstance.on('result', callback);

        // 启动认证
        console.info('开始启动认证...');
        userAuthInstance.start();
      });

    } catch (error) {
      const err = error as BusinessError;
      console.error(`auth catch error. Code is ${err.code}, message is ${err.message}`);
      return false;
    }
  }
}