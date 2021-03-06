% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/programmazione.R
\name{load_db_temi}
\alias{load_db_temi}
\title{Carica un dataset dal database della programmazione}
\usage{
load_db_temi(ciclo, ambito, simplify_loc = FALSE)
}
\arguments{
\item{ciclo}{Ciclo di programmazione.}

\item{ambito}{Ambito di programmazione..}

\item{simplify_loc}{Logico. Vuoi semplificare le localizzazioni per compatibilità con lo standard dei Report CD?}
}
\value{
Il dataset di programmazione per l'ambito richiesto.
}
\description{
Carica il dataset richesto della programmazione, con pulizia della codifica di aree tematiche e temi prioritari FSC.
}
