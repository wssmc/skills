# 输出质量检查清单

生成项目后必须检查：

## 数据

- [ ] 主体数据保存为 txt；
- [ ] index.json 能正确索引 txt；
- [ ] demo_data 可人工检查；
- [ ] data_small / data_large 可复现；
- [ ] 随机生成支持 seed。

## MIP

- [ ] 默认使用 CPLEX / docplex；
- [ ] 可设置 time_limit；
- [ ] 可设置 mip_gap；
- [ ] 能输出 status、objective、runtime；
- [ ] 能提取为统一 Schedule。

## 解码

- [ ] 满足 Stage precedence；
- [ ] 满足 machine no-overlap；
- [ ] 满足 release time；
- [ ] 可扩展 transport / worker resource；
- [ ] 输出统一 Schedule。

## 评价

- [ ] 重新计算 makespan；
- [ ] 重新计算 total tardiness；
- [ ] 检查机器冲突；
- [ ] 检查工序顺序；
- [ ] 计算 gap_to_mip。

## 工程

- [ ] src 已按模块分类；
- [ ] baseline 和 proposed 分开；
- [ ] tests 存在；
- [ ] README 含运行命令；
- [ ] 输出目录自动创建。
