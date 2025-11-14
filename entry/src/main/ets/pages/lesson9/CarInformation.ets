import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { Context } from '@kit.AbilityKit';
import { getToken } from '../../util/StorageUtil';
import { getVehicleInfoDetailRequest, VehicleInfoDetail, updateClimateStateRequest, ClimateStatePayload } from '../../util/HttpUtil';
import { getUserInfoRequest } from '../../util/HttpUtil';
import { UserInfoResponse, UserInfo } from '../../model/UserInfo';

interface UserVehicleInfoResult {
  carId?: string;
  carVin?: string;
  summaryName: string;
}

interface ClimatePreviousState {
  enabled: boolean;
  temperature: number;
  fanSpeedLevel: number;
  isCirculateOn: boolean;
  isAcOn: boolean;
  isDefogOn: boolean;
}

@Entry
@Component
export struct CarInformationPage {
  @State isDarkMode: boolean = false;
  @State batteryLevel: number = 88;
  @State range: number = 488;
  @State climateEnabled: boolean = false;
  @State temperature: number = 22;
  @State fanSpeedLevel: number = 3;
  @State isCirculateOn: boolean = false;
  @State isAcOn: boolean = false;
  @State isDefogOn: boolean = false;
  @State climateUpdating: boolean = false;
  @State loading: boolean = false;
  @State loadError: string = '';
  @State carInfo: VehicleInfoDetail | undefined = undefined;
  @State userInfoSummary: string = 'AUDI';
  private cachedCarVin: string = 'bart-111';
  private readonly minFanSpeedLevel: number = 1;
  private readonly maxFanSpeedLevel: number = 5;

  aboutToAppear() {
    this.fetchVehicleInfo();
  }

  private async fetchVehicleInfo() {
    if (this.loading) {
      return;
    }

    const context = getContext(this) as Context;
    this.loading = true;
    this.loadError = '';

    try {
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后查看车辆信息');
      }

      const userVehicleInfo = await this.fetchUserInfoAndCarId(token);
      const carId = userVehicleInfo.carId;
      if (userVehicleInfo.carVin && userVehicleInfo.carVin.length > 0) {
        this.cachedCarVin = userVehicleInfo.carVin;
      }
      this.userInfoSummary = 'AUDI';

      if (!carId) {
        throw new Error('未绑定车辆，请先完成车辆绑定');
      }

      console.info(`请求车辆信息详情: carId=${carId}`);
      const response = await getVehicleInfoDetailRequest(token, carId);
      if (response.code !== 200 || !response.data) {
        throw new Error(response.msg ?? '获取车辆详情失败');
      }

      console.info(`车辆信息详情响应: ${JSON.stringify(response.data)}`);
      this.carInfo = response.data;
      if (response.data.carVin && response.data.carVin.length > 0) {
        this.cachedCarVin = response.data.carVin;
      }
      this.applyVehicleInfo(response.data);
    } catch (error) {
      console.error(`加载车辆信息失败: ${JSON.stringify(error)}`);
      let message = '获取车辆信息失败';
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
    }
  }

  private async updateClimateState(autoValue: string, setTemperature?: number, previousState?: ClimatePreviousState) {
    if (this.climateUpdating) {
      return;
    }

    const context = getContext(this) as Context;
    this.climateUpdating = true;

    try {
      const token = await getToken(context);
      if (!token) {
        throw new Error('请先登录后操作空调');
      }

      const carVin = this.cachedCarVin || this.carInfo?.carVin || 'bart-111';
      if (!carVin) {
        throw new Error('未获取到车辆信息，稍后重试');
      }

      const payload = this.buildClimatePayload(autoValue, setTemperature, carVin);
      console.info(`[Climate][Request] updateClimateState -> payload=${JSON.stringify(payload)}`);
      const response = await updateClimateStateRequest(token, payload);
      console.info(`[Climate][Response] updateClimateState -> code=${response.code}, msg=${response.msg ?? ''}`);
      if (response.code !== 200) {
        throw new Error(response.msg ?? '更新空调状态失败');
      }

      promptAction.showToast({ message: '空调状态已更新', duration: 1500 });
    } catch (error) {
      console.error(`[Climate][Error] updateClimateState failed -> ${JSON.stringify(error)}`);
      let message = '更新空调状态失败';
      if (error && typeof error === 'object') {
        const errObj = error as Record<string, Object>;
        if (errObj.message && typeof errObj.message === 'string') {
          message = errObj.message as string;
        }
      }
      promptAction.showToast({ message, duration: 2000 });
      if (previousState) {
        this.climateEnabled = previousState.enabled;
        this.temperature = previousState.temperature;
        this.fanSpeedLevel = previousState.fanSpeedLevel;
        this.isCirculateOn = previousState.isCirculateOn;
        this.isAcOn = previousState.isAcOn;
        this.isDefogOn = previousState.isDefogOn;
      } else {
        this.climateEnabled = autoValue === '1';
        if (setTemperature !== undefined) {
          this.temperature = setTemperature;
        }
        if (autoValue === '0') {
          this.isAcOn = false;
          this.isCirculateOn = false;
          this.isDefogOn = false;
        }
      }
    } finally {
      console.info('[Climate][Request] updateClimateState finished');
      this.climateUpdating = false;
    }
  }

  private buildClimatePayload(autoValue: string, tempOverride: number | undefined, carVin: string): ClimateStatePayload {
    const temp = tempOverride !== undefined ? tempOverride : this.temperature;
    return {
      auto: autoValue,
      door: '0',
      light: '0',
      temperature: temp.toString(),
      windLevel: this.fanSpeedLevel.toString(),
      circulate: this.isCirculateOn ? '1' : '0',
      setTemp: temp.toString(),
      acBtn: this.isAcOn ? '1' : '0',
      clearFog: this.isDefogOn ? '1' : '0',
      fanState: `fan_speed_${this.fanSpeedLevel}`,
      playMode: '0',
      processMp3: '0',
      mp3Playing: '0',
      processMp4: '0',
      mp4Playing: '0',
      carVin: carVin
    };
  }

  private getCurrentClimateState(): ClimatePreviousState {
    return {
      enabled: this.climateEnabled,
      temperature: this.temperature,
      fanSpeedLevel: this.fanSpeedLevel,
      isCirculateOn: this.isCirculateOn,
      isAcOn: this.isAcOn,
      isDefogOn: this.isDefogOn
    };
  }

  private applyVehicleInfo(info: VehicleInfoDetail) {
    if (info.batteryPower) {
      const parsed = Number(info.batteryPower);
      if (!Number.isNaN(parsed)) {
        this.batteryLevel = Math.min(Math.max(parsed, 0), 100);
      }
    }

    if (info.enduranceMileage) {
      const parsed = Number(info.enduranceMileage);
      if (!Number.isNaN(parsed)) {
        this.range = parsed;
      }
    }

    if (info.carVin && info.carVin.length > 0) {
      this.cachedCarVin = info.carVin;
    }
  }

  private async fetchUserInfoAndCarId(token: string): Promise<UserVehicleInfoResult> {
    try {
      const userInfoResponse = await getUserInfoRequest(token);
      console.info(`用户信息原始响应: ${JSON.stringify(userInfoResponse)}`);
      if (userInfoResponse.code !== 200) {
        throw new Error(userInfoResponse.msg ?? '获取用户信息失败');
      }

      const user = userInfoResponse.user;
      const carId = this.resolveCarId(userInfoResponse);
      const summaryName = this.resolveUserDisplayName(user);
      const carVin = typeof userInfoResponse.carVin === 'string' && userInfoResponse.carVin.length > 0
        ? userInfoResponse.carVin
        : undefined;
      console.info(`用户信息解析结果 carId=${carId}, summaryName=${summaryName}`);
      const result: UserVehicleInfoResult = {
        carId,
        carVin,
        summaryName
      };
      return result;
    } catch (error) {
      console.error(`获取用户信息失败: ${JSON.stringify(error)}`);
      let message = '获取用户信息失败';
      if (error && typeof error === 'object') {
        const errObj = error as Record<string, Object>;
        if (errObj.message && typeof errObj.message === 'string') {
          message = errObj.message as string;
        }
      }
      throw new Error(message);
    }
  }

  private resolveCarId(response: UserInfoResponse): string | undefined {
    if (response.carId !== undefined && response.carId !== null) {
      return this.sanitizeCarId(response.carId);
    }

    const user = response.user;
    if (user) {
      if (user.carId !== undefined && user.carId !== null) {
        return this.sanitizeCarId(user.carId);
      }
    }

    if (response.carVin !== undefined && response.carVin !== null) {
      return this.sanitizeCarId(response.carVin);
    }

    return undefined;
  }

  private resolveUserDisplayName(user?: UserInfo): string {
    if (!user) {
      return '我的车辆';
    }

    if (user.nickName && user.nickName.length > 0) {
      return user.nickName;
    }

    if (user.userName && user.userName.length > 0) {
      return user.userName;
    }

    if (user.phonenumber && user.phonenumber.length > 0) {
      return user.phonenumber;
    }

    return '我的车辆';
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
        Text(this.userInfoSummary)
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
        .onClick(() => {
          router.pushUrl({
            url: 'pages/lesson9/CarUserInformation'
          });
        })

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
    if (this.loading) {
      this.LoadingSection(200, false);
    } else if (this.loadError) {
      this.ErrorSection(200, false);
    } else {
      Column({ space: 16 }) {
        Row({ space: 45 }) {
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

          Column({ space: 16 }) {
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

        Text(this.carInfo?.updateTime ? `Last updated: ${this.carInfo?.updateTime}` : 'Last updated: --')
          .fontSize(14)
          .fontColor('#8E8E93')
      }
      .width('100%')
      .padding({ bottom: 20 })
    }
  }

  @Builder
  VehicleImage() {
    if (this.loading) {
      this.LoadingSection(200, true);
    } else if (this.loadError) {
      this.ErrorSection(200, true);
    } else {
      Image($r('app.media.audi_etron_gt'))
        .width('100%')
        .height(200)
        .objectFit(ImageFit.Contain)
        .borderRadius(16)
        .backgroundColor(this.isDarkMode ? '#0F172A' : '#FFFFFF')
        .margin({ bottom: 24 })
    }
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
          .onChange(async (value: boolean) => {
            const previousState = this.getCurrentClimateState();
            if (this.climateUpdating) {
              this.climateEnabled = previousState.enabled;
              return;
            }
            console.info(`[Climate] Switch toggled -> value=${value}, previous=${previousState.enabled}`);
            this.climateEnabled = value;
            await this.updateClimateState(value ? '1' : '0', undefined, previousState);
            if (this.climateEnabled !== value && !this.climateUpdating) {
              this.climateEnabled = previousState.enabled;
            }
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
            if (this.climateUpdating) {
              return;
            }
            if (this.temperature > 16) {
              const previousState = this.getCurrentClimateState();
              const newTemp = this.temperature - 1;
              console.info(`[Climate] Temperature down -> from=${this.temperature} to=${newTemp}`);
              this.temperature = newTemp;
              void this.updateClimateState(this.climateEnabled ? '1' : '0', newTemp, previousState);
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
            if (this.climateUpdating) {
              return;
            }
            if (this.temperature < 30) {
              const previousState = this.getCurrentClimateState();
              const newTemp = this.temperature + 1;
              console.info(`[Climate] Temperature up -> from=${this.temperature} to=${newTemp}`);
              this.temperature = newTemp;
              void this.updateClimateState(this.climateEnabled ? '1' : '0', newTemp, previousState);
            }
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
          this.FanSpeedButton();
          this.ClimateToggleButton('circulate', 'Circulate', $r('app.media.sync'));
          this.ClimateToggleButton('ac', 'A/C On', $r('app.media.ac_unit'));
          this.ClimateToggleButton('defog', 'Defog', $r('app.media.airwave'));
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
  private FanSpeedButton() {
    Button({ type: ButtonType.Normal }) {
      Column({ space: 6 }) {
        Image($r('app.media.air'))
          .width(24)
          .height(24)
          .fillColor(this.climateEnabled ? '#1152D4' : (this.isDarkMode ? '#FFFFFF' : '#000000'))

        Text('Fan Speed')
          .fontSize(14)
          .fontColor(this.climateEnabled ? '#1152D4' : '#8E8E93')

        Text('Level ' + this.fanSpeedLevel.toString())
          .fontSize(12)
          .fontColor('#6B7280')
      }
      .alignItems(HorizontalAlign.Center)
      .padding(12)
    }
    .backgroundColor(this.climateEnabled ? (this.isDarkMode ? '#1E2A40' : '#E1E7FF') : (this.isDarkMode ? '#141B2A' : '#F0F2F6'))
    .borderRadius(12)
    .width('48%')
    .onClick(() => {
      console.info('[Climate] Fan speed button tapped');
      this.handleFanSpeedChange();
    })
  }

  @Builder
  private ClimateToggleButton(mode: 'circulate' | 'ac' | 'defog', label: string, icon: Resource) {
    Button({ type: ButtonType.Normal }) {
      Column({ space: 6 }) {
        Image(icon)
          .width(24)
          .height(24)
          .fillColor(this.isClimateModeActive(mode) ? '#1152D4' : (this.isDarkMode ? '#FFFFFF' : '#000000'))

        Text(label)
          .fontSize(14)
          .fontColor(this.isClimateModeActive(mode) ? '#1152D4' : '#8E8E93')
      }
      .alignItems(HorizontalAlign.Center)
      .padding(12)
    }
    .backgroundColor(this.isClimateModeActive(mode) ? (this.isDarkMode ? '#1E2A40' : '#E1E7FF') : (this.isDarkMode ? '#141B2A' : '#F0F2F6'))
    .borderRadius(12)
    .width('48%')
    .onClick(() => {
      console.info(`[Climate] Mode button tapped -> mode=${mode}`);
      this.handleClimateToggle(mode);
    })
  }

  private isClimateModeActive(mode: 'circulate' | 'ac' | 'defog'): boolean {
    switch (mode) {
      case 'circulate':
        return this.isCirculateOn;
      case 'ac':
        return this.isAcOn;
      case 'defog':
        return this.isDefogOn;
      default:
        return false;
    }
  }

  private handleFanSpeedChange(): void {
    if (!this.climateEnabled) {
      promptAction.showToast({ message: '请先开启空调', duration: 1500 });
      return;
    }
    if (this.climateUpdating) {
      return;
    }

    const previousState = this.getCurrentClimateState();
    let nextLevel = this.fanSpeedLevel + 1;
    if (nextLevel > this.maxFanSpeedLevel) {
      nextLevel = this.minFanSpeedLevel;
    }
    console.info(`[Climate] Fan speed change -> from=${this.fanSpeedLevel} to=${nextLevel}`);
    this.fanSpeedLevel = nextLevel;
    void this.updateClimateState('1', undefined, previousState);
  }

  private handleClimateToggle(mode: 'circulate' | 'ac' | 'defog'): void {
    if (!this.climateEnabled) {
      promptAction.showToast({ message: '请先开启空调', duration: 1500 });
      return;
    }
    if (this.climateUpdating) {
      return;
    }

    const previousState = this.getCurrentClimateState();
    switch (mode) {
      case 'circulate':
        this.isCirculateOn = !this.isCirculateOn;
        console.info(`[Climate] Circulate toggled -> ${this.isCirculateOn}`);
        break;
      case 'ac':
        this.isAcOn = !this.isAcOn;
        console.info(`[Climate] A/C toggled -> ${this.isAcOn}`);
        break;
      case 'defog':
        this.isDefogOn = !this.isDefogOn;
        console.info(`[Climate] Defog toggled -> ${this.isDefogOn}`);
        break;
    }

    void this.updateClimateState('1', undefined, previousState);
  }

  @Builder
  LoadingSection(height: number, withMargin: boolean) {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#1152D4')

      Text('正在加载车辆信息…')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 12 })
    }
    .width('100%')
    .height(height)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.isDarkMode ? '#1C1C1E' : '#FFFFFF')
    .borderRadius(16)
    .margin(withMargin ? { bottom: 24 } : { bottom: 0 })
  }

  @Builder
  ErrorSection(height: number, withMargin: boolean) {
    Column({ space: 12 }) {
      Text(this.loadError || '车辆信息加载失败')
        .fontSize(14)
        .fontColor('#FF3B30')
        .textAlign(TextAlign.Center)

      if (this.loadError === '未绑定车辆，请先完成车辆绑定') {
        Button('去绑定车辆', { type: ButtonType.Capsule })
          .backgroundColor('#1152D4')
          .fontColor('#FFFFFF')
          .onClick(() => {
            router.pushUrl({ url: 'pages/lesson9/VehicleBindPage' });
          });
      } else {
        Button('重新加载', { type: ButtonType.Capsule })
          .backgroundColor('#1152D4')
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.fetchVehicleInfo();
          });
      }
    }
    .width('100%')
    .height(height)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.isDarkMode ? '#1C1C1E' : '#FFFFFF')
    .borderRadius(16)
    .margin(withMargin ? { bottom: 24 } : { bottom: 0 })
  }

}
