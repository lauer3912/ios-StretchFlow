# App Store 审核拒绝处理实战手册

> 来源：StretchGoGo 3.1.0（Build 17）审核修复
> 最近验证：2026-08-08（已确认审核通过）

## 案例：自动续订缺少 EULA 链接

Apple 自动拒绝信息：

> The submission offers auto-renewable subscriptions but does not include a functional link to the Terms of Use (EULA) in the app's metadata.

对应条款：Guideline 3.1.2 — Business — Payments — Subscriptions。

### 根因

App 内购买页虽然已有 Terms of Use 链接，但 App Store Connect 的英文 App Description 没有功能性 EULA URL。Apple 检查的是商店元数据，因此仅修改 App 内界面不能解决该拒绝。

### 正确修复

在每个包含订阅信息的 App Description 本地化版本末尾加入：

```text
Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
Privacy Policy: https://lauer3912.github.io/ios-StretchFlow/PrivacyPolicy.html
```

使用 Apple 标准 EULA 时必须使用上面的 Apple URL；使用自定义 EULA 时，应在 App Store Connect 的 License Agreement 中配置。

### 提交流程

1. 阅读 Apple 原始拒绝信息，不只依赖 API 中的 `REJECTED` 状态。
2. 判断问题属于代码、构建、IAP 配置还是元数据。
3. 在 App Store Connect 更新英文 App Description。
4. 保存后确认“保存”按钮恢复禁用，且重新打开字段仍含 EULA URL。
5. 点击“更新审核”。
6. 确认版本状态变为“可供审核”。
7. 点击“重新提交至 App 审核”。
8. 最终确认状态为“等待审核”。

本案例是纯元数据问题，继续使用原 Build 17，无需重新 Archive 或上传新 Build。

## 决策规则：是否需要新 Build

| 问题类型 | 是否需要新 Build | 处理方式 |
|---|---:|---|
| App Description、关键词、URL、审核备注缺失 | 否 | 修改元数据并重新提交 |
| IAP 审核截图或订阅产品元数据缺失 | 通常否 | 修复 IAP/订阅配置并随版本提交 |
| App 内链接缺失、购买流程错误、崩溃 | 是 | 修改代码、测试、上传新 Build |
| 隐私政策 URL 返回 404 | 通常否 | 修复部署或改为有效 URL |
| Info.plist、Entitlements、权限说明错误 | 是 | 修改工程并上传新 Build |

## URL 验证

不要根据仓库路径推测 GitHub Pages URL。提交前必须验证最终线上地址：

```bash
for url in \
  "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/" \
  "https://lauer3912.github.io/ios-StretchFlow/PrivacyPolicy.html" \
  "https://lauer3912.github.io/ios-StretchFlow/TermsOfService.html"
do
  curl -L -s -o /dev/null -w '%{http_code} %{url_effective}\n' "$url"
done
```

验收标准：最终响应为 HTTP 200，且没有跳转到登录页、错误页或无关页面。

## 提交前订阅检查清单

- [ ] App Description 含完整、可点击的 EULA URL
- [ ] Privacy Policy URL 返回 HTTP 200
- [ ] App 内订阅墙可访问 Terms of Use 与 Privacy Policy
- [ ] 订阅周期、价格和试用期与 App Store Connect 一致
- [ ] Restore Purchases 可用
- [ ] 所有待审核订阅产品已包含在提交中
- [ ] 保存后重新读取元数据，确认内容已落库
- [ ] 重新提交后状态明确显示“等待审核”

## 本次修复结果

- App：StretchGoGo 3.1.0（Build 17）
- 提交 ID：`fdf86f6d-3da3-4d46-9cf0-db46bf6faff0`
- 修复：英文 App Description 增加 Apple 标准 EULA 和有效隐私政策 URL
- 重新提交时间：2026-07-30 08:58（Asia/Shanghai）
- 重新提交后的状态：等待审核
- 最终结果：审核通过
