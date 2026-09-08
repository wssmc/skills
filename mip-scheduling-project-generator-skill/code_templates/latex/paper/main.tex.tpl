% ============================================================
% main.tex — 论文入口
% ============================================================
\documentclass[review]{elsarticle}

\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{algorithm}
\usepackage{algorithmic}
\usepackage{booktabs}
\usepackage{hyperref}
\usepackage{multirow}

\begin{document}

\title{ {{paper_title}} }

\author[1]{ {{author1}} }
\author[2]{ {{author2}} }

\address[1]{ {{affiliation1}} }
\address[2]{ {{affiliation2}} }

\begin{abstract}
{{abstract}}
\end{abstract}

\begin{keyword}
{{keywords}}
\end{keyword}

\maketitle

\input{sections/01_introduction}
\input{sections/02_related_work}
\input{sections/03_problem_formulation}
\input{sections/04_solution_approaches}
\input{sections/05_computational_experiments}
\input{sections/06_conclusion}

% ============================================================
% 参考文献
% ============================================================
\bibliographystyle{elsarticle-num}
\bibliography{bib/references}

\end{document}