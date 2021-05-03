texdoc init "$file_name.tex", replace

/***
\documentclass{standalone}

\usepackage{array}
\usepackage{booktabs}
\renewcommand{\arraystretch}{1.2}

\usepackage[utf8]{inputenc}
\usepackage[T1]  {fontenc}
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{amssymb}


\begin{document}
	\begin{tabular}{l c p{15cm}}
	
		\toprule
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\textbf{Study}                                                            & 
		\textbf{Ref.}                                                             &
		\textbf{Hypothesis}                                                       \\
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		\midrule
		\input{LaTeX/Content.tex}
		\bottomrule
	\end{tabular}
\end{document}
***/

