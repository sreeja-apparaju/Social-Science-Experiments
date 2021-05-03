texdoc init "$file_name.tex", replace

/***
\documentclass{standalone}

\usepackage{array}
\usepackage{booktabs}
\usepackage{threeparttable}
\renewcommand{\arraystretch}{1.2}

\usepackage{dcolumn}
\newcolumntype{d}[1]{D{.}{.}{#1}}
\newcolumntype{M}[1]{>{\centering\arraybackslash}m{#1}}


\begin{document}
\begin{threeparttable}
	\begin{tabular}{l c 
								  d{1.3} d{1.3} r @{\hspace{0.5em}}r c 
									d{1.3} d{1.3} r @{\hspace{0.5em}}r c 
									c d{1.3} d{1.3}}
	
		\toprule
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		&&
		\multicolumn{4}{c}{\textbf{Original Study}}                               &&
		\multicolumn{4}{c}{\textbf{Replication Stage 1}}                          \\
		\cmidrule{3-6}
		\cmidrule{8-11}
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\textbf{Study}                                                            &&
		\multicolumn{1}{M{1.5cm}}{\textbf{Effect Size (\textit{r})}}              &
		\multicolumn{1}{M{1.5cm}}{\textbf{\textit{p}-Value}}                      &
		\multicolumn{2}{c}       {\textbf{\textit{N}$^\ast$}}                     &&
		\multicolumn{1}{M{1.5cm}}{\textbf{Effect Size (\textit{r})}}              &
		\multicolumn{1}{M{1.5cm}}{\textbf{\textit{p}-Value}}                      &
		\multicolumn{2}{c}       {\textbf{\textit{N}$^\ast$}}                     &&
		\multicolumn{1}{M{1.2cm}}{\textbf{Rep.$^\dagger$}}                        &
		\multicolumn{1}{M{1.2cm}}{\textbf{Stat. Power$^\ddagger$}}                &
		\multicolumn{1}{M{2.0cm}}{\textbf{Relative Effect Size$^\S$}}             \\
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		\midrule
		\input{LaTeX/Content.tex}
		\bottomrule
	\end{tabular}
	
	\begin{tablenotes}[flushleft]
		\small
		\item $^\ast$\      Number of observations; 
												number of individuals provided in parenthesis.
		\item $^\dagger$\ 	Replicated; significant effect ($p < 0.05$) in
												the same direction as in original study.
		\item $^\ddagger$\	Statistical power to detect 75\% of the original
												effect size $r$.
		\item $^\S$\  			Relative standardized effect size.
	\end{tablenotes}
		
\end{threeparttable}
\end{document}
***/
