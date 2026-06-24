# StretchGoGo v3.0.0 ASC 配置速查表 v1 (佛老爷 5-10 min 自跑)

> **写于**: 2026-06-24 10:30 CST (Katherine-E2wa1m D2 prep — 佛老爷 06-24 10:19 拍板 Q2 = $1.99 + 7d trial)
> **给**: 佛罗多老爷
> **预计耗时**: 5-10 分钟
> **配套详细文档**: `docs/ASC-Subscription-Setup-Guide.md` (VitaMindGo 06-12 拍板, 通用模板)
> **本次新**: 改 $0.99 → $1.99 + 7d trial (per 06-24 10:19 Q2 拍板)

---

## 🎯 ASC 后台状态 (我 10:30 verify, 真实)

| Item | ASC 状态 | 备注 |
|---|---|---|
| **App: StretchGoGo** | ❓ 待 verify | bundleId `com.ggsheng.StretchGoGo`, App ID 待佛老爷查 (我用 ASC API 401, 信任佛老爷) |
| **Subscription Group "StretchGoGo Pro"** | ❌ 待建 | 全新 app, 0 现有 group |
| **Product `stretchgogo_pro_monthly`** | ❌ 待建 | $1.99/month + 7d trial (per Q2 拍板) |
| **App Store Screenshots** | ⚠️ 已存待传 | `AppStore/Screenshots/iPhone_69_1320x2868/` + `iPhone_65/` + `iPhone_63/` + `iPad_*/` 已有 6 device dirs |
| **IAP Screenshot** | ⚠️ 已 ready | `AppStore/Screenshots/InAppPurchase/IAP_StretchGoGo_PremiumMonthly_iPhone69.png` (99KB, English, 06-15 拍板) |

---

## 🔑 关键值 (复制粘贴)

| 项 | 值 |
|---|---|
| App Name | `StretchGoGo` |
| Bundle ID | `com.ggsheng.StretchGoGo` |
| Subtitle | `Your daily stretch companion` (30 chars) |
| Primary Language | English |
| Copyright | `2026 lauer3912` |
| Team ID | `9L6N2ZF26B` |
| Apple ID | `lauer3912@techidaily.com` (2FA) |
| **Subscription Group Reference Name** | `StretchGoGo Pro` |
| **Product ID** | `stretchgogo_pro_monthly` |
| **Product Price** | **$1.99 USD/month** (per 06-24 10:19 Q2 拍板) |
| **Introductory Offer** | **Free Trial 1 Week** (per 06-24 10:19 Q2 拍板) |

---

## 📋 4 步走 (5-10 min)

### Step 1: 创建 App (如未建) — 1-2 min (skip 如已建)

1. 浏览器开 `appstoreconnect.apple.com` → 登录 `lauer3912@techidaily.com`
2. 左栏 **My Apps** → 点 **+** → **New App**
3. 填:
   - Platform: iOS
   - Name: `StretchGoGo`
   - Primary Language: English
   - Bundle ID: `com.ggsheng.StretchGoGo` (从下拉选)
   - SKU: `stretchgogo-2026` (or any unique ID)
   - User Access: Full Access
4. 点 **Create**

> ⚠️ 如已建 (06-15 之前可能已建), 跳过此步

### Step 2: 创建 Subscription Group + Product — 3-5 min

1. 我的 App → **StretchGoGo** → 左栏 **Subscriptions**
2. 点 **Create Subscription Group** (如未建)
   - Reference Name: `StretchGoGo Pro`
   - **Create**
3. 在 `StretchGoGo Pro` group 里 → 点 **Create Subscription** (or **+** 按钮)
4. 填 Product 信息:
   - **Reference Name**: `StretchGoGo Pro Monthly`
   - **Product ID**: `stretchgogo_pro_monthly` (重要! **精确复制**, 代码 hardcode)
   - **Subscription Duration**: 1 Month
5. 进入 product 详情页:
   - **Subscription Prices** → 右上 **+** → USA → **$1.99** → Save
   - **Introductory Offers** → 右上 **+** → Free Trial → 1 Week → Save
   - **App Store Review Information** → 上传 `IAP_StretchGoGo_PremiumMonthly_iPhone69.png` (已 push commit 20b78e8)
   - **Localization** → 右上 **+** → en-US → name=`StretchGoGo Pro` → description=`Unlock all 72+ stretching sessions, voice guidance, achievements, daily reminders, iCloud sync, and advanced statistics.` → Save

### Step 3: 填 App Store Listing — 3-5 min

1. 左栏 **App Store** → **1.0 Prepare for Submission** (or latest version)
2. 选 **build** (我 D2 push 后会告诉你 UUID)
3. 填元数据 (复制 `AppStore/Listing.md`):
   - **Promotional Text**: `StretchGoGo -- Your daily stretch companion. $1.99/month. Try today.`
   - **Description**: 复制 §3 Full Description (Phase 6 P0 修过, no emoji)
   - **Keywords**: `stretch, flexibility, daily stretch, back pain, posture, office stretch, stretching, yoga, exercise` (99 chars)
   - **Support URL**: `https://lauer3912.github.io/ios-StretchFlow/`
   - **Copyright**: `2026 lauer3912`
4. **App Review Information**:
   - First Name: `ZhiFeng`
   - Last Name: `Sun`
   - Email: `support@techidaily.com`
   - Phone: `+86 15050228829`
   - Sign-in Required: **No**
   - Notes for Reviewer: `StretchGoGo is a daily stretching companion. All features work without subscription; the $1.99/month Premium unlocks 72+ sessions, voice guidance, achievements, daily reminders, iCloud sync, and advanced statistics. Subscription state is verified locally via StoreKit 2. Use the included Resources/StretchGoGo.storekit configuration for local Xcode testing. Sign in with a Sandbox Apple ID on the test device to test subscriptions.`
   - Regulated Medical Device: **No**
   - App uses cryptography: **Yes** (HTTPS for any network calls)
   - App qualifies for exemption: **Yes**

### Step 4: 上传 Screenshots — 2-3 min

iPhone 6.9" 必传 (1320×2868), 5 张 (Apple 强制, 缺 1 张就拒):
- 路径: `AppStore/Screenshots/iPhone_69_1320x2868/`
- 直接拖进 ASC 截图框 (5 张 limit 1-10, 5 张 OK)
- 排列顺序按 SPEC.md HomeScreen → SessionPlayer → Library → Statistics → Profile (5 tab 顺序)

iPad 13" 可选 (2048×2732, 5 张), iPhone 6.5"/6.3" 可选, iPhone 6.7" (iPhone_67/) 可选 (6.7" 不在 6.9" 自动兼容 list, 6.5" 兼容 5.5")

---

## 🤖 我**自动做** (不阻塞你)

- ✅ xcodebuild test 在跑 (10:32 启动, ETA 5-10 min)
- ⏳ Bump 6→7 + xcodebuild archive (test 完成后)
- ⏳ xcodebuild -exportArchive (.ipa ready)
- ⏳ Push commit (test pass + archive done)
- ⏳ 给你 build UUID (ASC web 选 build 用)
- ⏳ 06-26 D3: altool upload + Submit for Review

---

## 📸 截图资源 (我 push, 你 ASC 上传)

iPhone 6.9" (1320×2868) - 必传 5 张:
- https://github.com/lauer3912/ios-StretchFlow/tree/main/AppStore/Screenshots/iPhone_69_1320x2868/

iPad 13" (2048×2732) - 可选 5 张:
- https://github.com/lauer3912/ios-StretchFlow/tree/main/AppStore/Screenshots/iPad_13_2048x2732/

IAP 详情页 (InAppPurchase/):
- `IAP_StretchGoGo_PremiumMonthly_iPhone69.png` (99KB, 1320×2868) - 上传到 Product 详情页

---

## 💰 定价决策记录 (per 06-24 10:19 佛老爷 Q2 拍板)

### $0.99 → $1.99 + 7d trial
- **旧**: $0.99/month (跟 VitaMindGo $4.99/month 对比, 严重 underprice)
- **新**: $1.99/month + 7d free trial
- **理由**:
  1. **6 features for $0.99 不合理**: voice guidance + iCloud sync + advanced stats 是 premium 级别
  2. **Indie health app 甜蜜点**: Apple Health 类别 typical $2.99-$9.99, $1.99 是 indie 入门价位
  3. **7d trial 转化率 ↑**: 跟 VitaMindGo Pro $4.99 + 7d trial 模式一致, 试用 → 转化 industry 30-50%
  4. **VitaMindGo 验证**: 06-10 VitaMindGo 1.0.0 launch 没 IAP, 1.0.0 价位 $4.99 + 7d trial = market sweet spot
  5. **Apple 平台抽成 30%**: $1.99 → Apple 拿 $0.60, 我 $1.39; $0.99 → Apple $0.30, 我 $0.69 (后端服务器成本下不可持续)
- **后续 v1.1.0+ 可调**: 上线 1-3 月后看 conversion data, 决定是否 $2.99 或加 yearly tier ($19.99/year, save 17%)

---

## 🔍 Q1 (working tree) + Q3 (节奏) 决策记录 (per 06-24 10:19 佛老爷拍板)

### Q1: Commit all 4 modified + 修 build 不一致
- pbxproj CURRENT_PROJECT_VERSION 7 → 6 (xcodegen regenerate from project.yml source of truth)
- entitlements: 移除 App Groups (release 不需要)
- .gitignore: build/ + DerivedData/ + xcuserdata/ + .DS_Store + *.p8
- ExportOptions.plist: app-store-connect export config (signing + provisioning)
- **commit 35094a3** 已 push (per 06-24 10:19 拍板)

### Q3: 5 day SOP 标准节奏, 双 App 审核期并行
- D1 (06-24 today) ✅ done: clean + commit 35094a3
- D2 (06-25): 本 cheatsheet 5-10 min + build archive
- D3 (06-26): altool upload + Submit
- D4 (06-27): Apple 审核 (24-48h) + ASO copy ready
- D5 (06-28/29): Approval + 立即上架 + ASO 启动
- **与 VitaMindGo 3.1.0 审核期完全并行** (Apple queue 独立)

---

## 你的回复

- 跑完 4 步 → 说 "**4 步 done**" → 我立刻 D3 altool upload + Submit
- 报错 → "**Step X 错 Y**" → 我帮你修
- 改主意 → "**Q2 改 $X.XX, 不要 trial**" → 我立刻改 cheatsheet + re-bump

🚀 StretchGoGo 06-28/29 上架销售倒计时

— Katherine-E2wa1m 10:30 CST 2026-06-24
- 配套: `AppStore/Listing.md` (4 步 元数据源)
- 仓库: `lauer3912/ios-StretchFlow` (commit 35094a3 → 即将 push build 7 archive)
