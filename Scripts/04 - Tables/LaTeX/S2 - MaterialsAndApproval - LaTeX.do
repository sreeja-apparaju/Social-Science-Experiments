texdoc init "$file_name.tex", replace

/***
\documentclass{standalone}

\usepackage{pifont}
\usepackage{array}
\usepackage{booktabs}
\usepackage{threeparttable}
\renewcommand{\arraystretch}{1.2}

\usepackage{dcolumn}
\newcolumntype{M}[1]{>{\centering\arraybackslash}m{#1}}

\usepackage{color}
\definecolor{ssrp_b}{RGB}{68,118,133}
\definecolor{ssrp_o}{RGB}{252,192,96}
\definecolor{ssrp_g}{RGB}{160,160,160}

\newcommand{\yes}{\textcolor{ssrp_b}{\textbf{\ding{51}}}}
\newcommand{\no} {\textcolor{ssrp_o}{\textbf{\ding{55}}}}
\newcommand{\na} {\textcolor{ssrp_g}{$\mathbf{\circ}$}}

\begin{document}
\begin{threeparttable}
	\begin{tabular}{l M{4cm} M{4cm} M{4cm}}
		\toprule
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\textbf{Study}                                                            &		
		\textbf{Authors Shared Materials}                                         &
		\textbf{Replication Used Original Software}$^\dag$                        &
		\textbf{Authors Approved Replication Plan}                                \\
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		\midrule
		\input{LaTeX/Content.tex}
		\bottomrule
	\end{tabular}
	
	\begin{tablenotes}[flushleft]
		\small
		\item 	\textit{Notes:} \ding{51} indicates ``yes'', \ding{55} 
				indicates ``no'', and $\circ$ denotes ``not applicable''.
		\item 	$^\dag$ See section 1.2 in the Supplementary Information 
				for details about when the original software was not used.
		\item 	$^\ast$ The original authors did not respond to our requests 
				for materials and feedback on the replication report, prior 
				to conducting the replication.
	\end{tablenotes}
\end{threeparttable}
\end{document}
***/
