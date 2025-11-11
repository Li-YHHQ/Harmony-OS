/**
 * EnablementView组件
 * 用于展示启用/功能相关的视图
 */
@Component
export struct EnablementView {
  @State isEnabled: boolean = false;
  @Param title: string = '';

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Row() {
        Text(this.isEnabled ? '已启用' : '未启用')
          .fontSize(16)
          .fontColor(this.isEnabled ? '#007DFF' : '#999999')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(10)
      .borderRadius(8)
      .backgroundColor('#F5F5F5')
      .onClick(() => {
        this.isEnabled = !this.isEnabled;
      })
    }
    .width('100%')
    .padding(15)
  }
}
