import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';
import { getDarkMode, getToken } from '../../util/StorageUtil';
import { getFeedbackDetailRequest, FeedbackDetailRecord } from '../../util/HttpUtil';

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
  nickName: string;
  phonenumber: string;
  reply?: string;
  picUrl?: string;
}

interface RouterParams {
  feedbackData?: string;
  feedbackId?: string;
}

@Entry
@Component
export struct FeedbackDetailPage {
  @State feedbackData: FeedbackItem = {
    id: '',
    title: '意见反馈详情',
    time: '',
    description: '',
    status: '',
    type: '',
    detailContent: '',
    processor: '',
    processTime: '',
    nickName: '',
    phonenumber: ''
  };

  @State loading: boolean = false;
  @State loadError: string = '';
  @State isDarkMode: boolean = false;

  private studentInfo: string = '反馈详情';
  private currentId: string = '';

  async onPageShow() {
    const context = getContext(this) as Context;
    this.isDarkMode = await getDarkMode(context);

    const params = router.getParams() as RouterParams;
    if (params) {
      if (params.feedbackData) {
        try {
          const localData = JSON.parse(params.feedbackData) as FeedbackItem;
          this.feedbackData = localData;
          this.currentId = localData.id;
          this.studentInfo = `${localData.nickName || '反馈详情'}${localData.phonenumber ? ' | ' + localData.phonenumber : ''}`;
        } catch (error) {
          console.error('解析反馈数据失败: ' + error);
        }
      }

      if (params.feedbackId) {
        this.currentId = params.feedbackId;
      }
    }

    if (this.currentId) {
      this.fetchDetail(this.currentId);
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
      .backgroundColor(this.isDarkMode ? '#101622' : '#F5F5F5')

      Text(this.studentInfo)
        .fontSize(14)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding(10)
        .backgroundColor('#007AFF')
        .fontWeight(FontWeight.Medium)

      if (this.loading) {
        Column({ space: 12 }) {
          Text('正在加载反馈详情...')
            .fontSize(16)
            .fontColor('#666666')
          Text('请稍候')
            .fontSize(12)
            .fontColor('#999999')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.loadError) {
        Column({ space: 16 }) {
          Text('加载失败')
            .fontSize(16)
            .fontColor('#FF3B30')
          Text(this.loadError)
            .fontSize(12)
            .fontColor('#999999')
            .textAlign(TextAlign.Center)
            .margin({ left: 24, right: 24 })
          Button('重新加载', { type: ButtonType.Normal })
            .fontSize(14)
            .backgroundColor('#007AFF')
            .fontColor(Color.White)
            .borderRadius(20)
            .padding({
              left: 20,
              right: 20,
              top: 8,
              bottom: 8
            })
            .onClick(() => {
              if (this.currentId) {
                this.fetchDetail(this.currentId);
              }
            })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
        Column({ space: 16 }) {
          Column() {
            Row() {
              Text(this.feedbackData.title)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.isDarkMode ? '#F9FAFB' : '#333333')
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
                Text('反馈人')
                  .fontSize(12)
                  .fontColor(this.isDarkMode ? '#9CA3AF' : '#666666')
                Text(this.feedbackData.nickName || '匿名用户')
                  .fontSize(14)
                  .fontColor(this.isDarkMode ? '#F9FAFB' : '#333333')
                  .fontWeight(FontWeight.Medium)
              }
              .layoutWeight(1)

              Column({ space: 4 }) {
                Text('联系电话')
                  .fontSize(12)
                  .fontColor('#666666')
                Text(this.feedbackData.phonenumber || '未提供')
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
          .backgroundColor(this.isDarkMode ? '#111827' : Color.White)
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
              .fontColor(this.isDarkMode ? '#E5E7EB' : '#555555')
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

          if (this.feedbackData.reply) {
            Column() {
              Text('回复信息')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ bottom: 12 })

              Text(this.feedbackData.reply)
                .fontSize(14)
                .fontColor(this.isDarkMode ? '#E5E7EB' : '#555555')
                .lineHeight(20)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(this.isDarkMode ? '#111827' : Color.White)
            .borderRadius(12)
            .shadow({
              radius: 2,
              color: '#0A000000',
              offsetX: 0,
              offsetY: 1
            })
          }

          if (this.feedbackData.picUrl) {
            Column({ space: 12 }) {
              Text('相关图片')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')

              Image(this.normalizePicUrl(this.feedbackData.picUrl))
                .width('100%')
                .height(220)
                .borderRadius(12)
                .objectFit(ImageFit.Cover)
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
        }
        .padding(16)
      }
      .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? '#020617' : '#F5F5F5')
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

  private async fetchDetail(id: string) {
    if (this.loading) {
      return;
    }
    this.loading = true;
    this.loadError = '';

    try {
      const context = getContext(this) as Context;
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后查看详情');
      }

      const response = await getFeedbackDetailRequest(token, id);
      if (response.code !== 200 || !response.data) {
        throw new Error(response.msg ?? '获取反馈详情失败');
      }

      const detail = response.data;
      this.feedbackData = {
        id: detail.id ?? id,
        title: this.extractTitle(detail.content ?? '意见反馈详情'),
        time: detail.createTime ?? '未知时间',
        description: detail.content ?? '暂无描述',
        status: this.formatStatus(detail.status),
        type: '意见反馈',
        detailContent: detail.content ?? '暂无详情',
        processor: detail.updateBy ?? '客服处理中',
        processTime: detail.updateTime ?? '待更新',
        nickName: detail.nickName ?? detail.userName ?? '匿名用户',
        phonenumber: detail.phonenumber ?? '未提供',
        reply: detail.reply,
        picUrl: detail.picUrl
      };

      this.studentInfo = `${this.feedbackData.nickName || '反馈详情'}${this.feedbackData.phonenumber ? ' | ' + this.feedbackData.phonenumber : ''}`;
    } catch (error) {
      console.error(`加载反馈详情异常: ${JSON.stringify(error)}`);
      const message = (error && typeof error === 'object' && (error as Record<string, Object>).message)
        ? (error as Record<string, Object>).message as string
        : '获取反馈详情失败';
      this.loadError = message;
      promptAction.showToast({
        message,
        duration: 2000
      });
    } finally {
      this.loading = false;
    }
  }

  private formatStatus(status?: string): string {
    switch (status) {
      case '1':
      case '已处理':
        return '已处理';
      case '0':
      case '待处理':
        return '待处理';
      default:
        return '处理中';
    }
  }

  private extractTitle(content: string): string {
    const trimmed = content.trim();
    if (trimmed.length <= 12) {
      return trimmed;
    }
    return `${trimmed.substring(0, 12)}...`;
  }

  private normalizePicUrl(picUrl: string): string {
    if (!picUrl) {
      return '';
    }
    return picUrl.startsWith('http') ? picUrl : `http://121.36.14.143:10001${picUrl}`;
  }
}
