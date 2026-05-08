# StretchGoGo - App Store Listing
> ⚠️ **直接对照本文件填写 App Store Connect，无需查阅其他文档。**
>
> 生成时间: 2026-05-08 | 内购类型: 自动续期订阅 $0.99/月

---

## 第四步：创建 App（左侧菜单 → "我的 App" → "+" → "新建 App"）

| App Store Connect 字段 | 填写值 | 操作说明 |
|----------------------|-------|---------|
| 平台 | iOS | 勾选 iOS |
| 名称 | StretchGoGo | 输入 App Store 显示名称 |
| 主语言 | English | 下拉选择 English |
| Bundle ID | com.ggsheng.StretchGoGo | 从下拉列表中选择（Xcode 自动创建）|
| SKU | StretchGoGo-100 | 输入唯一标识（随便填）|

---

## 第五步：App 隐私（左侧菜单 → "App 隐私"）

| App Store Connect 问题 | 选择 | 说明 |
|----------------------|------|------|
| 健康与健身 | 否 | App 不收集健康数据（用户本地追踪）|
| 位置 | 否 | 不使用位置功能 |
| 联系信息 | 否 | 不收集联系信息 |
| 标识符 | 否 | 不使用广告标识符 |
| 浏览历史与搜索 | 否 | App 不收集浏览数据 |
| **购买行为** | **是** | **包含内购订阅功能** |
| 崩溃日志 | 否 | 未集成崩溃统计 SDK |
| 性能数据 | 否 | 未集成分析 SDK |
| 广告 | 否 | 不使用广告 |
| **隐私政策网址** | https://lauer3912.github.io/ios-StretchFlow/docs/PrivacyPolicy.html | 粘贴到底部输入框 |

→ 点**"存储"**按钮保存

---

## 第六步：定价与范围（左侧菜单 → "定价与范围"）

| App Store Connect 字段 | 填写值 |
|----------------------|-------|
| 价格 | **Free**（内购变现：$0.99/月 Premium）|
| 可用性 | 全部地区（勾选所有地区）|

→ 点**"存储"**按钮保存

---

## 第七步：App Store 信息（左侧菜单 → "App Store 信息"）

| App Store Connect 字段 | 填写值 |
|----------------------|-------|
| **名称** | StretchGoGo |
| **副标题** | Your daily stretch companion（最多30字符）|
| **隐私政策网址** | （已在第五步填写，跳过）|
| **技术支持网址** | https://lauer3912.github.io/ios-StretchFlow/ |
| **营销网址** | https://lauer3912.github.io/ios-StretchFlow |
| **版本** | 1.0.0（须与 project.yml 一致）|
| **新版本内容** | 见下方 |
| **描述** | 见下方（最多4000字符）|
| **关键词** | stretch, yoga, fitness, health, exercise, workout, relaxation, meditation, flexibility, daily workout, stretch app, posture, back pain, office stretch（最多100字符）|
| **促销文本** | StretchGoGo -- Your daily stretch companion. $0.99/month. Try today.（最多170字符）|
| **App Store 图标** | 上传文件：AppStore/Assets/Icon/Icon-1024@1x.png |
| **版权** | © 2026 StretchGoGo |
| **内容权利** | 否（所有内容均为原创）|
| **年龄分级** | 4+（点"设置年龄分级"选择）|
| **主类别** | Health & Fitness |
| **次类别** | （不选）|
| **广告标识符** | 否（不使用 Advertising Identifier）|

### 新版本内容
```
Initial release of StretchGoGo.

- 72+ guided stretch sessions
- Smart timer with pause/resume
- Dark & light theme support
- Progress tracking & streak counter
- Premium subscription for advanced features
```

### 描述（完整文本）
```
**Start stretching today — your body will thank you.**

StretchGoGo helps you build a lasting stretching habit with guided sessions, progress tracking, and personalized routines. Whether you're recovering from injury, want to improve flexibility, or just need a quick break from sitting — StretchGoGo has you covered.

🧘 **Guided Stretch Sessions**
Expert-designed stretching routines targeting neck, shoulders, back, legs, and full body. Each session includes clear visual demonstrations.

⏱️ **Smart Timer**
Clean, focused countdown timer with pause/resume and skip controls. Stay in the moment without looking at your phone.

📊 **Progress Tracking**
Track your daily stretching streak, total sessions completed, and time spent stretching.

🎨 **Beautiful Design**
Switch between dark and light themes. Enjoy a premium, Apple Design Award-worthy interface.

**Free Features:**
- 10 guided stretch sessions
- Timer with pause/resume
- Dark & light themes
- Favorites & history

**Premium ($0.99/month):**
- All 72+ sessions
- Achievements & badges
- Voice guidance
- Daily reminders
- iCloud sync
- Advanced statistics

Subscribe to unlock every feature. Cancel anytime.
```

→ 点**"存储"**按钮保存

---

## 第八步：截图（左侧菜单 → "App Store 截图"）

> ⚠️ **StretchGoGo 必须提供 6.9" (iPhone 14 Pro Max) 和 6.7" (iPhone 14/15 Pro) 两组截图才能提交**

截图文件位置：`AppStore/Screenshots/` 目录下

| 上传区域 | 上传文件目录 | 张数 | 尺寸要求 |
|---------|-------------|------|---------|
| **iPhone 6.9" 英寸**（iPhone 14 Pro Max）| `AppStore/Screenshots/iPhone67/` | 至少5张 | 1290×2796 px 或 2796×1290 px |
| **iPhone 6.7" 英寸**（iPhone 14/15 Pro）| `AppStore/Screenshots/iPhone69/` | 至少5张 | 1179×2556 px 或 2556×1179 px |

**截图要求**：
- 必须显示 App 真实界面
- 5张截图需展示不同功能/页面
- 不能使用模拟器截图（需真机或 Xcode 的 screenshot tool）

---

## 内购产品配置（左侧菜单 → "内购"）

> ⚠️ **仅当 App 包含内购/订阅功能时需要。以下所有字段直接在此填写，无需查阅其他文件。**

### 一、协议准备（必须先在 App Store Connect 完成）

| 操作项 | 状态 | 说明 |
|-------|------|------|
| 签署**付费应用协议** | ⬜ 未签署 | App Store Connect → 协议 → 付费应用协议 |
| 填写**银行信息** | ⬜ 未填写 | 收款账户，验证可能需要1-2天 |
| 填写**税务信息** | ⬜ 未填写 | 美国 W-9 或 W-8BEN 表单 |

> ⚠️ **以上三者全部"有效"后才能创建内购产品**

### 二、自动续期订阅（Subscription）

#### 订阅组配置

| 订阅组名称 | 组内包含的产品 ID |
|-----------|------------------|
| PremiumGroup | com.ggsheng.StretchGoGo.PremiumMonthly |

#### 订阅产品列表

| 参考名称 | 产品 ID | 价格等级 | 显示名称(EN) | 描述(EN) | 时长 | 订阅组 |
|---------|--------|---------|-------------|---------|------|--------|
| Premium Monthly | com.ggsheng.StretchGoGo.PremiumMonthly | Tier 1 ($0.99) | Premium Monthly | Unlock all features: 72+ sessions, achievements, voice guidance, reminders, iCloud sync, advanced statistics. | 1 Month | PremiumGroup |

#### 试用/折扣方案（Introductory Offers）

| 产品 ID | 优惠类型 | 时长 | 价格 |
|--------|---------|------|------|
| com.ggsheng.StretchGoGo.PremiumMonthly | **无** | 不提供免费试用 | 直接付费 |

> 📝 StretchGoGo 采用无试用订阅模式，用户订阅后立即收费

#### 内购审核截图

| 产品 | 截图要求 | 文件位置 |
|------|---------|---------|
| Premium Monthly | 显示订阅墙界面（价格 $0.99/月、功能列表、订阅按钮） | `AppStore/Screenshots/InAppPurchase/` |

---

## 第十步：审核信息（左侧菜单 → "审核信息"）

| App Store Connect 字段 | 填写值 |
|----------------------|-------|
| 是否需要登录 | **否** |
| Demo 数据说明 | 不需要（Free 用户可直接使用基础功能）|
| 备注 | StretchGoGo is a stretching companion app with in-app purchase. Premium subscription ($0.99/month) unlocks all 72+ sessions, achievements, voice guidance, daily reminders, iCloud sync, and advanced statistics. No login required. |

---

## 第十一步：出口合规（左侧菜单 → "出口合规"）

| App Store Connect 问题 | 答案 |
|----------------------|------|
| 是否使用加密 | **否**（Info.plist 已配置 `ITSAppUsesNonExemptEncryption = NO`）|

---

## 第五步补充：App 隐私 → 购买行为 = 是

> ⚠️ **StretchGoGo 包含内购，隐私配置中"购买行为"必须选"是"**

**隐私政策必须包含订阅条款**。在 `docs/PrivacyPolicy.html` 中添加：

```html
<h2>In-App Purchases and Subscriptions</h2>
<p>StretchGoGo offers auto-renewing subscriptions for premium features.</p>
<ul>
<li><strong>Premium Monthly:</strong> $0.99/month</li>
<li>Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period.</li>
<li>Users can manage or cancel subscriptions via iOS Settings → Apple ID → Subscriptions.</li>
<li>No refunds for unused portions of the subscription period.</li>
</ul>
```

---

## 提交前最终检查清单

| 检查项 | 状态 | 说明 |
|--------|------|------|
| 协议 + 银行 + 税务 全部生效 | ⬜ | 才能提交内购 App |
| Bundle ID 在 Xcode 中与 App Store Connect 一致 | ✅ | com.ggsheng.StretchGoGo |
| 内购产品状态为"准备提交" | ⬜ | 需在 App Store Connect 确认 |
| App 隐私配置（购买行为=是）| ⬜ | 需在 App Store Connect 配置 |
| 隐私政策 URL 可访问 | ✅ | https://lauer3912.github.io/ios-StretchFlow/docs/PrivacyPolicy.html |
| 截图尺寸正确（1290×2796 / 1179×2556）| ⬜ | 需准备真机截图 |
| 内购审核截图已上传 | ⬜ | 显示订阅墙界面 |
| 版本号与 project.yml 一致 | ✅ | 1.0.0 |
| 出口合规 = 否 | ✅ | ITSAppUsesNonExemptEncryption = NO |

---

*本文档由 AI Agent 生成 | 如有更新请联系 Agent 修改*
*GitHub: https://github.com/lauer3912/ios-StretchFlow*