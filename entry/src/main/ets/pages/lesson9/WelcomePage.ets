// import router from '@ohos.router';
// import { getToken } from '../../util/StorageUtil';
// import { checkVehicleBindingAndNavigate } from '../../util/VehicleUtil';
// import { Context } from '@kit.AbilityKit';
//
// /**
//  * 奥迪品牌欢迎页
//  * 包含四环闪光动画效果
//  */
// @Entry
// @Component
// struct WelcomePage {
//   @State overlayOpacity: number = 1.0;  // 浅色底图透明度
//   @State animationCount: number = 0;  // 动画循环次数
//   @State isAnimating: boolean = true;  // 是否正在播放动画
//   @State skipVisible: boolean = false;  // 跳过按钮是否可见
//
//   private token: string = '';
//   private animationTimer: number = -1;
//   private autoJumpTimer?: number;
//
//   async aboutToAppear() {
//     // 获取本地存储的token
//     const context = getContext(this) as Context;
//     this.token = await getToken(context);
//
//     // 延迟显示跳过按钮
//     setTimeout(() => {
//       this.skipVisible = true;
//     }, 1000);
//
//     // 开始动画
//     this.startAnimation();
//
//     // 动画播放3次后自动跳转（3次 × 2.5秒 = 7.5秒）
//     this.autoJumpTimer = setTimeout(() => {
//       this.navigateToNext();
//     }, 7500);
//   }
//
//   aboutToDisappear() {
//     // 清理定时器
//     if (this.animationTimer !== -1) {
//       clearInterval(this.animationTimer);
//     }
//     if (this.autoJumpTimer !== undefined) {
//       clearTimeout(this.autoJumpTimer);
//       this.autoJumpTimer = undefined;
//     }
//   }
//
//   /**
//    * 开始四环闪光动画
//    */
//   startAnimation() {
//     if (!this.isAnimating) {
//       return;
//     }
//
//     // 每个动画周期2.5秒
//     const cycleDuration = 2500;
//     const halfCycle = cycleDuration / 2;
//
//     // 执行一次完整的闪光动画
//     const performFlash = () => {
//       if (!this.isAnimating || this.animationCount >= 3) {
//         return;
//       }
//
//       // 闪光：亮度增强 + 光晕
//       animateTo({
//         duration: halfCycle,
//         // curve: Curve.EaseInOut
//         curve: Curve.Friction
//       }, () => {
//         this.overlayOpacity = 1.2;
//       });
//
//       // 恢复
//       setTimeout(() => {
//         if (this.isAnimating && this.animationCount < 3) {
//           animateTo({
//             duration: halfCycle,
//             curve: Curve.EaseInOut
//           }, () => {
//             this.overlayOpacity = 0.0;
//           });
//
//           // 动画计数
//           this.animationCount++;
//
//           // 如果未达到3次，继续下一次
//           if (this.animationCount < 3) {
//             setTimeout(() => {
//               performFlash();
//             }, 200); // 短暂停顿后继续
//           }
//         }
//       }, halfCycle);
//     };
//
//     // 开始第一次动画
//     performFlash();
//   }
//
//   /**
//    * 跳转到下一个页面
//    */
//   async navigateToNext() {
//     // 停止动画
//     this.isAnimating = false;
//     if (this.animationTimer !== -1) {
//       clearInterval(this.animationTimer);
//     }
//     if (this.autoJumpTimer !== undefined) {
//       clearTimeout(this.autoJumpTimer);
//       this.autoJumpTimer = undefined;
//     }
//
//     // 根据token状态跳转
//     if (this.token && this.token.length > 0) {
//       // 有token，检查车辆绑定状态后跳转
//       await checkVehicleBindingAndNavigate(this.token);
//     } else {
//       // 无token，跳转到登录页
//       router.replaceUrl({
//         url: 'pages/lesson9/LoginPage_opt'
//       });
//     }
//   }
//
//   build() {
//     Stack() {
//       // 背景图片
//       Image($r('app.media.dark'))
//         .width('100%')
//         .height('100%')
//         .objectFit(ImageFit.Cover)
//         .backgroundColor('#000000')
//
//       // 浅色底图（包含四环与文字），用于闪光效果
//       Image($r('app.media.light'))
//         .width('100%')
//         .height('100%')
//         .objectFit(ImageFit.Cover)
//         .opacity(this.overlayOpacity)
//
//       // 跳过按钮（右上角）
//       if (this.skipVisible) {
//         Row() {
//           Text('跳过')
//             .fontSize(14)
//             .fontColor(Color.White)
//             .opacity(0.8)
//         }
//           .width(70)
//           .height(32)
//           .borderRadius(16)
//           .backgroundColor('rgba(255,255,255,0.15)')
//           .justifyContent(FlexAlign.Center)
//           .alignItems(VerticalAlign.Center)
//           .margin({ top: -670, right: -280 })
//           .onClick(() => {
//             this.navigateToNext();
//           })
//       }
//     }
//       .width('100%')
//       .height('100%')
//   }
// }


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
      // 背景图片 - 使用welcome图片
      Image($r("app.media.welcome_PIC"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
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