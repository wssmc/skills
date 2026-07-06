% ============================================================
% 03_problem_formulation.tex — 问题建模
% ============================================================
\section{Problem Formulation}
\label{sec:problem_formulation}

\subsection{Problem Description}

{{problem_description}}

% 示例结构：
% 1. 问题非正式描述
% 2. 调度对象定义
% 3. 资源定义
% 4. 加工流程

\subsection{Notation}

\begin{table}[h]
\centering
\caption{Notation used in the mathematical model}
\label{tab:notation}
\begin{tabular}{ll}
\toprule
Symbol & Description \\
\midrule
\multicolumn{2}{l}{\textit{Sets and indices}} \\
$J$        & Set of jobs, $J = \{1, 2, \ldots, n\}$, indexed by $i, j$ \\
$K$        & Set of stages, $K = \{1, 2, \ldots, m\}$, indexed by $k$ \\
$M_k$      & Set of machines at stage $k$, indexed by $l$ \\
\midrule
\multicolumn{2}{l}{\textit{Parameters}} \\
$n$        & Number of jobs \\
$m$        & Number of stages \\
$p_{jk}$   & Processing time of job $j$ at stage $k$ \\
$r_j$      & Release time of job $j$ \\
$d_j$      & Due date of job $j$ \\
$L$        & A sufficiently large positive constant (big-M) \\
\midrule
\multicolumn{2}{l}{\textit{Decision variables}} \\
$S_{jk}$   & Start time of job $j$ at stage $k$ \\
$C_{jk}$   & Completion time of job $j$ at stage $k$ \\
$x_{jkl}$  & 1 if job $j$ is assigned to machine $l$ at stage $k$; 0 otherwise \\
$y_{ijkl}$ & 1 if job $i$ precedes job $j$ on machine $l$ at stage $k$; 0 otherwise \\
$C_{\max}$ & Makespan \\
\bottomrule
\end{tabular}
\end{table}

\subsection{Mathematical Model}

The problem can be formulated as the following mixed-integer programming (MIP) model:

\begin{align}
\min \quad & C_{\max} \label{eq:objective} \\
\text{s.t.} \quad
& \sum_{l \in M_k} x_{jkl} = 1 && \forall j \in J,\ k \in K \label{eq:assign} \\
& C_{jk} = S_{jk} + p_{jk} && \forall j \in J,\ k \in K \label{eq:completion} \\
& S_{jk} \geq C_{j,k-1} && \forall j \in J,\ k \in K \setminus \{1\} \label{eq:precedence} \\
& S_{j1} \geq r_j && \forall j \in J \label{eq:release} \\
& S_{jk} \geq C_{ik} - L \,(3 - x_{jkl} - x_{ikl} - y_{ijkl}) && \forall i, j \in J,\ i \neq j,\ k \in K,\ l \in M_k \label{eq:disjunctive1} \\
& S_{ik} \geq C_{jk} - L \,(2 - x_{jkl} - x_{ikl} + y_{ijkl}) && \forall i, j \in J,\ i \neq j,\ k \in K,\ l \in M_k \label{eq:disjunctive2} \\
& C_{\max} \geq C_{jm} && \forall j \in J \label{eq:makespan} \\
& S_{jk}, C_{jk} \geq 0 && \forall j \in J,\ k \in K \\
& x_{jkl}, y_{ijkl} \in \{0, 1\} && \forall i, j \in J,\ k \in K,\ l \in M_k
\end{align}

\paragraph{Interpretation.}
Objective~\eqref{eq:objective} minimizes the makespan.
Constraint~\eqref{eq:assign} ensures each job is assigned to exactly one machine at each stage.
Constraint~\eqref{eq:completion} defines the completion time as start time plus processing time.
Constraint~\eqref{eq:precedence} enforces the stage precedence within a job.
Constraint~\eqref{eq:release} imposes the release time.
Constraints~\eqref{eq:disjunctive1}--\eqref{eq:disjunctive2} are the disjunctive machine no-overlap constraints (big-$L$ formulation).
Constraint~\eqref{eq:makespan} defines the makespan as the maximum completion time at the last stage.