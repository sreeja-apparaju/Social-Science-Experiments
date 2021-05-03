texdoc init "$file_name.tex", replace

/***
\documentclass{standalone}

\usepackage{array}
\usepackage{booktabs}
\usepackage{threeparttable}
\usepackage{multirow}
\renewcommand{\arraystretch}{1.2}

\usepackage{dcolumn}
\newcolumntype{d}[1]{D{.}{.}{#1}}
\newcolumntype{M}[1]{>{\centering\arraybackslash}m{#1}}


\begin{document}
	\begin{tabular}{l *{15}{c}}
	
		\toprule
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\textbf{\textit{Variable}}                                                & 
		\multicolumn{1}{M{2.2cm}}{Replicated $p < 0.05$}                          &
		\multicolumn{1}{M{2.2cm}}{Meta Estimate $p < 0.05$}                       &
		\multicolumn{1}{M{2.2cm}}{Small Telescope Approach}                       &
		\multicolumn{1}{M{2.2cm}}{Replication with 95\% PI}                       &
		\multicolumn{1}{M{2.2cm}}{Relative Effect Size}                           &
		\multicolumn{1}{M{2.2cm}}{Default Bayes Factor}                           &
		\multicolumn{1}{M{2.2cm}}{Replication Bayes Factor}                       &
		\multicolumn{1}{M{2.2cm}}{Market Belief (Treatment 1)}                    &
		\multicolumn{1}{M{2.2cm}}{Market Belief (Treatment 2)}                    &
		\multicolumn{1}{M{2.2cm}}{Survey Belief (Treatment 1)}                    &
		\multicolumn{1}{M{2.2cm}}{Survey Belief (Treatment 2)}                    &
		\multicolumn{1}{M{2.2cm}}{Original $p$-Value}                             &
		\multicolumn{1}{M{2.4cm}}{Original No. of Observations}                   &
		\multicolumn{1}{M{2.4cm}}{Original No. of Participants}                   \\
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		\midrule
		\input{LaTeX/Content.tex}
		\bottomrule
	\end{tabular}
\end{document}
***/
