import router from '@ohos.router';

@Entry
@Component
export struct CarUserInformationPage {
  build() {
    Column({ space: 16 }) {
      Row() {
        Button('< 返回', { type: ButtonType.Normal })
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('用户操作信息')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank()
          .width(60)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#F5F5F5')

      Column({ space: 12 }) {
        Text('当前暂无用户操作明细')
          .fontSize(16)
          .fontColor('#333333')

        Text('待接口接入后，将展示用户的最新操作记录。')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .margin({ left: 24, right: 24 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
