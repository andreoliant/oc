% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gets.R
\name{get_x_vars}
\alias{get_x_vars}
\title{Aggiunge variabili "X" di riflassificazione dei PO}
\usage{
get_x_vars(df, debug_mode = FALSE, progetti = NULL)
}
\arguments{
\item{df}{Dataset in formato "progetti".}

\item{progetti}{Dataset "progetti".}
}
\value{
Il dataset con le variabili "X", rettificate dove necessario rispetto alla BDU, ovvero:
x_CICLO: ciclo di programmazione
x_AMBITO: ambito di programmazione
x_GRUPPO: gruppo/tipologia di programmi
x_PROGRAMMA: denominazione
x_REGNAZ: utility per distinguere se regionale (con indicazione della Regione) o nazionale
}
\description{
Aggiunge variabili "X" di riflassificazione dei PO per compatibilità con il DB Programmazione.
}
\note{
La modalità **debug** non è implementata.
}
