import { http } from '@kit.NetworkKit';
import { CommonResponse } from '../model/CommonResponse';
import { RegisterData } from '../model/RegisterData';
import { UserInfoResponse } from '../model/UserInfo';

/**
 * 网络请求工具类
 * 提供登录和注册等网络请求功能
 */
const BASE_URL = 'http://121.36.14.143:10001';

export interface ControlDoorPayload {
  carId: string;
  door: string;
}

export interface ControlLightPayload {
  carId: string;
  light: string;
}

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

export interface VehicleInfoDetail {
  createBy?: string;
  createTime?: string | null;
  updateBy?: string;
  updateTime?: string;
  remark?: string | null;
  params?: Record<string, Object>;
  id?: string;
  userId?: string;
  nickName?: string;
  carName?: string;
  brand?: string;
  carPic?: string;
  carVin?: string;
  horsePower?: string;
  maxPower?: string;
  maxTorque?: string;
  carSize?: string;
  nfc?: string;
  wheelBase?: string;
  frontWheelBase?: string;
  backWheelBase?: string;
  batteryPower?: string;
  enduranceMileage?: string;
  kmh?: string;
  batteryCode?: string;
  batteryType?: string | null;
  batteryCapacity?: string;
  nominalVoltage?: string;
  ratedCurrent?: string;
  workingTemperature?: string;
  delFlag?: string;
}

export interface VehicleInfoResponse {
  msg?: string;
  code?: number;
  data?: VehicleInfoDetail;
}

export interface ClimateStatePayload {
  auto: string;
  door: string;
  light: string;
  temperature: string;
  windLevel: string;
  circulate: string;
  setTemp: string;
  acBtn: string;
  clearFog: string;
  fanState: string;
  playMode: string;
  processMp3: string;
  mp3Playing: string;
  processMp4: string;
  mp4Playing: string;
  carVin: string;
}

export interface CarOperationLogRecord {
  createBy?: string;
  createTime?: string;
  updateBy?: string;
  updateTime?: string;
  id: string;
  userId?: string;
  userName?: string;
  carId?: string;
  carName?: string;
  operaType?: string;
  operaContent?: string;
}

export interface CarOperationLogListResponse {
  total?: number;
  rows?: CarOperationLogRecord[];
  code?: number;
  msg?: string;
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

export async function controlDoorRequest(token: string, payload: ControlDoorPayload): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/control/door`;

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
        console.error(`[CarControl][Door] 请求失败 -> ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`[CarControl][Door] 解析响应失败 -> ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function controlLightRequest(token: string, payload: ControlLightPayload): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/control/light`;

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
        console.error(`[CarControl][Light] 请求失败 -> ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`[CarControl][Light] 解析响应失败 -> ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

async function sendCarCommandWithoutBody(token: string, endpoint: string, logLabel: string): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}${endpoint}`;

    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      connectTimeout: 10000,
      readTimeout: 10000
    }, (err, data) => {
      httpRequest.destroy();

      if (err) {
        console.error(`[CarControl][${logLabel}] 请求失败 -> ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`[CarControl][${logLabel}] 解析响应失败 -> ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function controlMoveRequest(token: string, carId: string): Promise<CommonResponse> {
  return sendCarCommandWithoutBody(token, `/cockpit/control/move/${carId}`, 'Move');
}

export async function controlBackRequest(token: string, carId: string): Promise<CommonResponse> {
  return sendCarCommandWithoutBody(token, `/cockpit/control/back/${carId}`, 'Back');
}

export async function controlLeftRequest(token: string, carId: string): Promise<CommonResponse> {
  return sendCarCommandWithoutBody(token, `/cockpit/control/left/${carId}`, 'Left');
}

export async function controlRightRequest(token: string, carId: string): Promise<CommonResponse> {
  return sendCarCommandWithoutBody(token, `/cockpit/control/right/${carId}`, 'Right');
}

export async function controlStopRequest(token: string, carId: string): Promise<CommonResponse> {
  return sendCarCommandWithoutBody(token, `/cockpit/control/stop/${carId}`, 'Stop');
}

export interface CarOperationLogQueryParams {
  pageNum: number;
  pageSize: number;
  operaContent?: string;
  orderByColumn?: string;
  isAsc?: string;
}

export async function getCarOperationLogListRequest(token: string, params: CarOperationLogQueryParams): Promise<CarOperationLogListResponse> {
  return new Promise<CarOperationLogListResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const queryParts: string[] = [];
    queryParts.push(`pageNum=${encodeURIComponent(params.pageNum)}`);
    queryParts.push(`pageSize=${encodeURIComponent(params.pageSize)}`);
    if (params.operaContent !== undefined) {
      queryParts.push(`operaContent=${encodeURIComponent(params.operaContent)}`);
    }
    if (params.orderByColumn !== undefined) {
      queryParts.push(`orderByColumn=${encodeURIComponent(params.orderByColumn)}`);
    }
    if (params.isAsc !== undefined) {
      queryParts.push(`isAsc=${encodeURIComponent(params.isAsc)}`);
    }
    const query = queryParts.join('&');
    const url = `${BASE_URL}/cockpit/log/list?${query}`;

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
        console.error(`获取车辆操控日志列表失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CarOperationLogListResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析车辆操控日志列表失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function deleteCarOperationLogRequest(token: string, id: string | number): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/log/${id}`;

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
        console.error(`删除车辆操控日志失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析删除车辆操控日志响应失败: ${JSON.stringify(parseErr)}`);
        reject(parseErr);
      }
    });
  });
}

export async function updateClimateStateRequest(token: string, payload: ClimateStatePayload): Promise<CommonResponse> {
  return new Promise<CommonResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/state`;

    httpRequest.request(url, {
      method: http.RequestMethod.PUT,
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
        console.error(`更新空调状态失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as CommonResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析空调状态更新响应失败: ${JSON.stringify(parseErr)}`);
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

export async function getVehicleInfoDetailRequest(token: string, id: string | number): Promise<VehicleInfoResponse> {
  return new Promise<VehicleInfoResponse>((resolve, reject) => {
    const httpRequest = http.createHttp();
    const url = `${BASE_URL}/cockpit/info/${id}`;

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
        console.error(`获取车辆信息详情失败: ${JSON.stringify(err)}`);
        reject(err);
        return;
      }

      try {
        const response = JSON.parse(data.result as string) as VehicleInfoResponse;
        resolve(response);
      } catch (parseErr) {
        console.error(`解析车辆信息详情数据失败: ${JSON.stringify(parseErr)}`);
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
