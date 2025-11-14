import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';
import router from '@ohos.router';
import { getToken } from '../../util/StorageUtil';
import { CarOperationLogRecord, getCarOperationLogListRequest, deleteCarOperationLogRequest, CarOperationLogQueryParams } from '../../util/HttpUtil';

interface CarOperationLogViewItem extends CarOperationLogRecord {
  key: string;
}


interface DialogButtonOption {
  text: string;
  color: string;
}

interface DialogResult {
  index?: number;
}

@Entry
@Component
export struct CarUserInformationPage {
  private readonly pageSize: number = 20;

  @State private logs: CarOperationLogViewItem[] = [];
  @State private loading: boolean = false;
  @State private loadError: string = '';
  @State private refreshing: boolean = false;
  @State private deletingId: string = '';

  aboutToAppear() {
    this.loadLogs();
  }

  build() {
    Column() {
      this.Header();

      if (this.loading && this.logs.length === 0) {
        this.LoadingSection();
      } else if (this.loadError && this.logs.length === 0) {
        this.ErrorSection();
      } else if (this.logs.length === 0) {
        this.EmptySection();
      } else {
        this.LogList();
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F6F8')
  }

  private async loadLogs(isRefresh: boolean = false) {
    if (this.loading && !isRefresh) {
      return;
    }

    const context = getContext(this) as Context;
    this.loadError = '';
    if (isRefresh) {
      this.refreshing = true;
    } else {
      this.loading = true;
    }

    try {
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后查看操作日志');
      }

      const queryParams: CarOperationLogQueryParams = {
        pageNum: 1,
        pageSize: this.pageSize,
        orderByColumn: 'create_time',
        isAsc: 'desc'
      };
      console.info(`[CarUserInformation] 请求日志列表 参数=${JSON.stringify(queryParams)}`);
      const response = await getCarOperationLogListRequest(token, queryParams);
      console.info(`[CarUserInformation] 日志列表接口响应 code=${response.code}, msg=${response.msg ?? ''}, total=${response.total ?? '-'}, rowsLength=${Array.isArray(response.rows) ? response.rows.length : 'N/A'}`);

      if (response.code !== 200) {
        throw new Error(response.msg ?? '获取日志列表失败');
      }

      const rows = Array.isArray(response.rows) ? response.rows : [];
      console.info(`[CarUserInformation] 获取日志成功，数量=${rows.length}`);
      const mapped: CarOperationLogViewItem[] = [];
      for (let index = 0; index < rows.length; index++) {
        const record = rows[index];
        console.info(`[CarUserInformation] 原始记录 index=${index} id=${record?.id ?? 'unknown'} type=${record?.operaType ?? ''} content=${record?.operaContent ?? ''}`);
        mapped.push(this.mapRecordToViewItem(record, index));
      }
      this.logs = mapped;
    } catch (error) {
      console.error(`加载车辆操作日志失败: ${JSON.stringify(error)}`);
      let message = '获取日志列表失败';
      if (error && typeof error === 'object') {
        const errObj = error as Record<string, Object>;
        if (errObj.message && typeof errObj.message === 'string') {
          message = errObj.message as string;
        }
      }
      this.loadError = message;
      promptAction.showToast({ message, duration: 2000 });
    } finally {
      this.loading = false;
      this.refreshing = false;
    }
  }

  private mapRecordToViewItem(record: CarOperationLogRecord, index: number): CarOperationLogViewItem {
    const key = record.id ?? `log-${index}`;
    const viewItem: CarOperationLogViewItem = {
      key: key,
      id: record.id ?? key
    };

    viewItem.createBy = record.createBy;
    viewItem.createTime = record.createTime;
    viewItem.updateBy = record.updateBy;
    viewItem.updateTime = record.updateTime;
    viewItem.userId = record.userId;
    viewItem.userName = record.userName;
    viewItem.carId = record.carId;
    viewItem.carName = record.carName;
    viewItem.operaType = record.operaType;
    viewItem.operaContent = record.operaContent;

    console.info(`[CarUserInformation] 映射后的记录 key=${viewItem.key} type=${viewItem.operaType ?? ''} content=${viewItem.operaContent ?? ''}`);

    return viewItem;
  }

  private async confirmDelete(item: CarOperationLogViewItem) {
    const buttons: DialogButtonOption[] = [
      {
        text: '取消',
        color: '#6B7280'
      },
      {
        text: '确定',
        color: '#FF3B30'
      }
    ];

    try {
      const result = await promptAction.showDialog({
        title: '删除确认',
        message: `确定删除「${item.operaType ?? '操作'}」记录吗？`,
        buttons
      });

      let index = -1;
      if (result && typeof result === 'object') {
        const dialogResult = result as DialogResult;
        if (dialogResult.index !== undefined && typeof dialogResult.index === 'number') {
          index = dialogResult.index;
        }
      }
      console.info(`[CarUserInformation] 删除确认结果 index=${index}`);
      if (index === 1) {
        this.deleteLog(item);
      }
    } catch (error) {
      console.error(`[CarUserInformation] 显示删除确认对话框失败: ${JSON.stringify(error)}`);
    }
  }

  private async deleteLog(item: CarOperationLogViewItem) {
    if (!item.id || this.deletingId === item.id) {
      return;
    }

    const context = getContext(this) as Context;
    this.deletingId = item.id;
    console.info(`[CarUserInformation] 准备删除日志，id=${item.id}, key=${item.key}`);

    try {
      const token = await getToken(context);
      if (!token) {
        console.warn('[CarUserInformation] 删除失败：未获取到token');
        throw new Error('请先登录后操作');
      }

      const response = await deleteCarOperationLogRequest(token, item.id);
      console.info(`[CarUserInformation] 删除接口返回：${JSON.stringify(response)}`);
      if (response.code !== 200) {
        throw new Error(response.msg ?? '删除失败');
      }

      this.logs = this.logs.filter((log) => log.id !== item.id);
      console.info(`[CarUserInformation] 本地日志已更新，剩余数量=${this.logs.length}`);
      if (!this.logs.some((log) => log.id === item.id)) {
        console.info('[CarUserInformation] 触发刷新以同步服务器数据');
        this.loadLogs(true);
      }
      promptAction.showToast({ message: '删除成功', duration: 1500 });
    } catch (error) {
      console.error(`[CarUserInformation] 删除车辆操作日志失败: ${JSON.stringify(error)}`);
      let message = '删除失败';
      if (error && typeof error === 'object') {
        const errObj = error as Record<string, Object>;
        if (errObj.message && typeof errObj.message === 'string') {
          message = errObj.message as string;
        }
      }
      promptAction.showToast({ message, duration: 2000 });
    } finally {
      console.info('[CarUserInformation] 删除流程结束，重置状态');
      this.deletingId = '';
    }
  }

  @Builder
  private Header() {
    Column() {
      Row() {
        Button('< 返回', { type: ButtonType.Normal })
          .fontSize(16)
          .fontColor('#1152D4')
          .backgroundColor('rgba(0,0,0,0)')
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
      .backgroundColor('#FFFFFF')

      Divider()
        .strokeWidth(1)
        .color('#E5E5EA')
    }
  }

  @Builder
  private LoadingSection() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#1152D4')

      Text('加载中…')
        .fontSize(14)
        .fontColor('#6B7280')
        .margin({ top: 12 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private ErrorSection() {
    Column({ space: 12 }) {
      Text(this.loadError || '获取数据失败')
        .fontSize(15)
        .fontColor('#FF3B30')
        .textAlign(TextAlign.Center)
        .margin({ left: 24, right: 24 })

      Button('重新加载', { type: ButtonType.Capsule })
        .backgroundColor('#1152D4')
        .fontColor('#FFFFFF')
        .onClick(() => this.loadLogs())
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private EmptySection() {
    Column({ space: 8 }) {
      Text('暂无车辆操作记录')
        .fontSize(16)
        .fontColor('#111827')

      Text('车辆控制操作将在此处展示，稍后再来看看吧！')
        .fontSize(13)
        .fontColor('#6B7280')
        .textAlign(TextAlign.Center)
        .margin({ left: 32, right: 32 })

      Button('刷新', { type: ButtonType.Capsule })
        .backgroundColor('#1152D4')
        .fontColor('#FFFFFF')
        .onClick(() => this.loadLogs(true))
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  private LogList() {
    List({ space: 12 }) {
      ForEach(this.logs, (item: CarOperationLogViewItem) => {
        this.LogListItem(item);
      }, (item: CarOperationLogViewItem) => item.key)

      if (this.refreshing) {
        ListItem() {
          LoadingProgress()
            .width(32)
            .height(32)
            .color('#1152D4')
            .margin({ top: 16, bottom: 24 })
        }
        .backgroundColor('rgba(0,0,0,0)')
      }
    }
    .padding({ left: 12, right: 12, top: 16, bottom: 32 })
  }

  @Builder
  private LogListItem(item: CarOperationLogViewItem) {
    ListItem() {
      Column({ space: 8 }) {
        Row({ space: 8 }) {
          Text(item.operaType ?? '未知操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#111827')

          if (item.createTime) {
            Text(item.createTime)
              .fontSize(12)
              .fontColor('#6B7280')
          }
        }

        Text(item.operaContent ?? '暂无描述')
          .fontSize(13)
          .fontColor('#374151')

        Text(`操作人：${item.userName ?? '未知'} | 车辆：${item.carName ?? '--'}`)
          .fontSize(12)
          .fontColor('#6B7280')

        Row() {
          Blank()
            .layoutWeight(1)

          Button(this.deletingId === item.id ? '删除中…' : '删除', { type: ButtonType.Capsule })
            .fontSize(13)
            .fontColor('#FFFFFF')
            .backgroundColor('#FF3B30')
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .enabled(this.deletingId !== item.id)
            .onClick(() => {
              this.confirmDelete(item);
            })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ radius: 12, color: '#1A000000', offsetX: 0, offsetY: 4 })
    }
    .width('100%')
    .backgroundColor('rgba(0,0,0,0)')
  }
}
