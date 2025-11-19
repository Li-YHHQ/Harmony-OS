import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';
import { getDarkMode } from '../../util/StorageUtil';
import { aiChatRequest, AIChatMessage } from '../../util/HttpUtil';

interface ChatMessage {
  id: string;
  sender: 'user' | 'ai';
  text: string;
  time: string;
}

@Entry
@Component
export struct AIAssistantPage {
  @State private messages: ChatMessage[] = [];
  @State private inputText: string = '';
  @State private isDarkMode: boolean = false;
  @State private isSending: boolean = false;

  async aboutToAppear() {
    const context = getContext(this) as Context;
    this.isDarkMode = await getDarkMode(context);
    const now = this.formatTime(new Date());
    this.messages = [
      {
        id: `ai-${Date.now()}`,
        sender: 'ai',
        text: '您好，我是车辆 AI 助手。您可以在下方输入有关车辆使用、故障现象或功能疑问，我会尽力为您解答。',
        time: now
      }
    ];
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button('< 返回', { type: ButtonType.Normal })
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('AI 助手')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(60)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(this.isDarkMode ? '#101622' : '#F5F5F5')

      // 对话内容区域
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.messages, (msg: ChatMessage) => {
            this.MessageBubble(msg);
          }, (msg: ChatMessage) => msg.id)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 4, bottom: 12 })
      }
      .layoutWeight(1)

      // 底部输入区
      Row() {
        TextInput({ placeholder: '请输入您要咨询的问题...', text: this.inputText })
          .layoutWeight(1)
          .height(40)
          .fontSize(14)
          .padding(10)
          .backgroundColor(this.isDarkMode ? '#0F172A' : '#FFFFFF')
          .borderRadius(20)
          .onChange((value: string) => {
            this.inputText = value;
          })

        Button(this.isSending ? '发送中…' : '发送', { type: ButtonType.Capsule })
          .margin({ left: 8 })
          .height(40)
          .fontSize(14)
          .backgroundColor('#0A59F7')
          .fontColor('#FFFFFF')
          .enabled(!this.isSending)
          .onClick(() => {
            this.handleSend();
          })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 8, bottom: 12 })
      .backgroundColor(this.isDarkMode ? '#020617' : '#F5F5F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? '#020617' : '#F5F5F5')
  }

  @Builder
  private MessageBubble(msg: ChatMessage) {
    Column({ space: 6 }) {
      // 角色名称，始终居中
      Text(msg.sender === 'user' ? '我' : 'AI 助手')
        .fontSize(11)
        .fontColor(this.isDarkMode ? '#9CA3AF' : '#888888')
        .width('100%')
        .textAlign(TextAlign.Center)

      // 头像 + 对话内容
      Row() {
        if (msg.sender === 'ai') {
          // AI 头像在左侧
          Image($r('app.media.AiUser'))
            .width(32)
            .height(32)
            .borderRadius(16)
            .objectFit(ImageFit.Cover)
            .margin({ right: 8 })

          // AI 对话气泡紧贴头像
          Text(msg.text)
            .fontSize(14)
            .fontColor(this.isDarkMode ? '#F9FAFB' : '#111827')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor(this.isDarkMode ? '#111827' : '#F3F4F6')
            .borderRadius(16)
            .width('70%')
        } else {
          // 用户消息在右侧
          Blank().layoutWeight(1)

          // 用户对话气泡紧贴头像，去掉蓝色背景
          Text(msg.text)
            .fontSize(14)
            .fontColor(this.isDarkMode ? '#F9FAFB' : '#111827')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor(this.isDarkMode ? '#111827' : '#F3F4F6')
            .borderRadius(16)
            .width('70%')
            .margin({ right: 8 })

          // 用户头像在最右侧
          Image($r('app.media.User'))
            .width(32)
            .height(32)
            .borderRadius(16)
            .objectFit(ImageFit.Cover)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      // 时间文本，始终居中
      Text(msg.time)
        .fontSize(10)
        .fontColor(this.isDarkMode ? '#6B7280' : '#999999')
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
  }

  private async handleSend() {
    const content = this.inputText.trim();
    if (!content) {
      promptAction.showToast({
        message: '请输入要咨询的问题',
        duration: 1500
      });
      return;
    }

    if (this.isSending) {
      promptAction.showToast({
        message: '正在向 AI 发起请求，请稍候…',
        duration: 1500
      });
      return;
    }

    const now = new Date();
    const timeText = this.formatTime(now);

    const userMsg: ChatMessage = {
      id: `user-${now.getTime()}`,
      sender: 'user',
      text: content,
      time: timeText
    };

    this.messages = [...this.messages, userMsg];
    this.inputText = '';
    this.isSending = true;

    try {
      const history: AIChatMessage[] = [];
      for (let index = 0; index < this.messages.length; index++) {
        const msg = this.messages[index];
        const item: AIChatMessage = {
          role: msg.sender === 'user' ? 'user' : 'assistant',
          content: msg.text
        };
        history.push(item);
      }

      const replyText = await aiChatRequest(history);

      const aiMsg: ChatMessage = {
        id: `ai-${Date.now()}`,
        sender: 'ai',
        text: replyText,
        time: this.formatTime(new Date())
      };

      this.messages = [...this.messages, aiMsg];
    } catch (error) {
      console.error(`AI 助手请求失败: ${JSON.stringify(error)}`);
      const message = (error && typeof error === 'object' && (error as Record<string, Object>).message)
        ? (error as Record<string, Object>).message as string
        : 'AI 服务暂不可用，请稍后重试';
      promptAction.showToast({
        message,
        duration: 2000
      });
    } finally {
      this.isSending = false;
    }
  }

  private formatTime(date: Date): string {
    const pad = (num: number): string => num < 10 ? `0${num}` : `${num}`;
    const h = pad(date.getHours());
    const m = pad(date.getMinutes());
    return `${h}:${m}`;
  }
}
