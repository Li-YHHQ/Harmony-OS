@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
    }
    .height('100%')
    .width('100%')
  }
}
//
//
// import { CarControlState } from '../mode/CarControlModel'
//
// @Component
// export struct CarControlComponent {
//   @Link controlState: CarControlState
//
//   onDoorControl?: () => void
//   onLightControl?: () => void
//   onMoveForward?: () => void
//   onMoveBackward?: () => void
//   onTurnLeft?: () => void
//   onTurnRight?: () => void
//   onStopVehicle?: () => void
//
//   // 方向按钮按下状态
//   @State forwardPressed: boolean = false
//   @State backwardPressed: boolean = false
//   @State leftPressed: boolean = false
//   @State rightPressed: boolean = false
//
//   build() {
//     Column() {
//       // 顶部控制区域
//       Row() {
//         // 车灯控制按钮（左边）
//         Column() {
//           Image(this.controlState.lightState ?
//           $r('app.media.carh_k') :  // 车灯打开
//           $r('app.media.carh_g')    // 车灯关闭
//           )
//             .width(35)
//             .height(35)
//             .objectFit(ImageFit.Contain)
//
//           Text(this.controlState.lightState ? '车灯开' : '车灯关')
//             .fontSize(11)
//             .fontColor(this.controlState.lightState ? '#4A90E2' : '#333333')
//             .margin({ top: 5 })
//         }
//         .width(70)
//         .height(70)
//         .alignItems(HorizontalAlign.Center)
//         .justifyContent(FlexAlign.Center)
//         .backgroundColor(this.controlState.lightState ? '#E6F7FF' : '#EEEEEE')
//         .borderRadius(8)
//         .border({
//           width: 2,
//           color: this.controlState.lightState ? '#4A90E2' : '#EEEEEE'
//         })
//         .onClick(() => {
//           console.log('点击车灯按钮')
//           if (this.onLightControl) {
//             this.onLightControl()
//           }
//         })
//         .zIndex(100)
//         .enabled(true)
//
//         // 中间车辆图片
//         Column() {
//           Image(this.getCarImage())
//             .width(400)
//             .height(320)
//             .objectFit(ImageFit.Contain)
//
//           Text(`车门:${this.controlState.doorState ? '开' : '关'}, 车灯:${this.controlState.lightState ? '开' : '关'}`)
//             .fontSize(14)
//             .fontColor('#333333')
//             .margin({ top: 8 })
//         }
//         .layoutWeight(1)
//         .alignItems(HorizontalAlign.Center)
//         .zIndex(1)
//
//         // 车门控制按钮（右边）
//         Column() {
//           Image(this.controlState.doorState ?
//           $r('app.media.card_k') :  // 车门打开
//           $r('app.media.card_g')    // 车门关闭
//           )
//             .width(35)
//             .height(35)
//             .objectFit(ImageFit.Contain)
//
//           Text(this.controlState.doorState ? '车门开' : '车门关')
//             .fontSize(11)
//             .fontColor(this.controlState.doorState ? '#4A90E2' : '#333333')
//             .margin({ top: 5 })
//         }
//         .width(70)
//         .height(70)
//         .alignItems(HorizontalAlign.Center)
//         .justifyContent(FlexAlign.Center)
//         .backgroundColor(this.controlState.doorState ? '#E6F7FF' : '#EEEEEE')
//         .borderRadius(8)
//         .border({
//           width: 2,
//           color: this.controlState.doorState ? '#4A90E2' : '#EEEEEE'
//         })
//         .onClick(() => {
//           console.log('点击车门按钮')
//           if (this.onDoorControl) {
//             this.onDoorControl()
//           }
//         })
//         .zIndex(100)
//       }
//       .width('100%')
//       .height(350)
//       .padding({ left: 10, right: 10 })
//       .margin({ top: 20 })
//       .justifyContent(FlexAlign.SpaceBetween)
//       .alignItems(VerticalAlign.Center)
//
//       // 方向控制区域
//       Column() {
//         Text('方向控制')
//           .fontSize(16)
//           .fontWeight(FontWeight.Bold)
//           .fontColor(Color.Black)
//           .margin({ bottom: 15 })
//
//         // 前进按钮
//         Column() {
//           Image(this.forwardPressed ? $r('app.media.tu_s_k') : $r('app.media.tu_s_g'))
//             .width(35)
//             .height(35)
//             .objectFit(ImageFit.Contain)
//
//           Text('前进')
//             .fontSize(11)
//             .fontColor(this.forwardPressed ? '#4A90E2' : '#666666')
//             .margin({ top: 5 })
//         }
//         .onTouch((event) => {
//           if (event.type === 0) { // TouchDown
//             console.log('按下前进按钮')
//             this.forwardPressed = true
//             this.onMoveForward?.()
//           } else if (event.type === 1) { // TouchUp
//             console.log('松开前进按钮')
//             this.forwardPressed = false
//             this.onStopVehicle?.()
//           }
//         })
//
//         // 中间行：左转和右转
//         Row({ space: 100 }) {
//           // 左转按钮
//           Column() {
//             Image(this.leftPressed ? $r('app.media.tu_z_k') : $r('app.media.tu_z_g'))
//               .width(35)
//               .height(35)
//               .objectFit(ImageFit.Contain)
//
//             Text('左转')
//               .fontSize(11)
//               .fontColor(this.leftPressed ? '#4A90E2' : '#666666')
//           }
//           .onTouch((event) => {
//             if (event.type === 0) { // TouchDown
//               console.log('按下左转按钮')
//               this.leftPressed = true
//               this.onTurnLeft?.()
//             } else if (event.type === 1) { // TouchUp
//               console.log('松开左转按钮')
//               this.leftPressed = false
//               this.onStopVehicle?.()
//             }
//           })
//
//           // 右转按钮
//           Column() {
//             Image(this.rightPressed ? $r('app.media.tu_y_k') : $r('app.media.tu_y_g'))
//               .width(35)
//               .height(35)
//               .objectFit(ImageFit.Contain)
//
//             Text('右转')
//               .fontSize(11)
//               .fontColor(this.rightPressed ? '#4A90E2' : '#666666')
//           }
//           .onTouch((event) => {
//             if (event.type === 0) { // TouchDown
//               console.log('按下右转按钮')
//               this.rightPressed = true
//               this.onTurnRight?.()
//             } else if (event.type === 1) { // TouchUp
//               console.log('松开右转按钮')
//               this.rightPressed = false
//               this.onStopVehicle?.()
//             }
//           })
//         }
//         .margin({ top: 12, bottom: 12 })
//
//         // 后退按钮
//         Column() {
//           Image(this.backwardPressed ? $r('app.media.tu_x_k') : $r('app.media.tu_x_g'))
//             .width(35)
//             .height(35)
//             .objectFit(ImageFit.Contain)
//
//           Text('后退')
//             .fontSize(11)
//             .fontColor(this.backwardPressed ? '#4A90E2' : '#666666')
//             .margin({ top: 5 })
//         }
//         .onTouch((event) => {
//           if (event.type === 0) { // TouchDown
//             console.log('按下后退按钮')
//             this.backwardPressed = true
//             this.onMoveBackward?.()
//           } else if (event.type === 1) { // TouchUp
//             console.log('松开后退按钮')
//             this.backwardPressed = false
//             this.onStopVehicle?.()
//           }
//         })
//       }
//       .width('100%')
//       .margin({ top: 20, bottom: 25 })
//       .alignItems(HorizontalAlign.Center)
//       .padding(12)
//       .backgroundColor(Color.White)
//       .borderRadius(10)
//       .shadow({ radius: 4, color: '#1A000000', offsetX: 1, offsetY: 1 })
//     }
//     .width('100%')
//     .height('100%')
//     .padding(10)
//     .backgroundColor('#F5F5F5')
//   }
//
//   private getCarImage(): Resource {
//     if (this.controlState.doorState && this.controlState.lightState) {
//       return $r('app.media.car_k_k') // 车门开 + 车灯开
//     } else if (this.controlState.doorState && !this.controlState.lightState) {
//       return $r('app.media.car_k_g') // 车门开 + 车灯关
//     } else if (!this.controlState.doorState && this.controlState.lightState) {
//       return $r('app.media.car_g_k') // 车门关 + 车灯开
//     } else {
//       return $r('app.media.car_g_g') // 车门关 + 车灯关
//     }
//   }
// }
//
