import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';
import { getToken } from '../../util/StorageUtil';
import {
  controlBackRequest,
  controlDoorRequest,
  ControlDoorPayload,
  controlLeftRequest,
  controlLightRequest,
  ControlLightPayload,
  controlMoveRequest,
  controlRightRequest,
  controlStopRequest,
  getUserInfoRequest
} from '../../util/HttpUtil';
import { UserInfoResponse } from '../../model/UserInfo';
import { CommonResponse } from '../../model/CommonResponse';

interface BasicTouchEvent {
  type: number;
}

interface CarControlErrorObject {
  message?: string;
}

declare function getContext(component: Object): Context;

type CarControlError = Error | CarControlErrorObject | string;

@Component
export struct CarControlPage {
  @State doorState: boolean = false;
  @State lightState: boolean = false;
  @State currentDirection: string = '';
  private carId: string | undefined = undefined;
  private isDoorUpdating: boolean = false;
  private isLightUpdating: boolean = false;
  private isDirectionUpdating: boolean = false;

  build() {
    Column() {
      Column() {
        Image(this.getCarImage())
          .width('100%')
          .height(280)
          .objectFit(ImageFit.Contain)
          .margin({ bottom: 12 });

        Text(`车门:${this.doorState ? '开' : '关'}, 车灯:${this.lightState ? '开' : '关'}`)
          .fontSize(15)
          .fontColor('#333333');
      }
      .width('100%')
      .padding({ top: 12, bottom: 20, left: 12, right: 12 })
      .alignItems(HorizontalAlign.Center);

      Column({ space: 16 }) {
        Row({ space: 60 }) {
          Column() {
            Image(this.lightState ? $r('app.media.carh_k') : $r('app.media.carh_g'))
              .width(30)
              .height(30)
              .objectFit(ImageFit.Contain);

            Text(this.lightState ? '车灯开' : '车灯关')
              .fontSize(10)
              .fontColor(this.lightState ? '#4A90E2' : '#333333')
              .margin({ top: 4 });
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .width(72)
          .height(72)
          .padding(6)
          .backgroundColor(this.lightState ? '#E6F7FF' : '#EEEEEE')
          .borderRadius(10)
          .border({ width: 2, color: this.lightState ? '#4A90E2' : '#EEEEEE' })
          .onClick(() => {
            this.toggleLightState();
          });

          Text('方向控制')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#000000');

          Column() {
            Image(this.doorState ? $r('app.media.card_k') : $r('app.media.card_g'))
              .width(30)
              .height(30)
              .objectFit(ImageFit.Contain);

            Text(this.doorState ? '车门开' : '车门关')
              .fontSize(10)
              .fontColor(this.doorState ? '#4A90E2' : '#333333')
              .margin({ top: 4 });
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .width(72)
          .height(72)
          .padding(6)
          .backgroundColor(this.doorState ? '#E6F7FF' : '#EEEEEE')
          .borderRadius(10)
          .border({ width: 2, color: this.doorState ? '#4A90E2' : '#EEEEEE' })
          .onClick(() => {
            this.toggleDoorState();
          });
        }
        .margin({ left: -1 })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center);

        Column({ space: 12 }) {
          Stack({ alignContent: Alignment.Center }) {
            Image($r('app.media.dir_k'))
              .width(180)
              .height(180)
              .objectFit(ImageFit.Contain);

            Image($r('app.media.dir_s'))
              .width(180)
              .height(180)
              .objectFit(ImageFit.Contain)
              .opacity(this.currentDirection === 'up' ? 1 : 0);

            Image($r('app.media.dir_x'))
              .width(180)
              .height(180)
              .objectFit(ImageFit.Contain)
              .opacity(this.currentDirection === 'down' ? 1 : 0);

            Image($r('app.media.dir_z'))
              .width(180)
              .height(180)
              .objectFit(ImageFit.Contain)
              .opacity(this.currentDirection === 'left' ? 1 : 0);

            Image($r('app.media.dir_y'))
              .width(180)
              .height(180)
              .objectFit(ImageFit.Contain)
              .opacity(this.currentDirection === 'right' ? 1 : 0);

            Rect()
              .width(60)
              .height(60)
              .position({ x: 60, y: 10 })
              .fill('rgba(0,0,0,0)')
              .onTouch((event: BasicTouchEvent) => this.handleDirectionTouch(event, 'up'));

            Rect()
              .width(60)
              .height(60)
              .position({ x: 60, y: 110 })
              .fill('rgba(0,0,0,0)')
              .onTouch((event: BasicTouchEvent) => this.handleDirectionTouch(event, 'down'));

            Rect()
              .width(60)
              .height(60)
              .position({ x: 10, y: 60 })
              .fill('rgba(0,0,0,0)')
              .onTouch((event: BasicTouchEvent) => this.handleDirectionTouch(event, 'left'));

            Rect()
              .width(60)
              .height(60)
              .position({ x: 110, y: 60 })
              .fill('rgba(0,0,0,0)')
              .onTouch((event: BasicTouchEvent) => this.handleDirectionTouch(event, 'right'));
          }
          .width(200)
          .height(200)
          .alignSelf(ItemAlign.Center);

          Column() {
            Text('前进')
              .fontSize(12)
              .fontColor(this.currentDirection === 'up' ? '#4A90E2' : '#666666')
              .margin({ bottom: 6 });

            Row({ space: 100 }) {
              Text('左转')
                .fontSize(12)
                .fontColor(this.currentDirection === 'left' ? '#4A90E2' : '#666666');

              Text('右转')
                .fontSize(12)
                .fontColor(this.currentDirection === 'right' ? '#4A90E2' : '#666666');
            }
            .margin({ bottom: 6 });

            Text('后退')
              .fontSize(12)
              .fontColor(this.currentDirection === 'down' ? '#4A90E2' : '#666666');
          }
          .alignItems(HorizontalAlign.Center);
        }
        .margin({ top: -50 })
      }
      .width('100%')
      .margin({ top: 12, bottom: 16 })
      .alignItems(HorizontalAlign.Center)
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(15)
      .shadow({ radius: 6, color: '#1A000000', offsetX: 2, offsetY: 2 });
    }
    .width('100%')
    .height('100%')
    .padding({ top: 4, bottom: 12, left: 12, right: 12 })
    .backgroundColor('#F5F5F5');
  }

  private getCarImage(): Resource {
    if (this.doorState && this.lightState) {
      return $r('app.media.car_k_k');
    } else if (this.doorState && !this.lightState) {
      return $r('app.media.car_k_g');
    } else if (!this.doorState && this.lightState) {
      return $r('app.media.car_g_k');
    } else {
      return $r('app.media.car_g_g');
    }
  }

  private async ensureCarId(): Promise<string> {
    if (this.carId) {
      return this.carId;
    }

    const context = getContext(this) as Context;
    const token = await getToken(context);
    if (!token) {
      throw new Error('请先登录后操作车辆控制');
    }

    const response = await getUserInfoRequest(token);
    if (!response || response.code !== 200) {
      throw new Error(response?.msg ?? '获取用户信息失败');
    }

    const resolvedId = this.resolveCarId(response);
    if (!resolvedId) {
      throw new Error('未绑定车辆，请先绑定车辆');
    }

    this.carId = resolvedId;
    return resolvedId;
  }

  private resolveCarId(response: UserInfoResponse): string | undefined {
    if (response.carId !== undefined && response.carId !== null) {
      return this.sanitizeCarId(response.carId);
    }

    const user = response.user;
    if (user && user.carId !== undefined && user.carId !== null) {
      return this.sanitizeCarId(user.carId);
    }

    return undefined;
  }

  private sanitizeCarId(carIdValue: string | number | undefined): string | undefined {
    if (carIdValue === undefined || carIdValue === null) {
      return undefined;
    }

    const text = String(carIdValue).trim();
    if (!text || text === 'null' || text === 'undefined') {
      return undefined;
    }

    return text;
  }

  private async toggleLightState(): Promise<void> {
    if (this.isLightUpdating) {
      return;
    }

    const previousState = this.lightState;
    this.lightState = !this.lightState;

    try {
      this.isLightUpdating = true;
      const context = getContext(this) as Context;
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后操作车灯');
      }

      const carId = await this.ensureCarId();
      const payload: ControlLightPayload = {
        carId: carId,
        light: this.lightState ? '1' : '0'
      };
      const response = await controlLightRequest(token, payload);
      if (response.code !== 200) {
        throw new Error(response.msg ?? '车灯操作失败');
      }
      promptAction.showToast({ message: this.lightState ? '车灯已开启' : '车灯已关闭', duration: 1500 });
    } catch (error) {
      console.error(`[CarControl] Light toggle failed -> ${JSON.stringify(error)}`);
      this.lightState = previousState;
      const message = this.resolveErrorMessage(error as CarControlError, '车灯操作失败');
      promptAction.showToast({ message, duration: 2000 });
    } finally {
      this.isLightUpdating = false;
    }
  }

  private async toggleDoorState(): Promise<void> {
    if (this.isDoorUpdating) {
      return;
    }

    const previousState = this.doorState;
    this.doorState = !this.doorState;

    try {
      this.isDoorUpdating = true;
      const context = getContext(this) as Context;
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后操作车门');
      }

      const carId = await this.ensureCarId();
      const payload: ControlDoorPayload = {
        carId: carId,
        door: this.doorState ? '1' : '0'
      };
      const response = await controlDoorRequest(token, payload);
      if (response.code !== 200) {
        throw new Error(response.msg ?? '车门操作失败');
      }
      promptAction.showToast({ message: this.doorState ? '车门已开启' : '车门已关闭', duration: 1500 });
    } catch (error) {
      console.error(`[CarControl] Door toggle failed -> ${JSON.stringify(error)}`);
      this.doorState = previousState;
      const message = this.resolveErrorMessage(error as CarControlError, '车门操作失败');
      promptAction.showToast({ message, duration: 2000 });
    } finally {
      this.isDoorUpdating = false;
    }
  }

  private resolveErrorMessage(error: CarControlError, fallback: string): string {
    if (typeof error === 'string') {
      return error;
    }

    if (error instanceof Error) {
      return error.message || fallback;
    }

    if (error && typeof error.message === 'string') {
      return error.message;
    }

    return fallback;
  }

  private async handleDirectionTouch(event: BasicTouchEvent, direction: string): Promise<void> {
    const eventType = event?.type;
    if (eventType === undefined) {
      return;
    }

    if (eventType === 0) { // Touch down
      void this.sendDirectionCommand(direction, true);
    } else if (eventType === 1 || eventType === 3) { // Touch up or cancel
      void this.sendDirectionCommand(direction, false);
    }
  }

  private async sendDirectionCommand(direction: string, isPress: boolean): Promise<void> {
    if (this.isDirectionUpdating) {
      return;
    }

    try {
      this.isDirectionUpdating = true;
      const context = getContext(this) as Context;
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后操作方向控制');
      }

      const carId = await this.ensureCarId();

      if (isPress) {
        this.currentDirection = direction;
        let response: CommonResponse | undefined;
        switch (direction) {
          case 'up':
            response = await controlMoveRequest(token, carId);
            break;
          case 'down':
            response = await controlBackRequest(token, carId);
            break;
          case 'left':
            response = await controlLeftRequest(token, carId);
            break;
          case 'right':
            response = await controlRightRequest(token, carId);
            break;
          default:
            response = undefined;
            break;
        }

        if (response && response.code !== 200) {
          throw new Error(response.msg ?? '方向操作失败');
        }
      } else {
        if (this.currentDirection === direction) {
          this.currentDirection = '';
        }
        const response = await controlStopRequest(token, carId);
        if (response.code !== 200) {
          throw new Error(response.msg ?? '车辆停止失败');
        }
      }
    } catch (error) {
      console.error(`[CarControl] Direction command failed -> ${JSON.stringify(error)}`);
      const message = this.resolveErrorMessage(error as CarControlError, '方向控制失败');
      promptAction.showToast({ message, duration: 2000 });
    } finally {
      this.isDirectionUpdating = false;
    }
  }
}
