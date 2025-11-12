import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';
import { getToken } from '../../util/StorageUtil';
import { createFeedbackRequest, CreateFeedbackPayload, getUserInfoRequest } from '../../util/HttpUtil';

@Entry
@Component
export struct CreateFeedbackPage {
  @State title: string = '';
  @State description: string = '';
  @State detailContent: string = '';
  @State selectedType: string = '制动系统';
  @State contactPhone: string = '';
  @State submitRemark: string = '';
  @State isSubmitting: boolean = false;

  private userId: number = 0;
  private userName: string = '';
  private nickName: string = '';

  private studentInfo: string = '23001010613_李松伦';
  private feedbackTypes: string[] = ['制动系统', '空调系统', '车载系统', '影像系统', '胎压监测', '发动机系统', '其他问题'];

  async aboutToAppear() {
    await this.loadUserInfo();
  }

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
          .enabled(!this.isSubmitting)
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

          Column() {
            Text('联系电话 *')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入联系方式，便于我们联络您', text: this.contactPhone })
              .width('100%')
              .height(44)
              .fontSize(16)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.contactPhone = value;
              })
          }
          .width('100%')

          Column() {
            Text('备注信息')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 8 })

            TextInput({ placeholder: '可填写其他补充信息', text: this.submitRemark })
              .width('100%')
              .height(80)
              .fontSize(14)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.submitRemark = value;
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

  private async submitFeedback() {
    if (this.isSubmitting) {
      return;
    }

    if (!this.title.trim() || !this.description.trim()) {
      promptAction.showToast({
        message: '请填写标题和简要描述',
        duration: 2000
      });
      return;
    }

    if (!this.contactPhone.trim()) {
      promptAction.showToast({
        message: '请填写联系电话',
        duration: 2000
      });
      return;
    }

    this.isSubmitting = true;

    try {
      const context = getContext(this) as Context;
      const token = await getToken(context);

      if (!token) {
        throw new Error('请先登录后再提交反馈');
      }

      const now = this.formatNow();
      const payload: CreateFeedbackPayload = {
        id: Date.now(),
        userId: this.userId,
        userName: this.userName || '匿名用户',
        nickName: this.nickName || this.userName || '匿名用户',
        phonenumber: this.contactPhone.trim(),
        content: `${this.title.trim()}\n\n${this.description.trim()}${this.detailContent ? '\n\n' + this.detailContent.trim() : ''}`,
        status: '0',
        picUrl: '',
        delFlag: '1',
        searchValue: this.title.trim(),
        createBy: this.userName || '匿名用户',
        createTime: now,
        updateBy: this.userName || '匿名用户',
        updateTime: now,
        remark: this.submitRemark.trim(),
        params: {}
      };

      const response = await createFeedbackRequest(token, payload);
      if (response.code !== 200) {
        throw new Error(response.msg ?? '提交反馈失败');
      }

      promptAction.showToast({
        message: '反馈提交成功',
        duration: 2000
      });

      setTimeout(() => {
        router.back();
      }, 1200);
    } catch (error) {
      console.error(`提交反馈失败: ${JSON.stringify(error)}`);
      const message = (error && typeof error === 'object' && (error as Record<string, Object>).message)
        ? (error as Record<string, Object>).message as string
        : '提交失败，请稍后重试';
      promptAction.showToast({
        message,
        duration: 2000
      });
    } finally {
      this.isSubmitting = false;
    }
  }

  private async loadUserInfo() {
    try {
      const context = getContext(this) as Context;
      const token = await getToken(context);
      if (!token) {
        return;
      }

      const info = await getUserInfoRequest(token);
      if (info && info.user) {
        this.userId = Number(info.user.userId ?? 0);
        this.userName = info.user.userName ?? '';
        this.nickName = info.user.nickName ?? '';
        this.contactPhone = info.user.phonenumber ?? '';
        this.studentInfo = `${this.nickName || this.userName || '车辆反馈系统'}${this.contactPhone ? ' | ' + this.contactPhone : ''}`;
      }
    } catch (error) {
      console.error(`加载用户信息失败: ${JSON.stringify(error)}`);
    }
  }

  private formatNow(): string {
    const now = new Date();
    const pad = (num: number): string => num < 10 ? `0${num}` : `${num}`;
    const year = now.getFullYear();
    const month = pad(now.getMonth() + 1);
    const day = pad(now.getDate());
    const hours = pad(now.getHours());
    const minutes = pad(now.getMinutes());
    const seconds = pad(now.getSeconds());
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }
}
