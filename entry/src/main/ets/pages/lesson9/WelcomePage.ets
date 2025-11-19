
import router from '@ohos.router';
import { getToken } from '../../util/StorageUtil';
import { checkVehicleBindingAndNavigate } from '../../util/VehicleUtil';
import { Context } from '@kit.AbilityKit';

/**
 * 奥迪品牌欢迎页
 * 简化版，只显示静态图片
 */
@Entry
@Component
struct WelcomePage {
  @State skipVisible: boolean = false;  // 跳过按钮是否可见

  private token: string = '';
  private autoJumpTimer?: number;

  async aboutToAppear() {
    // 获取本地存储的token
    const context = getContext(this) as Context;
    this.token = await getToken(context);

    // 延迟显示跳过按钮
    setTimeout(() => {
      this.skipVisible = true;
    }, 1000);

    // 7.5秒后自动跳转
    this.autoJumpTimer = setTimeout(() => {
      this.navigateToNext();
    }, 7500);
  }

  aboutToDisappear() {
    // 清理定时器
    if (this.autoJumpTimer !== undefined) {
      clearTimeout(this.autoJumpTimer);
      this.autoJumpTimer = undefined;
    }
  }

  /**
   * 跳转到下一个页面
   */
  async navigateToNext() {
    if (this.autoJumpTimer !== undefined) {
      clearTimeout(this.autoJumpTimer);
      this.autoJumpTimer = undefined;
    }

    // 根据token状态跳转
    if (this.token && this.token.length > 0) {
      // 有token，检查车辆绑定状态后跳转
      await checkVehicleBindingAndNavigate(this.token);
    } else {
      // 无token，跳转到登录页
      router.replaceUrl({
        url: 'pages/lesson9/LoginPage_opt'
      });
    }
  }

  build() {
    Stack() {
      // 背景视频
      Video({
        src: $r('app.media.beijing')
      })
        .width('100%')
        .height('100%')
        .autoPlay(true)
        .muted(true)
        .loop(true)
        .controls(false)
        .backgroundColor('#000000')

      // 跳过按钮（右上角）
      if (this.skipVisible) {
        Row() {
          Text('跳过')
            .fontSize(14)
            .fontColor(Color.White)
            .opacity(0.8)
        }
        .width(70)
        .height(32)
        .borderRadius(16)
        .backgroundColor('rgba(255,255,255,0.15)')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .margin({ top: -670, right: -280 })
        .onClick(() => {
          this.navigateToNext();
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}