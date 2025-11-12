import { http } from '@kit.NetworkKit';
import { CommonResponse } from '../model/CommonResponse';
import { RegisterData } from '../model/RegisterData';
import { UserInfoResponse } from '../model/UserInfo';

/**
 * 网络请求工具类
 * 提供登录和注册等网络请求功能
 */
const BASE_URL = 'http://121.36.14.143:10001';

export interface FeedbackRecord {
  createBy?: string;
  createTime?: string;
  updateBy?: string;
  updateTime?: string;
  remark?: string;
  params?: Record<string, Object>;
  id?: string;
  userId?: string;
  userName?: string;
  nickName?: string;
  phonenumber?: string;
  content?: string;
  status?: string;
  picUrl?: string;
  delFlag?: string;
}

export interface FeedbackListResponse {
  msg?: string;
  code?: number;
  data?: FeedbackRecord[];
}

export interface FeedbackDetailRecord {
  createBy?: string;
  createTime?: string;
  updateBy?: string;
  updateTime?: string;
  id?: string;
  userId?: string;
  userName?: string;
  reply?: string;
  nickName?: string;
  phonenumber?: string;
  content?: string;
  status?: string;
  picUrl?: string;
  delFlag?: string;
}

export interface FeedbackDetailResponse {
  msg?: string;
  code?: number;
  data?: FeedbackDetailRecord;
}

export interface CreateFeedbackPayload {
  id: number;
  userId: number;
  userName: string;
  nickName: string;
  phonenumber: string;
  content: string;
  status: string;
  picUrl: string;
  delFlag: string;
  searchValue: string;
  createBy: string;
  createTime: string;
  updateBy: string;
  updateTime: string;
  remark: string;
  params: Record<string, Object>;
}

/**
 * 登录请求
 * @param username 用户名
 * @param password 密码
 * @returns Promise<CommonResponse> 响应数据
 */
export async function loginRequest(username: string, password: string): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/app/login`;
    
    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify({
        username: username,
        password: password
      }),
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();
      
      if (err) {
        console.error(`登录请求失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }
      
      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析响应数据失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function deleteFeedbackRequest(token: string, ids: string | number): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/feedback/${ids}`;

    httpRequest.request(url, {
      method: http.RequestMethod.DELETE,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();

      if (err) {
        console.error(`删除反馈失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析删除反馈响应失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function getFeedbackDetailRequest(token: string, id: string | number): Promise<FeedbackDetailResponse> {
  return new Promise<FeedbackDetailResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/feedback/${id}`;

    httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();

      if (err) {
        console.error(`获取反馈详情失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as FeedbackDetailResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析反馈详情数据失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function createFeedbackRequest(token: string, payload: CreateFeedbackPayload): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/feedback/add`;

    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      extraData: JSON.stringify(payload),
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();

      if (err) {
        console.error(`新增反馈失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析新增反馈响应失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function getFeedbackListRequest(token: string): Promise<FeedbackListResponse> {
  return new Promise<FeedbackListResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/feedback/backList`;

    httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();

      if (err) {
        console.error(`获取反馈列表失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as FeedbackListResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析反馈列表数据失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

/**
 * 获取用户信息请求
 * @param token Bearer Token
 * @returns Promise<UserInfoResponse> 响应数据
 */
export async function getUserInfoRequest(token: string): Promise<UserInfoResponse> {
  return new Promise<UserInfoResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/getInfo`;
    
    httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();
      
      if (err) {
        console.error(`获取用户信息失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }
      
      try {
        const response = JSON.parse(data.result as string) as UserInfoResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析响应数据失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

/**
 * 绑定车架号请求
 * @param token Bearer Token
 * @param carVin 9位车架号
 * @returns Promise<CommonResponse> 响应数据
 */
export async function bindCarVinRequest(token: string, carVin: string): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/info/bindCarVin`;
    
    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      extraData: JSON.stringify({
        carVin: carVin
      }),
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();
      
      if (err) {
        console.error(`绑定车架号失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }
      
      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析响应数据失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

/**
 * 注册请求
 * @param registerData 注册数据对象
 * @returns Promise<CommonResponse> 响应数据
 */
export async function registerRequest(registerData: RegisterData): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/system/user/register`;
    
    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify(registerData),
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();
      
      if (err) {
        console.error(`注册请求失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }
      
      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析响应数据失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}
