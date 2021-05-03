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
	\begin{tabular}{l c c 
								  d{1.2} d{1.2} c 
									d{1.2} d{1.2} 
									d{1.2} d{1.2}
									d{1.2} d{1.2} c 
									c c c}
	
		\toprule
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		&&&
		\multicolumn{2}{c}{\textbf{Treatment 1}}                                  &&
		\multicolumn{6}{c}{\textbf{Treatment 2}}                                  \\
		\cmidrule{4-5}
		\cmidrule{7-12}
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\textbf{Study}                                                            & 
		\textbf{Ref.}                                                             &&
		\multicolumn{1}{M{1.2cm}}{\textit{Market Belief s1$^\ast$}}               &
		\multicolumn{1}{M{1.2cm}}{\textit{Survey Belief s1$^\ast$}}               &&
		\multicolumn{1}{M{1.2cm}}{\textit{Market Belief s1$^\ast$}}               &
		\multicolumn{1}{M{1.2cm}}{\textit{Survey Belief s1$^\ast$}}               &
		\multicolumn{1}{M{1.2cm}}{\textit{Market Belief s2$^\dagger$}}            &
		\multicolumn{1}{M{1.2cm}}{\textit{Survey Belief s2$^\dagger$}}            &
		\multicolumn{1}{M{1.2cm}}{\textit{Market Belief s1+s2}}                   &
		\multicolumn{1}{M{1.2cm}}{\textit{Survey Belief s1+s2}}                   &&
		\multicolumn{1}{M{1.0cm}}{\textit{Rep. s1}}                               &
		\multicolumn{1}{M{1.0cm}}{\textit{Rep. s1+s2}}                            \\
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		\midrule
		\input{LaTeX/Content.tex}
		\bottomrule
	\end{tabular}
	
	\begin{tablenotes}[flushleft]
		\small
		\item $^\ast$ Belief about the probability of replicating in stage 1 
					(90\% power to detect 75\% of the original effect size).
		\item $^\dagger$ Predicted added probability of replicating in stage 2
					(90\% power to detect 50\% of the original effect size) compared
					to stage 1.
	\end{tablenotes}
		
\end{threeparttable}
\end{document}
***/
