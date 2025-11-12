import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { clearToken, getToken } from '../../util/StorageUtil';
import { Context } from '@kit.AbilityKit';
import { HomeContentComp } from './HomeContentComp';

@Entry
@Component
struct MinePage {
  @State token: string = '';
  @State currentIndex: number = 0;

  async aboutToAppear() {
    const context = getContext(this) as Context;
    this.token = await getToken(context);
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
      Text('我的页面')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50, bottom: 30 })

      if (this.token) {
        Text(`Token: ${this.token.substring(0, 20)}...`)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 20 })

        Button('退出登录')
          .width('80%')
          .height(45)
          .borderRadius(10)
          .fontSize(16)
          .backgroundColor('#FF3B30')
          .onClick(() => {
            this.handleLogout();
          })
      } else {
        Text('当前未登录，请先登录账号')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 20 })
        Button('去登录')
          .width('80%')
          .height(45)
          .borderRadius(10)
          .fontSize(16)
          .backgroundColor('#0A59F7')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/lesson9/LoginPage_opt'
            });
          })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F5F5F5')
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
        HomeContentComp()
      }.tabBar(this.tabNavBuilder('首页', 0, $r('app.media.shouye1'), $r('app.media.shouye2')))

      TabContent() {
        FeedbackListTab()
      }.tabBar(this.tabNavBuilder('反馈', 1, $r('app.media.renwu1'), $r('app.media.renwu2')))

      TabContent() {
        ResourceTab()
      }.tabBar(this.tabNavBuilder('资源', 2, $r('app.media.ziyuan1'), $r('app.media.ziyuan2')))

      TabContent() {
        this.personalTab()
      }.tabBar(this.tabNavBuilder('我的', 3, $r('app.media.me1'), $r('app.media.me2')))
    }
    .onChange((index: number) => {
      this.currentIndex = index;
      const tabTitles: string[] = ['首页', '反馈', '资源', '我的'];
      promptAction.showToast({
        message: `已切换到${tabTitles[index]}`,
        duration: 800
      });
    })
    .backgroundColor('#F5F5F5')
    .barHeight(65)
    .width('100%')
    .height('100%')
  }
}

@Component
struct FeedbackListTab {
  build() {
    Column({ space: 20 }) {
      Text('反馈中心')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })
      Text('您可以在此查看或提交反馈，功能开发中...')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ left: 20, right: 20 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#F5F5F5')
  }
}

@Component
struct ResourceTab {
  build() {
    Column({ space: 16 }) {
      Text('精选资源')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })
      Text('这里将展示最新的车型资讯与学习资料，敬请期待。')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ left: 20, right: 20 })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#F5F5F5')
  }
}
