import { HMNavigation, HMDefaultGlobalAnimator } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  modifier: MyNavModifier = new MyNavModifier();

  build() {
    Column() {
      HMNavigation({
        navigationId: 'main_nav',
        homePageUrl: 'MainPage',
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}

class MyNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.hideNavBar(true); // 隐藏默认导航栏
  }
}