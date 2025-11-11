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
    Column() {
      Text(this.welcomeText)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50, bottom: 30 })

      Text('车架号已绑定')
        .fontSize(16)
        .fontColor('#666666')
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
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F5F5F5')
  }
}
