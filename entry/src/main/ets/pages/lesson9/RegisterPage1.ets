import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { registerRequest } from '../../util/HttpUtil';
import { RegisterData } from '../../model/RegisterData';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State gender: string = 'male';
  @State isAgreed: boolean = false;
  @State isLoading: boolean = false;

  aboutToAppear() {
    // 接收从登录页面传递过来的数据
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
      // 全屏背景
      Image($r("app.media.login2_lsl613"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        // 顶部标题区域
        Column() {
          Text('    ')
            .fontSize(28)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          Text('    ')
            .fontSize(18)
            .fontColor(Color.White)
            .opacity(0.9)
        }
        .width('100%')
        .padding({ top: 60, left: 30, right: 30, bottom: 30 })
        .alignItems(HorizontalAlign.Start)

        // 表单内容区域
        Scroll() {
          Column({ space: 20 }) {
            // 账号输入
            Column() {
              Text('账号')
                .fontSize(16)
                .fontColor('#333333')
                .margin({ bottom: 8 })

              TextInput({ text: this.username, placeholder: '请输入账号' })
                .backgroundColor(Color.White)
                .width('100%')
                .height(50)
                .borderRadius(10)
                .padding(10)
                .enabled(!this.isLoading)
                .onChange((val) => {
                  this.username = val;
                })
            }

            // 密码输入
            Column() {
              Text('密码')
                .fontSize(16)
                .fontColor('#333333')
                .margin({ bottom: 8 })

              TextInput({ text: this.password, placeholder: '请输入密码' })
                .backgroundColor(Color.White)
                .width('100%')
                .height(50)
                .borderRadius(10)
                .type(InputType.Password)
                .padding(10)
                .enabled(!this.isLoading)
                .onChange((val) => {
                  this.password = val;
                })
            }

            // 确认密码
            Column() {
              Text('确认密码')
                .fontSize(16)
                .fontColor('#333333')
                .margin({ bottom: 8 })

              TextInput({ text: this.confirmPassword, placeholder: '请再次输入密码' })
                .backgroundColor(Color.White)
                .width('100%')
                .height(50)
                .borderRadius(10)
                .type(InputType.Password)
                .padding(10)
                .enabled(!this.isLoading)
                .onChange((val) => {
                  this.confirmPassword = val;
                })
            }

            // 性别选择
            Column() {
              Text('性别')
                .fontSize(16)
                .fontColor('#333333')
                .margin({ bottom: 8 })

              Row() {
                Radio({ value: 'male', group: 'genderGroup' })
                  .checked(this.gender === 'male')
                  .enabled(!this.isLoading)
                  .onChange((isChecked) => {
                    if (isChecked) {
                      this.gender = 'male';
                    }
                  })
                Text('男')
                  .fontSize(16)
                  .margin({ left: 8 })

                Radio({ value: 'female', group: 'genderGroup' })
                  .checked(this.gender === 'female')
                  .enabled(!this.isLoading)
                  .onChange((isChecked) => {
                    if (isChecked) {
                      this.gender = 'female';
                    }
                  })
                  .margin({ left: 20 })
                Text('女')
                  .fontSize(16)
                  .margin({ left: 8 })
              }
              .width('100%')
              .margin({ top: 5 })
            }

            // 协议同意
            Row() {
              Text(this.isAgreed ? '☑️' : '□')
                .fontSize(16)
                .margin({ right: 8 })
                .onClick(() => {
                  if (!this.isLoading) {
                    this.isAgreed = !this.isAgreed;
                  }
                })

              Text('同意《用户协议和隐私政策》')
                .fontSize(14)
                .fontColor('#0A59F7')
                .onClick(() => {
                  if (!this.isLoading) {
                    this.isAgreed = !this.isAgreed;
                  }
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .margin({ top: 10 })

            // 注册按钮
            Button('注册')
              .width('100%')
              .height(50)
              .borderRadius(25)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#0A59F7')
              .margin({ top: 20 })
              .enabled(!this.isLoading)
              .onClick(() => {
                this.handleRegister();
              })

            // 返回登录按钮
            Button('返回登录')
              .width('100%')
              .height(50)
              .borderRadius(25)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#6C757D')
              .enabled(!this.isLoading)
              .onClick(() => {
                router.back({
                  url: 'pages/lesson9/LoginPage_opt',
                  params: { username: this.username, password: this.password }
                });
              })

            // 已有账号链接
            Row() {
              Text('已有账号？')
                .fontSize(14)
                .fontColor(Color.White)
              Text('立即登录')
                .fontSize(14)
                .fontColor('#4CAF50')
                .fontWeight(FontWeight.Medium)
                .onClick(() => {
                  if (!this.isLoading) {
                    router.back({
                      url: 'pages/lesson9/LoginPage_opt',
                      params: { username: this.username, password: this.password }
                    });
                  }
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 15 })
          }
          .width('100%')
          .padding(30)
        }
        .width('100%')
        .height('70%')
        .backgroundColor('rgba(255,255,255,0.95)')
        .borderRadius(20)
        .margin({ top: 10 })
      }
      .width('100%')
      .height('100%')
      .opacity(0.7)

      // 加载提示
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color('#0A59F7')
          Text('注册中...')
            .fontSize(16)
            .fontColor('#333333')
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

  private async handleRegister() {
    // 验证输入
    if (!this.username) {
      promptAction.openToast({ message: '请输入账号', duration: 2000 });
      return;
    }
    if (!this.password) {
      promptAction.openToast({ message: '请输入密码', duration: 2000 });
      return;
    }
    if (this.password !== this.confirmPassword) {
      promptAction.openToast({ message: '两次输入的密码不一致', duration: 2000 });
      return;
    }
    if (!this.isAgreed) {
      promptAction.openToast({ message: '请同意用户协议', duration: 2000 });
      return;
    }

    // 显示加载提示
    this.isLoading = true;

    try {
      // 构建注册请求数据
      const registerData: RegisterData = {
        nickName: this.username, // 使用用户名作为昵称
        userName: this.username,
        phonenumber: '', // 如果需要，可以从UI获取
        sex: this.gender === 'male' ? '1' : '0', // 1-男, 0-女
        avatar: '',
        password: this.password,
        roleids: ['9'], // 默认角色ID
        birthDate: '2000-01-01', // 默认生日，如果需要可以从UI获取
        state: '1' // 默认状态为启用
      };

      // 发起注册请求
      const response = await registerRequest(registerData);

      // 处理响应结果
      if (response.code === 200) {
        // 注册成功
        promptAction.openToast({
          message: '注册成功',
          duration: 2000
        });

        // 延迟跳转，让用户看到成功提示
        setTimeout(() => {
          router.back({
            url: 'pages/lesson9/LoginPage_opt',
            params: { username: this.username, password: this.password }
          });
        }, 500);
      } else {
        // 注册失败，显示错误信息
        const errorMsg = response.msg || '注册失败，请重试';
        promptAction.openToast({
          message: `注册失败：${errorMsg}`,
          duration: 3000
        });
      }
    } catch (err) {
      // 网络异常处理
      console.error(`注册异常: ${JSON.stringify(err)}`);
      let errorMessage = '网络连接失败，请检查网络';
      
      // 检查错误对象是否有 message 属性（不使用 in 操作符）
      if (err && typeof err === 'object') {
        const errorObj = err as Record<string, Object>;
        if (errorObj.message && typeof errorObj.message === 'string') {
          errorMessage = errorObj.message as string;
        }
      }

      promptAction.openToast({
        message: `注册失败：${errorMessage}`,
        duration: 3000
      });
    } finally {
      // 隐藏加载提示
      this.isLoading = false;
    }
  }
}
