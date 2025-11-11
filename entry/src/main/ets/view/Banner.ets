import { BannerClass } from '../model/BannerClass';

/**
 * Banner组件
 * 用于展示轮播图
 */
@Component
export struct Banner {
  @Param bannerData: BannerClass[] = [];

  build() {
    Swiper() {
      ForEach(this.bannerData, (item: BannerClass) => {
        Image(item.imageUrl)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .onClick(() => {
            // 处理点击事件
            console.info(`Banner clicked: ${item.title}`);
          })
      }, (item: BannerClass) => item.id.toString())
    }
    .indicator(this.bannerData.length > 1)
    .loop(this.bannerData.length > 1)
    .duration(3000)
    .autoPlay(this.bannerData.length > 1)
  }
}
