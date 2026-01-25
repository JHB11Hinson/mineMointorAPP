import { HMLifecycle, IHMLifecycle, HMLifecycleContext } from '@hadss/hmrouter';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

@HMLifecycle({ lifecycleName: 'ExitAppLifecycle' })
export class ExitAppLifecycle implements IHMLifecycle {
  private lastTime: number = 0;

  onBackPressed(ctx: HMLifecycleContext): boolean {
    const currentTime = new Date().getTime();
    const interval = currentTime - this.lastTime;

    if (interval > 2000) {
      this.lastTime = currentTime;
      try {
        promptAction.showToast({
          message: '再按一次退出应用',
          duration: 2000
        });
      } catch (error) {
        console.error('Toast error:', error);
      }
      return true; // 拦截返回，不退出
    } else {
      const context = AppStorage.get<common.UIAbilityContext>('UIAbilityContext');

      if (context) {
        context.terminateSelf().catch((err: Error) => {
          console.error('TerminateSelf failed:', err);
        });
      }

      return false;
    }
  }
}