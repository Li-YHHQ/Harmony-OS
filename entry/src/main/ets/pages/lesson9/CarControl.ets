interface BasicTouchEvent {
  type: number;
}

@Component
export struct CarControlPage {
  @State doorState: boolean = false;
  @State lightState: boolean = false;
  @State currentDirection: string = '';

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

  private toggleLightState(): void {
    this.lightState = !this.lightState;
  }

  private toggleDoorState(): void {
    this.doorState = !this.doorState;
  }

  private handleDirectionTouch(event: BasicTouchEvent, direction: string): void {
    const eventType = event?.type;
    if (eventType === undefined) {
      return;
    }

    if (eventType === 0) { // Touch down
      this.currentDirection = direction;
    } else if (eventType === 1 || eventType === 3) { // Touch up or cancel
      if (this.currentDirection === direction) {
        this.currentDirection = '';
      }
    }
  }
}
