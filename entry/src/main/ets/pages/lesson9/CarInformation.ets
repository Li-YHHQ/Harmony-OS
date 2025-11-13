import { promptAction } from '@kit.ArkUI';

interface ClimateOption {
  icon: Resource;
  label: string;
  mode: string;
}

@Entry
@Component
export struct CarInformationPage {
  @State isDarkMode: boolean = true;
  @State batteryLevel: number = 88;
  @State range: number = 488;
  @State climateEnabled: boolean = true;
  @State temperature: number = 22;
  @State selectedClimateMode: string = 'cooling';

  private readonly climateOptions: ClimateOption[] = [
    { icon: $r('app.media.air'), label: 'Cooling', mode: 'cooling' },
    { icon: $r('app.media.sync'), label: 'Circulate', mode: 'circulate' },
    { icon: $r('app.media.ac_unit'), label: 'A/C On', mode: 'ac' },
    { icon: $r('app.media.airwave'), label: 'Defog', mode: 'defog' }
  ];

  build() {
    Column() {
      Scroll() {
        Column({ space: 24 }) {
          this.Header();
          this.VehicleInfo();
          this.VehicleImage();
          this.ClimateControlPanel();
        }
        .width('100%')
        .padding({ bottom: 32 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? '#101622' : '#F6F6F8')
    .padding(16)
  }

  @Builder
  Header() {
    Row() {
      Column({ space: 4 }) {
        Text('AUDI')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')

        Text('Last update: 3 sec ago')
          .fontSize(12)
          .fontColor('#8E8E93')
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Row({ space: 12 }) {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.more_horiz'))
            .width(20)
            .height(20)
            .fillColor(this.isDarkMode ? '#FFFFFF' : '#000000')
        }
        .width(40)
        .height(40)
        .backgroundColor(this.isDarkMode ? '#1C1C1E' : '#FFFFFF')
        .shadow({ radius: 2, color: '#1A000000', offsetX: 0, offsetY: 1 })

        Button(this.isDarkMode ? '浅色模式' : '深色模式', { type: ButtonType.Normal })
          .fontSize(12)
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(this.isDarkMode ? '#2C2C34' : '#E5E5EA')
          .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')
          .borderRadius(20)
          .onClick(() => {
            this.isDarkMode = !this.isDarkMode;
          })
      }
    }
    .width('100%')
    .padding({ bottom: 20 })
  }

  @Builder
  VehicleInfo() {
    Column({ space: 16 }) {
      Row() {
        Column({ space: 12 }) {
          Text('e-tron GT')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')

          Row({ space: 8 }) {
            Text(this.range.toString())
              .fontSize(48)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')

            Text('km')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor('#8E8E93')
              .margin({ bottom: 6 })
          }
          .alignItems(VerticalAlign.Bottom)
        }

        Blank()

        Column({ space: 8 }) {
          Row({ space: 6 }) {
            Image($r('app.media.bolt'))
              .width(42)
              .height(42)
              .fillColor('#1152D4')

            Text(`${this.batteryLevel}%`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')
          }

          Stack() {
            Row()
              .height(6)
              .width(120)
              .backgroundColor(this.isDarkMode ? '#1C1C1E' : '#E5E5EA')
              .borderRadius(6)

            Row()
              .height(6)
              .width(120 * (this.batteryLevel / 100))
              .backgroundColor('#1152D4')
              .borderRadius(6)
          }

          Text('Battery status')
            .fontSize(13)
            .fontColor('#8E8E93')
        }
        .alignItems(HorizontalAlign.End)
      }

      Text('Last updated: 1 hour ago')
        .fontSize(14)
        .fontColor('#8E8E93')
    }
    .width('100%')
    .padding({ bottom: 20 })
  }

  @Builder
  VehicleImage() {
    Image($r('app.media.audi_etron_gt'))
      .width('100%')
      .height(200)
      .objectFit(ImageFit.Contain)
      .borderRadius(16)
      .backgroundColor(this.isDarkMode ? '#0F172A' : '#FFFFFF')
      .margin({ bottom: 24 })
  }

  @Builder
  ClimateControlPanel() {
    Column({ space: 24 }) {
      Row() {
        Text('Climate Control')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')

        Blank()

        Toggle({ type: ToggleType.Switch, isOn: this.climateEnabled })
          .onChange((value: boolean) => {
            this.climateEnabled = value;
            promptAction.showToast({
              message: value ? '已开启空调' : '已关闭空调',
              duration: 1500
            });
          })
          .switchPointColor('#1152D4')
      }

      if (this.climateEnabled) {
        Row() {
          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.remove'))
              .width(24)
              .height(24)
              .fillColor(this.isDarkMode ? '#FFFFFF' : '#000000')
          }
          .width(56)
          .height(56)
          .backgroundColor(this.isDarkMode ? '#101622' : '#F6F6F8')
          .onClick(() => {
            if (this.temperature > 16) {
              this.temperature--;
            }
          })

          Column({ space: 8 }) {
            Row({ space: 4 }) {
              Text(this.temperature.toString())
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')

              Text('°C')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.isDarkMode ? '#FFFFFF' : '#000000')
            }

            Text('Temperature')
              .fontSize(14)
              .fontColor('#8E8E93')
              .textAlign(TextAlign.Center)
          }
          .margin({ left: 24, right: 24 })

          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.add'))
              .width(24)
              .height(24)
              .fillColor(this.isDarkMode ? '#FFFFFF' : '#000000')
          }
          .width(56)
          .height(56)
          .backgroundColor(this.isDarkMode ? '#101622' : '#F6F6F8')
          .onClick(() => {
            if (this.temperature < 30) {
              this.temperature++;
            }
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.climateOptions, (item: ClimateOption) => {
            this.ClimateButton(item);
          }, (item: ClimateOption) => item.mode)
        }
        .width('100%')
      } else {
        Column({ space: 8 }) {
          Text('Climate system is off')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#8E8E93')

          Text('Toggle the switch to adjust temperature and mode')
            .fontSize(12)
            .fontColor('#666666')
        }
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .alignItems(HorizontalAlign.Center)
      }

    }
    .width('100%')
    .backgroundColor(this.isDarkMode ? '#1C1C1E' : '#FFFFFF')
    .borderRadius(16)
    .padding(20)
    .shadow({ radius: 6, color: '#1A000000', offsetX: 0, offsetY: 2 })
  }

  @Builder
  ClimateButton(option: ClimateOption) {
    Button({ type: ButtonType.Normal }) {
      Column({ space: 6 }) {
        Image(option.icon)
          .width(24)
          .height(24)
          .fillColor(this.selectedClimateMode === option.mode ? '#1152D4' : (this.isDarkMode ? '#FFFFFF' : '#000000'))

        Text(option.label)
          .fontSize(14)
          .fontColor(this.selectedClimateMode === option.mode ? '#1152D4' : '#8E8E93')
      }
      .alignItems(HorizontalAlign.Center)
      .padding(12)
    }
    .backgroundColor(this.selectedClimateMode === option.mode
      ? (this.isDarkMode ? '#1E2A40' : '#E1E7FF')
      : (this.isDarkMode ? '#141B2A' : '#F0F2F6'))
    .borderRadius(12)
    .width('48%')
    .onClick(() => {
      this.selectedClimateMode = option.mode;
    })
  }
}
