import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

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

@Entry
@Component
export struct CreateFeedbackPage {
  @State title: string = '';
  @State description: string = '';
  @State detailContent: string = '';
  @State selectedType: string = '制动系统';

  private studentInfo: string = '23001010613_李松伦';
  private feedbackTypes: string[] = ['制动系统', '空调系统', '车载系统', '影像系统', '胎压监测', '发动机系统', '其他问题'];

  build() {
    Column() {
      Row() {
        Button('< 取消', { type: ButtonType.Normal })
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('创建新反馈')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('提交', { type: ButtonType.Normal })
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.submitFeedback();
          })
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
            Text('问题标题 *')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入问题标题', text: this.title })
              .width('100%')
              .height(44)
              .fontSize(16)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.title = value;
              })
          }
          .width('100%')

          Column() {
            Text('问题类型 *')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 8 })

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.feedbackTypes, (type: string) => {
                Button(type, { type: ButtonType.Normal })
                  .fontSize(14)
                  .fontColor(this.selectedType === type ? Color.White : '#333333')
                  .backgroundColor(this.selectedType === type ? '#007AFF' : '#F0F0F0')
                  .borderRadius(16)
                  .padding({
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8
                  })
                  .margin({ right: 8, bottom: 8 })
                  .onClick(() => {
                    this.selectedType = type;
                  })
              })
            }
            .width('100%')
          }
          .width('100%')

          Column() {
            Text('简要描述 *')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请简要描述您遇到的问题', text: this.description })
              .width('100%')
              .height(80)
              .fontSize(14)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.description = value;
              })
          }
          .width('100%')

          Column() {
            Text('详细内容')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请详细描述问题的具体情况、出现频率、影响等', text: this.detailContent })
              .width('100%')
              .height(120)
              .fontSize(14)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.detailContent = value;
              })
          }
          .width('100%')
        }
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  private submitFeedback() {
    if (!this.title.trim() || !this.description.trim()) {
      promptAction.showToast({
        message: '请填写标题和简要描述',
        duration: 2000
      });
      return;
    }

    promptAction.showToast({
      message: '反馈提交成功',
      duration: 2000
    });

    setTimeout(() => {
      router.back();
    }, 1500);
  }
}
