import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

/**
 * 存储工具类
 * 用于管理本地数据存储，包括token等敏感信息
 */
const PREFERENCE_NAME = 'user_preferences';
const TOKEN_KEY = 'user_token';

/**
 * 保存token到本地存储
 * @param context 应用上下文
 * @param token 要保存的token
 */
export async function saveToken(context: Context, token: string): Promise<void> {
  try {
    const dataPreferences = await preferences.getPreferences(context, PREFERENCE_NAME);
    await dataPreferences.put(TOKEN_KEY, token);
    await dataPreferences.flush();
  } catch (err) {
    console.error(`保存token失败: ${JSON.stringify(err)}`);
    let errorMessage = `保存token失败: ${JSON.stringify(err)}`;
    if (err && typeof err === 'object') {
      const errorObj = err as Record<string, Object>;
      if (errorObj.message && typeof errorObj.message === 'string') {
        errorMessage = errorObj.message as string;
      }
    }
    throw new Error(errorMessage);
  }
}

/**
 * 从本地存储获取token
 * @param context 应用上下文
 * @returns token字符串，如果不存在则返回空字符串
 */
export async function getToken(context: Context): Promise<string> {
  try {
    const dataPreferences = await preferences.getPreferences(context, PREFERENCE_NAME);
    const token = await dataPreferences.get(TOKEN_KEY, '');
    return token as string;
  } catch (err) {
    console.error(`获取token失败: ${JSON.stringify(err)}`);
    return '';
  }
}

/**
 * 清除本地存储的token
 * @param context 应用上下文
 */
export async function clearToken(context: Context): Promise<void> {
  try {
    const dataPreferences = await preferences.getPreferences(context, PREFERENCE_NAME);
    await dataPreferences.delete(TOKEN_KEY);
    await dataPreferences.flush();
  } catch (err) {
    console.error(`清除token失败: ${JSON.stringify(err)}`);
    let errorMessage = `清除token失败: ${JSON.stringify(err)}`;
    if (err && typeof err === 'object') {
      const errorObj = err as Record<string, Object>;
      if (errorObj.message && typeof errorObj.message === 'string') {
        errorMessage = errorObj.message as string;
      }
    }
    throw new Error(errorMessage);
  }
}
