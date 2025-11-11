import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { loginRequest } from '../../util/HttpUtil';
import { saveToken } from '../../util/StorageUtil';
import { checkVehicleBindingAndNavigate } from '../../util/VehicleUtil';
import { Context } from '@kit.AbilityKit';

@Entry
@Component
struct LoginPage_opt {
  @State username: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;

  aboutToAppear() {
    // 接收从注册页面传递过来的数据
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      if (params.username) {
        this.username = params.username as string;
      }
      if (params.password) {
        this.password = params.password as string;
      }
    }
  }

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
          TextInput({ text: this.username, placeholder: '请输入账号信息' })
            .backgroundColor(Color.White)
            .width('90%')
            .height(45)
            .borderRadius(10)
            .type(InputType.Normal)
            .opacity(0.7)
            .padding(10)
            .enabled(!this.isLoading)
            .onChange((val) => {
              this.username = val;
            })

          TextInput({ text: this.password, placeholder: '请输入密码' })
            .backgroundColor(Color.White)
            .width('90%')
            .height(45)
            .borderRadius(10)
            .type(InputType.Password)
            .opacity(0.7)
            .padding(10)
            .enabled(!this.isLoading)
            .onChange((val) => {
              this.password = val;
            })

          Row() {
            Text('自动登录')
              .fontSize(14)
              .fontColor(Color.White)

            // 使用空白文本撑开
            Text('')
              .layoutWeight(1)

            Text('忘记密码')
              .fontSize(14)
              .fontColor(Color.White)
          }
          .width('90%')
          .margin({ top: 10, bottom: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .height(200)
        .margin({ top: 210 })
        .alignItems(HorizontalAlign.Center)

        Column({ space: 10 }) {
          Button('登录')
            .width('90%')
            .height(45)
            .borderRadius(10)
            .fontSize(16)
            .opacity(0.8)
            .backgroundColor('#0A59F7')
            .enabled(!this.isLoading)
            .onClick(() => {
              this.handleLogin();
            })

          // 修复注册按钮 - 确保它可见
          Button('注册')
            .width('90%')
            .height(45)
            .borderRadius(10)
            .fontSize(16)
            .opacity(0.8)
            .backgroundColor('#0A59F7')
            .fontColor(Color.White)
            .border({
              width: 1,
              color: Color.White
            })
            .enabled(!this.isLoading)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/lesson9/RegisterPage1',
                params: {
                  username: this.username,
                  password: this.password
                }
              });
            })
        }
        .width('100%')
        .height(200)
        .margin({ top: -50 })
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
          Text('登录中...')
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

  private async handleLogin() {
    // 验证输入
    if (!this.username || !this.password) {
      promptAction.openToast({
        message: '请输入账号和密码',
        duration: 2000
      });
      return;
    }

    // 显示加载提示
    this.isLoading = true;

    try {
      // 发起登录请求
      const response = await loginRequest(this.username, this.password);

      // 处理响应结果
      if (response.code === 200) {
        // 登录成功，保存token
        if (response.token) {
          const context = getContext(this) as Context;
          try {
            await saveToken(context, response.token);
          } catch (saveErr) {
            console.error(`保存token失败: ${JSON.stringify(saveErr)}`);
            // token保存失败不影响登录流程，只记录错误
          }
        }

        // 提示成功
        promptAction.openToast({
          message: '登录成功',
          duration: 2000
        });

        // 登录成功后，检查车辆绑定状态并跳转
        if (response.token) {
          await checkVehicleBindingAndNavigate(response.token);
        } else {
          // 如果没有token，跳转到登录页
          setTimeout(() => {
            router.replaceUrl({
              url: 'pages/lesson9/LoginPage_opt'
            });
          }, 500);
        }
      } else {
        // 登录失败，显示错误信息
        const errorMsg = response.msg || '登录失败，请重试';
        promptAction.openToast({
          message: `登录失败：${errorMsg}`,
          duration: 3000
        });
      }
    } catch (err) {
      // 网络异常处理
      console.error(`登录异常: ${JSON.stringify(err)}`);
      let errorMessage = '网络连接失败，请检查网络';
      
      // 检查错误对象是否有 message 属性（不使用 in 操作符）
      if (err && typeof err === 'object') {
        const errorObj = err as Record<string, Object>;
        if (errorObj.message && typeof errorObj.message === 'string') {
          errorMessage = errorObj.message as string;
        }
      }

      promptAction.openToast({
        message: `登录失败：${errorMessage}`,
        duration: 3000
      });
    } finally {
      // 隐藏加载提示
      this.isLoading = false;
    }
  }
}
