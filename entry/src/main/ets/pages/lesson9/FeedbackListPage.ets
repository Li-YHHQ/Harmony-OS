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

@Entry
@Component
export struct FeedbackListPage {
  private studentInfo: string = '23001010613_李松伦';

  @State feedbackList: FeedbackItem[] = [
    {
      id: '1',
      title: '刹车异响问题',
      time: '2025-06-08 15:41:42',
      description: '刹车时有尖锐异响，尤其在冷启动时更明显。已检查刹车片磨损情况，需要进一步诊断刹车盘状态。',
      status: '已处理',
      type: '制动系统',
      detailContent: '车辆在冷启动后刹车时发出尖锐的金属摩擦声，持续约2-3分钟。热车后异响减轻但仍存在。初步判断为刹车片材质问题或刹车盘表面有硬点。建议更换高品质刹车片并检查刹车盘平整度。\n\n处理结果：已更换刹车片，异响问题解决。',
      processor: '张技师',
      processTime: '2025-06-09 10:30:15'
    },
    {
      id: '2',
      title: '空调不制冷',
      time: '2025-06-08 15:41:35',
      description: '空调开启后无冷风，疑似制冷剂泄漏。车内温度无法降低，影响驾驶舒适度。',
      status: '处理中',
      type: '空调系统',
      detailContent: '空调压缩机工作正常，但出风口无冷风。检测发现制冷剂压力为零，存在明显泄漏。需要检查空调管路、冷凝器、蒸发箱等部件，找到泄漏点后进行维修并重新加注制冷剂。\n\n当前进度：正在排查泄漏点，预计2天内完成维修。',
      processor: '李技师',
      processTime: '2025-06-08 16:20:30'
    },
    {
      id: '3',
      title: '车机系统卡顿',
      time: '2025-06-08 08:12:51',
      description: '导航界面卡顿，反应迟钝，影响使用体验。特别是在使用地图导航时延迟严重。',
      status: '待处理',
      type: '车载系统',
      detailContent: '车机系统在运行导航应用时出现明显卡顿，切换界面延迟约3-5秒。初步诊断为系统内存不足或软件冲突。已安排进行系统优化和软件更新，如问题持续需考虑硬件升级。\n\n建议解决方案：1. 系统软件更新 2. 清理缓存 3. 如无效则考虑硬件检测。',
      processor: '待分配',
      processTime: '待处理'
    }
  ];

  build() {
    Column() {
      Row() {
        Text('车辆反馈系统')
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

      Text(this.studentInfo)
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

      if (this.feedbackList.length > 0) {
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
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
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
}
