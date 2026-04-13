# 快速开始

`aaa-lint` 是一系列 lint 插件,用于在测试代码中强制执行 **Arrange-Act-Assert** 模式。每个测试块必须按该顺序包含三个标记注释:`arrange`、`act`、`assert`。

```js
it('adds two numbers', () => {
  // arrange
  const a = 1
  const b = 2

  // act
  const sum = a + b

  // assert
  expect(sum).toBe(3)
})
```

## 为什么选择 AAA?

遵循 AAA 模式的测试更易阅读、更易修改。评审者能够一眼找到准备、被测操作和期望;同时这种模式也促使作者将测试保持小而聚焦。

`aaa-lint` 把这种约定变成机械化的检查,使其能够抵抗代码评审疲劳和成员更替。

## 支持的语言

| 语言 | Linter | 包 |
|---|---|---|
| JavaScript / TypeScript | [ESLint](https://eslint.org/) | [`eslint-plugin-aaa`](./eslint) |
| Ruby | [RuboCop](https://rubocop.org/) | [`rubocop-aaa`](./rubocop) |
| PHP | [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer) | [`phpcs-aaa`](./phpcs) |

三种实现共享相同的选项 (`labels`、`testFunctions`、`caseSensitive`、`allowEmptySection`),因此混用多种语言的项目也能保持一致的配置。

## 自定义标签

默认标签为英文 —— `arrange`、`act`、`assert`。你可以按照任何语言或风格来覆盖它们:

```jsonc
{
  "labels": {
    "arrange": ["given"],
    "act":     ["when"],
    "assert":  ["then"]
  }
}
```

每个部分都支持多个可接受的拼写,当团队成员写法略有不同时非常实用:

```jsonc
{
  "labels": {
    "arrange": ["准备", "前期准备"],
    "act":     ["执行"],
    "assert":  ["验证", "断言"]
  }
}
```

## 下一步

根据你的技术栈选择对应的插件并按照指南配置:

- [ESLint](./eslint)
- [RuboCop](./rubocop)
- [PHP_CodeSniffer](./phpcs)
