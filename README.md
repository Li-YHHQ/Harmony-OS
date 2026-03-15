# HarmonyOS 智能汽车控制应用

基于 HarmonyOS 5.1.1 开发的奥迪智能汽车远程控制与管理移动应用，提供车辆远程控制、信息查看、AI 助手及用户反馈等功能。

## 功能特性

- **用户认证**：注册、登录，Token 持久化存储
- **车辆绑定**：通过 VIN 码（9 位车辆识别码）绑定车辆
- **远程控制**：远程控制车门开关、车灯开关、车辆行驶方向（前进/后退/左转/右转/停止）
- **空调管理**：远程调节车内空调及温控状态
- **车辆信息**：查看电池电量、马力、扭矩、外观尺寸等详细车辆参数
- **反馈系统**：创建、查看和管理用户反馈/投诉工单
- **操作日志**：追踪并查看车辆操作历史记录
- **AI 助手**：集成 DeepSeek 大模型，支持车辆相关智能问答
- **个人中心**：用户信息管理与注销
- **深色模式**：支持亮色/深色主题切换

## 技术栈

| 类型 | 技术 |
|------|------|
| 平台 | HarmonyOS 5.1.1 (API Level 19) |
| 语言 | ArkTS (ETS) |
| UI 框架 | ArkUI 声明式 UI |
| 构建工具 | Hvigor |
| 网络 | @kit.NetworkKit HTTP |
| 存储 | @kit.ArkData Preferences |
| 测试 | @ohos/hypium + @ohos/hamock |
| AI 服务 | 阿里云 DashScope (DeepSeek-R1 模型) |

## 项目结构

```
Harmony-OS/
├── AppScope/                  # 全局应用配置与图标资源
├── entry/                     # 主应用模块
│   └── src/main/
│       ├── ets/
│       │   ├── entryability/  # 应用入口 Ability
│       │   ├── pages/
│       │   │   └── lesson9/   # 主要页面
│       │   │       ├── WelcomePage.ets        # 启动欢迎页
│       │   │       ├── LoginPage_opt.ets      # 登录页
│       │   │       ├── RegisterPage1.ets      # 注册页
│       │   │       ├── VehicleBindPage.ets    # 车辆绑定页
│       │   │       ├── HomePage.ets           # 首页
│       │   │       ├── MinePage.ets           # 主标签页
│       │   │       ├── CarControl.ets         # 车辆控制页
│       │   │       ├── CarInformation.ets     # 车辆信息页
│       │   │       ├── AIAssistantPage.ets    # AI 助手页
│       │   │       ├── FeedbackListPage.ets   # 反馈列表页
│       │   │       ├── CreateFeedbackPage.ets # 创建反馈页
│       │   │       └── FeedbackDetailPage.ets # 反馈详情页
│       │   ├── model/         # 数据模型
│       │   ├── util/          # 工具类（HTTP、存储、车辆绑定）
│       │   └── view/          # 可复用 UI 组件
│       └── resources/         # 主题色、字符串、图片等资源
├── hvigor/                    # 构建工具配置
├── build-profile.json5        # 构建配置
├── code-linter.json5          # 代码规范配置
└── oh-package.json5           # 依赖管理
```

## 页面导航流程

```
WelcomePage（启动页）
    └─> 有 Token ──> VehicleBindPage（绑定车辆）──> MinePage（主界面）
    └─> 无 Token ──> LoginPage（登录）──> VehicleBindPage ──> MinePage

MinePage（底部标签栏）
    ├── 首页（HomeContentComp）
    ├── 反馈管理（FeedbackListPage）
    ├── 车辆信息（CarInformation）
    └── 车辆控制（CarControl）
         └── AI 助手（AIAssistantPage）
```

## 开发环境要求

- **DevEco Studio** 5.0 或更高版本
- **HarmonyOS SDK** 5.1.1（API Level 19）
- **Node.js** 16 或更高版本

## 快速开始

1. 克隆仓库

```bash
git clone <repository-url>
cd Harmony-OS
```

2. 用 DevEco Studio 打开项目

3. 等待依赖同步完成

4. 连接 HarmonyOS 真机或启动模拟器

5. 点击 **Run** 按钮或使用以下命令构建：

```bash
# 构建 Debug 版本
hvigorw assembleHap --mode module -p module=entry@default -p product=default -p buildMode=debug

# 构建 Release 版本
hvigorw assembleHap --mode module -p module=entry@default -p product=default -p buildMode=release
```

## 后端接口

应用依赖以下后端服务（默认地址：`http://121.36.14.143:10001`）：

| 接口 | 方法 | 说明 |
|------|------|------|
| `/app/login` | POST | 用户登录 |
| `/system/user/register` | POST | 用户注册 |
| `/getInfo` | GET | 获取用户信息 |
| `/cockpit/info/bindCarVin` | POST | 绑定车辆 VIN |
| `/cockpit/info/{id}` | GET | 获取车辆详情 |
| `/cockpit/control/door` | POST | 控制车门 |
| `/cockpit/control/light` | POST | 控制车灯 |
| `/cockpit/control/move/{id}` 等 | POST | 控制车辆行驶 |
| `/cockpit/state` | PUT | 更新空调状态 |
| `/cockpit/feedback/backList` | GET | 获取反馈列表 |
| `/cockpit/feedback/add` | POST | 创建反馈 |
| `/cockpit/log/list` | GET | 获取操作日志 |

## 运行测试

```bash
# 运行单元测试
hvigorw test --module entry --unittest

# 运行 UI 测试
hvigorw test --module entry --target ohosTest
```

## 注意事项

- 应用需要 `ohos.permission.INTERNET` 网络权限
- AI 助手功能需要有效的阿里云 DashScope API Key，请在 `HttpUtil.ets` 中配置（生产环境建议通过安全配置管理）
- 目标设备类型：手机（phone）
- 最低支持 HarmonyOS API Level 19

## 许可证

本项目仅供学习交流使用。
