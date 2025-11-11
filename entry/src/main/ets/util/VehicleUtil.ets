import router from '@ohos.router';
import { getUserInfoRequest } from './HttpUtil';

/**
 * 车辆工具类
 * 提供车辆绑定状态检查等功能
 */

/**
 * 检查车辆绑定状态并跳转
 * @param token 用户token
 */
export async function checkVehicleBindingAndNavigate(token: string): Promise<void> {
  try {
    // 调用获取用户信息接口
    const userInfoResponse = await getUserInfoRequest(token);

    if (userInfoResponse.code === 200) {
      // carVin字段在响应根级别，不在data对象中
      const carVin = userInfoResponse.carVin;
      
      // 判断是否已绑定车架号
      // carVin存在且不为空字符串，且去除空格后长度大于0
      const hasCarVin = carVin !== undefined && 
                        carVin !== null && 
                        carVin !== '' && 
                        String(carVin).trim().length > 0;
      
      console.info(`检查车辆绑定状态 - carVin: ${JSON.stringify(carVin)}, hasCarVin: ${hasCarVin}`);
      
      if (hasCarVin) {
        // 已绑定，跳转到首页
        console.info('车辆已绑定，跳转到首页');
        setTimeout(() => {
          router.replaceUrl({
            url: 'pages/lesson9/HomePage'
          });
        }, 500);
      } else {
        // 未绑定，跳转到车辆绑定页面
        console.info('车辆未绑定，跳转到绑定页面');
        setTimeout(() => {
          router.replaceUrl({
            url: 'pages/lesson9/VehicleBindPage'
          });
        }, 500);
      }
    } else {
      // 获取用户信息失败，跳转到登录页
      const errorMsg = userInfoResponse.msg || '获取用户信息失败';
      console.error(`获取用户信息失败: ${errorMsg}, code: ${userInfoResponse.code}`);
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/lesson9/LoginPage_opt'
        });
      }, 500);
    }
  } catch (err) {
    // 网络异常，跳转到登录页
    console.error(`检查车辆绑定状态异常: ${JSON.stringify(err)}`);
    setTimeout(() => {
      router.replaceUrl({
        url: 'pages/lesson9/LoginPage_opt'
      });
    }, 500);
  }
}
