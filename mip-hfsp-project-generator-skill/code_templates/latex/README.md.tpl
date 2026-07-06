# latex/ — 论文写作目录

## 目录结构

```
latex/
├── paper/
│   ├── main.tex                       # 正式论文入口，引用所有 sections
│   ├── sections/
│   │   ├── 01_introduction.tex        # 引言
│   │   ├── 02_related_work.tex        # 相关工作
│   │   ├── 03_problem_formulation.tex # 问题建模
│   │   ├── 04_solution_approaches.tex # 求解方法
│   │   ├── 05_computational_experiments.tex # 实验分析
│   │   └── 06_conclusion.tex          # 结论
│   ├── figures/                       # 甘特图、网络图、算法框架图
│   ├── tables/                        # 实验结果表、参数表
│   ├── algorithms/                    # 伪代码（GA, SA, IG, 本文算法等）
│   ├── bib/
│   │   └── references.bib             # 参考文献
│   └── appendices/                    # MIP 模型、补充实验、参数表
├── templates/
│   └── els-cas-templates/             # 期刊模板原文件（不混入正文工程）
└── README.md
```

## 写作流程

1. 使用 `literature-matrix-review-skill-v2.1` 生成两类文献矩阵
2. 调用 `thirdPartSkills.md` 中的写作 Skill 生成 01-03 初稿
3. 手动撰写 04-06
4. 整理实验结果放入 `figures/` 和 `tables/`
5. 编译 `main.tex` 生成 PDF

## 编译命令

```bash
cd latex/paper
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```