import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { bindCarVinRequest } from '../../util/HttpUtil';
import { getToken } from '../../util/StorageUtil';
import { Context } from '@kit.AbilityKit';

/**
 * 车辆绑定页面
 * 用户输入9位车架号并绑定
 */
@Entry
@Component
struct VehicleBindPage {
  @State carVin: string = '';
  @State isLoading: boolean = false;

  build() {
    Stack() {
      Image($r('app.media.login2_lsl613'))
        .width('100%')
        .height('100%')

      Column() {
        Column() {
          // 空列，用于占位
        }
        .width('100%')
        .height(200)

        Column({ space: 10 }) {
          TextInput({ text: this.carVin, placeholder: '请输入车架号（9位）' })
            .backgroundColor(Color.White)
            .width('90%')
            .height(45)
            .borderRadius(10)
            .type(InputType.Normal)
            .opacity(0.7)
            .padding(10)
            .enabled(!this.isLoading)
            .maxLength(9)
            .onChange((val) => {
              // 只允许输入字母和数字
              this.carVin = val.replace(/[^A-Za-z0-9]/g, '');
            })

          Text('请输入9位车架号（字母+数字）')
            .fontSize(12)
            .fontColor(Color.White)
            .opacity(0.8)
            .width('90%')
        }
        .width('100%')
        .height(200)
        .margin({ top: 210 })
        .alignItems(HorizontalAlign.Center)

        Column({ space: 10 }) {
          Button('进入')
            .width('90%')
            .height(45)
            .borderRadius(10)
            .fontSize(16)
            .opacity(0.8)
            .backgroundColor('#0A59F7')
            .enabled(!this.isLoading && this.carVin.length === 9)
            .onClick(() => {
              this.handleBind();
            })

          Button('返回')
            .width('90%')
            .height(45)
            .borderRadius(10)
            .fontSize(16)
            .opacity(0.8)
            .backgroundColor('#6C757D')
            .enabled(!this.isLoading)
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .height(200)
        .margin({ top: -100 })
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 加载提示
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color(Color.White)
          Text('绑定中...')
            .fontSize(16)
            .fontColor(Color.White)
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('rgba(0,0,0,0.5)')
      }
    }
    .width('100%')
    .height('100%')
  }

  private async handleBind() {
    // 验证输入
    if (!this.carVin || this.carVin.length !== 9) {
      promptAction.openToast({
        message: '请输入9位车架号',
        duration: 2000
      });
      return;
    }

    // 验证格式：必须是字母和数字组合
    const vinPattern = /^[A-Za-z0-9]{9}$/;
    if (!vinPattern.test(this.carVin)) {
      promptAction.openToast({
        message: '车架号格式错误，请输入9位字母和数字',
        duration: 2000
      });
      return;
    }

    // 显示加载提示
    this.isLoading = true;

    try {
      // 获取token
      const context = getContext(this) as Context;
      const token = await getToken(context);
      
      if (!token || token.length === 0) {
        promptAction.openToast({
          message: '未登录，请先登录',
          duration: 2000
        });
        router.replaceUrl({
          url: 'pages/lesson9/LoginPage_opt'
        });
        return;
      }

      // 发起绑定请求
      const response = await bindCarVinRequest(token, this.carVin);

      // 处理响应结果
      if (response.code === 200) {
        // 绑定成功
        promptAction.openToast({
          message: '绑定成功',
          duration: 2000
        });

        // 延迟跳转，让用户看到成功提示
        setTimeout(() => {
          router.replaceUrl({
            url: 'pages/lesson9/HomePage'
          });
        }, 500);
      } else {
        // 绑定失败，显示错误信息
        const errorMsg = response.msg || '绑定失败，请重试';
        promptAction.openToast({
          message: `绑定失败：${errorMsg}`,
          duration: 3000
        });
      }
    } catch (err) {
      // 网络异常处理
      console.error(`绑定异常: ${JSON.stringify(err)}`);
      let errorMessage = '网络连接失败，请检查网络';
      
      // 检查错误对象是否有 message 属性
      if (err && typeof err === 'object') {
        const errorObj = err as Record<string, Object>;
        if (errorObj.message && typeof errorObj.message === 'string') {
          errorMessage = errorObj.message as string;
        }
      }

      promptAction.openToast({
        message: `绑定失败：${errorMessage}`,
        duration: 3000
      });
    } finally {
      // 隐藏加载提示
      this.isLoading = false;
    }
  }
}
