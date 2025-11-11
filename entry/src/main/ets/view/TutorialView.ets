/**
 * TutorialView组件
 * 用于展示教程相关的视图
 */
@Component
export struct TutorialView {
  @Param tutorialTitle: string = '';
  @Param tutorialContent: string = '';
  @State isExpanded: boolean = false;

  build() {
    Column() {
      Row() {
        Text(this.tutorialTitle)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Image($r('app.media.startIcon'))
          .width(20)
          .height(20)
          .rotate(this.isExpanded ? 180 : 0)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        this.isExpanded = !this.isExpanded;
      })

      if (this.isExpanded) {
        Text(this.tutorialContent)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 10 })
          .width('100%')
      }
    }
    .width('100%')
    .padding(15)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .margin({ bottom: 10 })
  }
}
