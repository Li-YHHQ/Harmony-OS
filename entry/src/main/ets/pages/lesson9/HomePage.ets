import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';

/**
 * 首页
 * 应用主页面
 */
@Entry
@Component
struct HomePage {
  @State welcomeText: string = '欢迎来到首页';

  build() {
    Stack() {
      // 背景图片
      Image($r('app.media.login2_lsl613'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 前景内容
      Column() {
        Text(this.welcomeText)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 80, bottom: 30 })
          .opacity(0.7)

        Text('车架号已绑定')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .opacity(0.9)
          .margin({ bottom: 20 })

        Button('进入')
          .width('80%')
          .height(45)
          .borderRadius(10)
          .fontSize(16)
          .backgroundColor('#0A59F7')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/lesson9/MinePage'
            });
          })
      }
      .margin({top:700})
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}
