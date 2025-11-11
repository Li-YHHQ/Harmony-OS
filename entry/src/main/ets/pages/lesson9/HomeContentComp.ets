interface IResourceData {
  id: string,
  imgSrc: Resource,
  title: string,
  description: string
}

@Preview
@Component
export struct HomeContentComp {
  build() {
    Scroll() {
      Column({ space: 20 }) {
        SwiperArea()
        RecommendCourse()
        ExcellentListComp()
      }
    }.scrollBar(BarState.Off)
  }
}

@Component
struct SwiperArea {
  build() {
    Swiper() {
      Stack() {
        Image($r('app.media.lunbo1'))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .margin({ top: -40 })
      }
      .width('100%')
      .height(160)
      .clip(true)

      Stack() {
        Image($r('app.media.lunbo2'))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .margin({ top: -40 })
      }
      .width('100%')
      .height(160)
      .clip(true)

      Stack() {
        Image($r('app.media.lunbo3'))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .margin({ top: -40 })
      }
      .width('100%')
      .height(160)
      .clip(true)
    }
    .width('100%')
    .height(220)
    .loop(true)
    .autoPlay(true)
    .indicator(true)
  }
}

@Component
struct RecommendCourse {
  @State currentScrollIndex: number = 0

  build() {
    Column({ space: 0 }) {
      Scroll() {
        Row({ space: 20 }) {
          Column({ space: 8 }) {
            Image($r('app.media.hengxiang1'))
              .width(140)
              .height(120)
              .borderRadius(12)
              .objectFit(ImageFit.Cover)
            Column({ space: 4 }) {
              Text('A6L')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('豪华商务轿车，搭载先进科技配置，提供卓越驾乘体验')
                .fontSize(12)
                .fontColor('rgba(0,0,0,0.6)')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(2)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width(150)
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 4, color: '#1A000000', offsetX: 1, offsetY: 1 })

          Column({ space: 8 }) {
            Image($r('app.media.hengxiang2'))
              .width(140)
              .height(120)
              .borderRadius(12)
              .objectFit(ImageFit.Cover)
            Column({ space: 4 }) {
              Text('Q6L e-tron')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('纯电动SUV，续航超600公里，智能驾驶辅助系统')
                .fontSize(12)
                .fontColor('rgba(0,0,0,0.6)')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(2)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width(150)
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 4, color: '#1A000000', offsetX: 1, offsetY: 1 })

          Column({ space: 8 }) {
            Image($r('app.media.hengxiang3'))
              .width(140)
              .height(120)
              .borderRadius(12)
              .objectFit(ImageFit.Cover)
            Column({ space: 4 }) {
              Text('A8L Horch')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('旗舰豪华轿车，专属定制配置，极致舒适体验')
                .fontSize(12)
                .fontColor('rgba(0,0,0,0.6)')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(2)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width(150)
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 4, color: '#1A000000', offsetX: 1, offsetY: 1 })

          Column({ space: 8 }) {
            Image($r('app.media.hengxiang4'))
              .width(140)
              .height(120)
              .borderRadius(12)
              .objectFit(ImageFit.Cover)
            Column({ space: 4 }) {
              Text('预约试驾')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('专业顾问一对一服务，体验奥迪卓越性能')
                .fontSize(12)
                .fontColor('rgba(0,0,0,0.6)')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(2)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width(150)
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 4, color: '#1A000000', offsetX: 1, offsetY: 1 })
        }
        .padding({ left: 16, right: 16 })
        .height(200)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(200)
    }
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}

@Component
struct ExcellentListComp {
  @State excellentList: IResourceData[] = [
    {
      id: '1',
      imgSrc: $r('app.media.shuxiang1'),
      title: '奥迪A6L 深度解析与性能评测',
      description: '全面解析奥迪A6L的卓越性能，包括动力系统、智能驾驶辅助、豪华内饰配置及实际驾驶体验。'
    },
    {
      id: '2',
      imgSrc: $r('app.media.shuxiang2'),
      title: '奥迪Q系列SUV全系导购',
      description: '从Q3到Q8，详细了解奥迪SUV家族各车型特点、配置差异及适用场景，助您选择最适合的座驾。'
    },
    {
      id: '3',
      imgSrc: $r('app.media.shuxiang3'),
      title: '奥迪e-tron电动技术解析',
      description: '深入探讨奥迪电动技术，包括电池管理系统、充电效率、续航表现及未来电动化战略。'
    },
    {
      id: '4',
      imgSrc: $r('app.media.shuxiang4'),
      title: '奥迪quattro四驱系统详解',
      description: '揭秘奥迪标志性quattro四驱技术，分析其在各种路况下的卓越表现和驾驶稳定性。'
    },
    {
      id: '5',
      imgSrc: $r('app.media.shuxiang5'),
      title: '奥迪虚拟座舱使用指南',
      description: '全面介绍奥迪虚拟座舱功能，包括导航系统、娱乐控制、车辆设置等智能交互体验。'
    },
    {
      id: '6',
      imgSrc: $r('app.media.shuxiang6'),
      title: '奥迪保养与维护全攻略',
      description: '专业指导奥迪车型保养周期、常见问题处理、延长车辆使用寿命的实用技巧。'
    }
  ]

  build() {
    Column({ space: 5 }) {
      ForEach(this.excellentList, (item: IResourceData) => {
        Row() {
          Image(item.imgSrc)
            .width(108)
            .height(64)
            .objectFit(ImageFit.Cover)
            .borderRadius(12)
            .margin({ left: 16 })
          Column({ space: 4 }) {
            Text(item.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text(item.description)
              .fontSize(12)
              .fontColor('rgba(0,0,0,0.6)')
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
          }
          .layoutWeight(1)
          .margin({ left: 12, right: 16 })
        }
        .width('100%')
        .height(100)
        .backgroundColor(Color.White)
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding({ top: 10, bottom: 10 })
    .margin({ left: 8, right: 8 })
  }
}
