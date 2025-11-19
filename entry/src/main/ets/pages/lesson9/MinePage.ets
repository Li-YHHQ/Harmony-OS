import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { clearToken, getToken, getDarkMode, saveDarkMode } from '../../util/StorageUtil';
import { Context } from '@kit.AbilityKit';
import { HomeContentComp } from './HomeContentComp';
import { FeedbackListPage } from './FeedbackListPage';
import { CarInformationPage } from './CarInformation';
import { CarControlPage } from './CarControl';
import { getUserInfoRequest } from '../../util/HttpUtil';
import { UserInfoResponse, UserInfo } from '../../model/UserInfo';

@Entry
@Component
struct MinePage {
  @State token: string = '';
  @State currentIndex: number = 0;
  @State userName: string = '';
  @State isDarkMode: boolean = false;

  async aboutToAppear() {
    const context = getContext(this) as Context;
    this.token = await getToken(context);
    console.info(`[MinePage] current token = ${this.token}`);
    if (this.token && this.token.length > 0) {
      await this.loadUserName(this.token);
    }
    this.isDarkMode = await getDarkMode(context);
  }

  private async loadUserName(token: string) {
    try {
      const response: UserInfoResponse = await getUserInfoRequest(token);
      if (!response || response.code !== 200) {
        return;
      }

      const user: UserInfo | undefined = response.user;
      if (!user) {
        return;
      }

      const nickName = user.nickName ?? '';
      const userName = user.userName ?? '';
      const display = (nickName && nickName.length > 0) ? nickName : (userName && userName.length > 0 ? userName : '已登录用户');
      this.userName = display;
    } catch (err) {
      console.error(`加载用户信息失败: ${JSON.stringify(err)}`);
    }
  }

  @Builder
  tabNavBuilder(title: string, index: number, icon: Resource, activeIcon: Resource) {
    Column({ space: 5 }) {
      Image(this.currentIndex === index ? activeIcon : icon)
        .height(28)
        .width(28)
        .opacity(this.currentIndex === index ? 1 : 0.6)
      Text(title)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#FFA500' : '#666666')
    }
    .padding(10)
  }

  @Builder
  personalTab() {
    Column() {
      // 顶部标题
      Row() {
        Text('我的')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
      }
        .width('100%')
        .height(60)
        .padding({ left: 24, right: 24, top: 24 })
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)

      // 个人信息卡片
      Column() {
        Row() {
          // 头像
          Image($r('app.media.User'))
            .width(54)
            .height(54)
            .borderRadius(27)
            .objectFit(ImageFit.Cover)

          Column({ space: 4 }) {
            Text(this.token ? (this.userName || '已登录用户') : '未登录')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#222222')

            Text(this.token ? '点击下方功能进行车辆绑定或退出登录' : '请先登录后再进行车辆绑定操作')
              .fontSize(12)
              .fontColor('#888888')
              .maxLines(2)
          }
          .margin({ left: 12 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        if (this.token) {
          Text(`Token: ${this.token.substring(0, 20)}...`)
            .fontSize(11)
            .fontColor('#BBBBBB')
            .margin({ top: 10 })
        }
      }
      .width('90%')
      .padding({ top: 18, bottom: 18, left: 16, right: 16 })
      .margin({ top: 12, bottom: 24 })
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ radius: 8, color: '#14000000', offsetX: 0, offsetY: 4 })

      // 功能区域
      if (this.token) {
        Column({ space: 12 }) {
          // 深色模式切换
          Button(this.isDarkMode ? '切换为浅色模式' : '切换为深色模式')
            .width('90%')
            .height(44)
            .borderRadius(22)
            .fontSize(14)
            .backgroundColor(this.isDarkMode ? '#4B5563' : '#111827')
            .fontColor('#FFFFFF')
            .onClick(async () => {
              const context = getContext(this) as Context;
              this.isDarkMode = !this.isDarkMode;
              await saveDarkMode(context, this.isDarkMode);
              promptAction.showToast({
                message: this.isDarkMode ? '已开启深色模式' : '已关闭深色模式',
                duration: 1500
              });
            })

          // AI 助手
          Button('AI 助手')
            .width('90%')
            .height(44)
            .borderRadius(22)
            .fontSize(16)
            .backgroundColor('#22C55E')
            .fontColor('#FFFFFF')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/lesson9/AIAssistantPage'
              });
            })

          // 绑定车架号
          Button('绑定车架号')
            .width('90%')
            .height(44)
            .borderRadius(22)
            .fontSize(16)
            .backgroundColor('#0A59F7')
            .fontColor('#FFFFFF')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/lesson9/VehicleBindPage'
              });
            })

          // 退出登录
          Button('退出登录')
            .width('90%')
            .height(44)
            .borderRadius(22)
            .fontSize(16)
            .backgroundColor('#FF3B30')
            .fontColor('#FFFFFF')
            .onClick(() => {
              this.handleLogout();
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      } else {
        Column({ space: 16 }) {
          Text('当前未登录，请先登录账号')
            .fontSize(16)
            .fontColor('#666666')

          Button('去登录')
            .width('90%')
            .height(44)
            .borderRadius(22)
            .fontSize(16)
            .backgroundColor('#0A59F7')
            .fontColor('#FFFFFF')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/lesson9/LoginPage_opt'
              });
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 12 })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.isDarkMode ? '#101622' : '#F5F5F5')
  }

  private async handleLogout() {
    const context = getContext(this) as Context;
    try {
      await clearToken(context);
      this.token = '';
      promptAction.showToast({
        message: '已退出登录',
        duration: 2000
      });
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/lesson9/LoginPage_opt'
        });
      }, 500);
    } catch (err) {
      console.error(`退出登录失败: ${JSON.stringify(err)}`);
      promptAction.showToast({
        message: '退出登录失败，请重试',
        duration: 2000
      });
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        HomeContentComp({ isDarkMode: this.isDarkMode })
      }.tabBar(this.tabNavBuilder('首页', 0, $r('app.media.shouye1'), $r('app.media.shouye2')))

      TabContent() {
        CarInformationPage({ isDarkMode: this.isDarkMode })
      }.tabBar(this.tabNavBuilder('信息', 1, $r('app.media.me1'), $r('app.media.me2')))

      TabContent() {
        CarControlPage({ isDarkMode: this.isDarkMode })
      }.tabBar(this.tabNavBuilder('资源', 2, $r('app.media.ziyuan1'), $r('app.media.ziyuan2')))

      TabContent() {
        FeedbackListPage({ isDarkMode: this.isDarkMode })
      }.tabBar(this.tabNavBuilder('反馈', 3, $r('app.media.renwu1'), $r('app.media.renwu2')))

      TabContent() {
        this.personalTab()
      }.tabBar(this.tabNavBuilder('我的', 4, $r('app.media.me1'), $r('app.media.me2')))
    }
    .onChange((index: number) => {
      this.currentIndex = index;
      const tabTitles: string[] = ['首页', '信息', '资源', '反馈', '我的'];
      promptAction.showToast({
        message: `已切换到${tabTitles[index]}`,
        duration: 800
      });
    })
    .backgroundColor(this.isDarkMode ? '#020617' : '#F5F5F5')
    .barHeight(65)
    .width('100%')
    .height('100%')
  }
}
