import router from '@ohos.router';

interface FeedbackItem {
  id: string;
  title: string;
  time: string;
  description: string;
  status: string;
  type: string;
  detailContent: string;
  processor: string;
  processTime: string;
}

interface RouterParams {
  feedbackData?: string;
}

@Entry
@Component
export struct FeedbackDetailPage {
  @State feedbackData: FeedbackItem = {
    id: '',
    title: '',
    time: '',
    description: '',
    status: '',
    type: '',
    detailContent: '',
    processor: '',
    processTime: ''
  };

  private studentInfo: string = '23001010613_李松伦';

  onPageShow() {
    const params = router.getParams() as RouterParams;
    if (params && params.feedbackData) {
      try {
        this.feedbackData = JSON.parse(params.feedbackData);
      } catch (error) {
        console.error('解析反馈数据失败: ' + error);
      }
    }
  }

  build() {
    Column() {
      Row() {
        Button('< 返回', { type: ButtonType.Normal })
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('反馈详情')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(60)
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 12
      })
      .backgroundColor('#F5F5F5')

      Text(this.studentInfo)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding(10)
        .backgroundColor('#007AFF')
        .fontWeight(FontWeight.Medium)

      Scroll() {
        Column({ space: 16 }) {
          Column() {
            Row() {
              Text(this.feedbackData.title)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .layoutWeight(1)

              Text(this.feedbackData.status)
                .fontSize(12)
                .fontColor(this.getStatusColor(this.feedbackData.status))
                .padding({
                  left: 12,
                  right: 12,
                  top: 6,
                  bottom: 6
                })
                .backgroundColor(this.getStatusBgColor(this.feedbackData.status))
                .borderRadius(12)
            }
            .width('100%')
            .margin({ bottom: 16 })

            Row() {
              Column({ space: 4 }) {
                Text('故障类型')
                  .fontSize(12)
                  .fontColor('#666666')
                Text(this.feedbackData.type)
                  .fontSize(14)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)

              Column({ space: 4 }) {
                Text('提交时间')
                  .fontSize(12)
                  .fontColor('#666666')
                Text(this.feedbackData.time)
                  .fontSize(14)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Column({ space: 4 }) {
                Text('处理人员')
                  .fontSize(12)
                  .fontColor('#666666')
                Text(this.feedbackData.processor)
                  .fontSize(14)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)

              Column({ space: 4 }) {
                Text('处理时间')
                  .fontSize(12)
                  .fontColor('#666666')
                Text(this.feedbackData.processTime)
                  .fontSize(14)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .shadow({
            radius: 2,
            color: '#0A000000',
            offsetX: 0,
            offsetY: 1
          })

          Column() {
            Text('问题描述')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 12 })

            Text(this.feedbackData.description)
              .fontSize(14)
              .fontColor('#555555')
              .lineHeight(20)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .shadow({
            radius: 2,
            color: '#0A000000',
            offsetX: 0,
            offsetY: 1
          })

          Column() {
            Text('详细内容')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 12 })

            Text(this.feedbackData.detailContent)
              .fontSize(14)
              .fontColor('#555555')
              .lineHeight(22)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .shadow({
            radius: 2,
            color: '#0A000000',
            offsetX: 0,
            offsetY: 1
          })
        }
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  private getStatusColor(status: string): ResourceColor {
    switch (status) {
      case '已处理':
        return '#00B365';
      case '处理中':
        return '#FF9500';
      case '待处理':
        return '#FF3B30';
      default:
        return '#666666';
    }
  }

  private getStatusBgColor(status: string): ResourceColor {
    switch (status) {
      case '已处理':
        return '#E6F4EE';
      case '处理中':
        return '#FFF2E6';
      case '待处理':
        return '#FFEBE9';
      default:
        return '#F0F0F0';
    }
  }
}
