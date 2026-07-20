# 约束规范

## 1. 阶段顺序约束
每个作业必须按 Stage_0 → Stage_1 → ... → Stage_{M-1} 顺序加工。

数学描述:
```
S[j, s] >= C[j, s-1],  ∀ j, s > 0
```

## 2. 机器非重叠约束
同一阶段同一机器上，任意两个作业的加工时间不重叠。

数学描述:
```
S[j, s] >= C[i, s]  OR  S[i, s] >= C[j, s],  ∀ i < j, 同一机器 m
```

## 3. 机器分配约束
每个作业在每个阶段必须分配给一台机器。

数学描述:
```
Σ_m x[j, s, m] = 1,  ∀ j, s
```

## 4. 完工时间定义
```
C[j, s] = S[j, s] + p[j, s]
```

## 5. 释放时间约束
```
S[j, 0] >= release_time[j],  ∀ j
```

## 6. 交期与延迟（可选）
```
T[j] = max(0, C[j, M-1] - due_date[j])
```

## 7. makespan 定义
```
Cmax >= C[j, s],  ∀ j, s
```

## 8. 可选约束
以下任一项存在时，基础模板状态必须为 `adapter_required`，直至数据、领域模型、decoder、checker、MIP 与回归测试全部更新：

- [ ] 换线时间 (setup time)
- [ ] 运输时间 (transport time)
- [ ] 人力资源约束 (worker resource)
- [ ] 机器维护窗口 (maintenance window)
- [ ] 批处理约束 (batch capacity)
