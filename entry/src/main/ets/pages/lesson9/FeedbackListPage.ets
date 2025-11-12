import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';
import { getFeedbackListRequest, deleteFeedbackRequest, FeedbackRecord } from '../../util/HttpUtil';
import { getToken } from '../../util/StorageUtil';

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
  contact: string;
  picUrl?: string;
}

@Entry
@Component
export struct FeedbackListPage {
  @State studentInfo: string = '车辆反馈系统';
  @State feedbackList: FeedbackItem[] = [];
  @State isLoading: boolean = false;
  @State loadError: string = '';
  @State deletingId: string = '';
  private shouldRefreshAfterReturn: boolean = false;

  async aboutToAppear() {
    await this.fetchFeedbackList();
  }

  onPageShow() {
    if (this.shouldRefreshAfterReturn) {
      this.shouldRefreshAfterReturn = false;
      this.fetchFeedbackList(true);
      return;
    }

    if (!this.isLoading && this.feedbackList.length === 0) {
      this.fetchFeedbackList();
    }
  }

  build() {
    Column() {
      Row() {
        Button(this.isLoading ? '刷新中…' : '刷新', { type: ButtonType.Normal })
          .fontSize(14)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .padding({
            left: 8,
            right: 8,
            top: 6,
            bottom: 6
          })
          .enabled(!this.isLoading)
          .onClick(() => {
            this.fetchFeedbackList(true);
          })

        Text('车辆反馈系统')
          // .position({ x: '20' })
          .margin({ right: '-10%' })
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('+ 新反馈', { type: ButtonType.Normal })
          .fontSize(14)
          .backgroundColor('#007AFF')
          .fontColor(Color.White)
          .borderRadius(20)
          .padding({
            left: 16,
            right: 16,
            top: 8,
            bottom: 8
          })
          .onClick(() => {
            this.shouldRefreshAfterReturn = true;
            router.pushUrl({
              url: 'pages/lesson9/CreateFeedbackPage'
            });
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

      // Text(this.studentInfo)
      Text("23001010613")
        .fontSize(16)
        .fontColor('#FFFFFF')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding(12)
        .backgroundColor('#007AFF')
        .fontWeight(FontWeight.Medium)

      Row() {
        Column() {
          Text(this.getStatusCount('已处理').toString())
            .fontSize(20)
            .fontColor('#00B365')
            .fontWeight(FontWeight.Bold)
          Text('已处理')
            .fontSize(12)
            .fontColor('#666666')
        }
        .layoutWeight(1)

        Column() {
          Text(this.getStatusCount('处理中').toString())
            .fontSize(20)
            .fontColor('#FF9500')
            .fontWeight(FontWeight.Bold)
          Text('处理中')
            .fontSize(12)
            .fontColor('#666666')
        }
        .layoutWeight(1)

        Column() {
          Text(this.getStatusCount('待处理').toString())
            .fontSize(20)
            .fontColor('#FF3B30')
            .fontWeight(FontWeight.Bold)
          Text('待处理')
            .fontSize(12)
            .fontColor('#666666')
        }
        .layoutWeight(1)

        Column() {
          Text(this.feedbackList.length.toString())
            .fontSize(20)
            .fontColor('#007AFF')
            .fontWeight(FontWeight.Bold)
          Text('总计')
            .fontSize(12)
            .fontColor('#666666')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)
      .margin({ bottom: 8 })

      if (this.isLoading) {
        Column({ space: 12 }) {
          Text('正在加载反馈数据...')
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
          Text('加载反馈数据失败')
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
              this.fetchFeedbackList();
            })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.feedbackList.length > 0) {
        List({ space: 8 }) {
          ForEach(this.feedbackList, (item: FeedbackItem) => {
            ListItem() {
              this.FeedbackItemCard(item);
            }
          }, (item: FeedbackItem) => item.id)
        }
        .layoutWeight(1)
        .padding(8)
      } else {
        Column() {
          Text('\uD83D\uDCDD')
            .fontSize(48)
            .margin({ bottom: 16 })
          Text('暂无反馈记录')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ bottom: 8 })
          Text('点击"新反馈"按钮创建第一个反馈')
            .fontSize(12)
            .fontColor('#666666')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  FeedbackItemCard(item: FeedbackItem) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)

        Text(item.status)
          .fontSize(12)
          .fontColor(this.getStatusColor(item.status))
          .padding({
            left: 8,
            right: 8,
            top: 4,
            bottom: 4
          })
          .backgroundColor(this.getStatusBgColor(item.status))
          .borderRadius(10)
      }
      .width('100%')
      .margin({ bottom: 8 })

      Row() {
        Text('故障类型：' + item.type)
          .fontSize(12)
          .fontColor('#666666')
          .layoutWeight(1)

        Text(item.time)
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ bottom: 8 })

      Row() {
        Text('联系人：' + (item.nickName || '未提供'))
          .fontSize(12)
          .fontColor('#666666')
          .layoutWeight(1)

        Text('联系电话：' + (item.contact || '未提供'))
          .fontSize(12)
          .fontColor('#666666')
      }
      .width('100%')
      .margin({ bottom: 8 })

      Text(item.description)
        .fontSize(14)
        .fontColor('#555555')
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 12 })

      if (item.status !== '待处理') {
        Row() {
          Text('处理人：' + item.processor)
            .fontSize(11)
            .fontColor('#666666')
            .layoutWeight(1)
          Text('处理时间：' + item.processTime)
            .fontSize(11)
            .fontColor('#666666')
        }
        .width('100%')
        .margin({ bottom: 8 })
      }

      Row() {
        Button('查看详情 →', { type: ButtonType.Normal })
          .fontSize(14)
          .fontColor('#007AFF')
          .backgroundColor('#E6F3FF')
          .borderRadius(16)
          .padding({
            left: 16,
            right: 16,
            top: 6,
            bottom: 6
          })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/lesson9/FeedbackDetailPage',
              params: { feedbackData: JSON.stringify(item) }
            });
          })

        Button(this.deletingId === item.id ? '删除中…' : '删除', { type: ButtonType.Normal })
          .fontSize(14)
          .fontColor('#FF3B30')
          .backgroundColor('#FFECEC')
          .borderRadius(16)
          .padding({
            left: 16,
            right: 16,
            top: 6,
            bottom: 6
          })
          .enabled(this.deletingId !== item.id)
          .onClick(() => {
            this.deleteFeedback(item.id);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .margin({ bottom: 8 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#F9F9F9')
    .borderRadius(12)
    .shadow({
      radius: 4,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 2
    })
    .margin({ bottom: 8 })
  }

  private getStatusCount(status: string): number {
    return this.feedbackList.filter(item => item.status === status).length;
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

  private async fetchFeedbackList(isManual: boolean = false) {
    if (this.isLoading) {
      if (isManual) {
        promptAction.showToast({
          message: '正在刷新，请稍候…',
          duration: 2000
        });
      }
      return;
    }
    this.isLoading = true;
    this.loadError = '';

    try {
      const context = getContext(this) as Context;
      const token = await getToken(context);

      if (!token) {
        const message = '未检测到登录信息，请先登录';
        this.loadError = message;
        this.feedbackList = [];
        promptAction.showToast({
          message,
          duration: 2000
        });
        return;
      }

      const response = await getFeedbackListRequest(token);
      if (response.code !== 200 || !response.data) {
        const message = response.msg ?? '获取反馈数据失败';
        throw new Error(message);
      }

      const records = Array.isArray(response.data) ? response.data : [];
      const mapped = records.map((record: FeedbackRecord) => this.mapRecordToItem(record));
      this.feedbackList = mapped;

      if (mapped.length > 0) {
        const first = mapped[0];
        this.studentInfo = `${first.nickName || '意见反馈'}${first.contact ? ' | ' + first.contact : ''}`;
      }
    } catch (error) {
      console.error(`加载反馈列表异常: ${JSON.stringify(error)}`);
      const message = (error && typeof error === 'object' && (error as Record<string, Object>).message)
        ? (error as Record<string, Object>).message as string
        : '获取反馈数据失败';
      this.loadError = message;
      promptAction.showToast({
        message,
        duration: 2000
      });
      this.feedbackList = [];
    } finally {
      this.isLoading = false;
      if (isManual) {
        promptAction.showToast({
          message: '刷新完成',
          duration: 1500
        });
      }
    }
  }

  private mapRecordToItem(record: FeedbackRecord): FeedbackItem {
    const status = this.formatStatus(record.status);
    return {
      id: record.id ?? '',
      title: record.content ? this.extractTitle(record.content) : (record.nickName ?? record.userName ?? '用户反馈'),
      time: record.createTime ?? '未知时间',
      description: record.content ?? '暂无描述',
      status,
      type: '意见反馈',
      detailContent: record.content ?? '暂无详情',
      processor: record.updateBy ?? '客服处理中',
      processTime: record.updateTime ?? '待更新',
      nickName: record.nickName ?? record.userName ?? '匿名用户',
      contact: record.phonenumber ?? '未提供',
      picUrl: record.picUrl
    };
  }

  private async deleteFeedback(id: string) {
    if (!id) {
      promptAction.showToast({
        message: '未找到反馈ID，无法删除',
        duration: 2000
      });
      return;
    }

    if (this.deletingId) {
      return;
    }

    this.deletingId = id;

    try {
      const context = getContext(this) as Context;
      const token = await getToken(context);

      if (!token) {
        throw new Error('未检测到登录信息，请先登录');
      }

      const response = await deleteFeedbackRequest(token, id);
      if (response.code !== 200) {
        throw new Error(response.msg ?? '删除反馈失败');
      }

      promptAction.showToast({
        message: response.msg ?? '删除成功',
        duration: 2000
      });

      this.feedbackList = this.feedbackList.filter(item => item.id !== id);

      if (this.feedbackList.length > 0) {
        const first = this.feedbackList[0];
        this.studentInfo = `${first.nickName || '意见反馈'}${first.contact ? ' | ' + first.contact : ''}`;
      } else {
        this.studentInfo = '车辆反馈系统';
      }
    } catch (error) {
      console.error(`删除反馈异常: ${JSON.stringify(error)}`);
      const message = (error && typeof error === 'object' && (error as Record<string, Object>).message)
        ? (error as Record<string, Object>).message as string
        : '删除反馈失败';
      promptAction.showToast({
        message,
        duration: 2000
      });
    } finally {
      this.deletingId = '';
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
}
