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
	\begin{tabular}{l p{16cm}}
	
		\toprule
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\textbf{Study}                                                            & 
		\textbf{Hypothesis}                                                       \\
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		\midrule
		\input{LaTeX/Content.tex}
		\bottomrule
	\end{tabular}
\end{document}
***/
