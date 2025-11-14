/**
 * 用户信息数据模型
 * 用于获取用户信息接口的响应数据
 * 注意：carVin字段在响应根级别，不在data对象中
 */

/**
 * 用户对象接口
 */
export interface UserInfo {
  userId?: string;
  nickName?: string;
  userName?: string;
  phonenumber?: string;
  sex?: string;
  birthDate?: string;
  admin?: boolean;
  carId?: string;
}

/**
 * 用户信息响应类
 */
export class UserInfoResponse {
  msg?: string;
  code?: number;
  carId?: string;
  carVin?: string;  // 车架号（关键字段：判断绑定状态）
  permissions?: string[];
  roles?: string[];
  sign?: string;
  user?: UserInfo;
}
