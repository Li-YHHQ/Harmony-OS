/**
 * Banner数据模型类
 * 用于存储Banner相关的数据
 */
export class BannerClass {
  id: number = 0;
  title: string = '';
  imageUrl: string = '';
  linkUrl: string = '';

  constructor(id: number, title: string, imageUrl: string, linkUrl: string) {
    this.id = id;
    this.title = title;
    this.imageUrl = imageUrl;
    this.linkUrl = linkUrl;
  }
}
