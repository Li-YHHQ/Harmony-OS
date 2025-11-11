/**
 * 注册数据接口
 * 用于注册请求的数据模型
 */
export interface RegisterData {
  nickName: string;
  userName: string;
  phonenumber: string;
  sex: string;
  avatar: string;
  password: string;
  roleids: string[];
  birthDate: string;
  state: string;
}
