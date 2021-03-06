% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_cd.R
\name{report_cd_regioni_sintesi}
\alias{report_cd_regioni_sintesi}
\title{Report con sintesi per regione (formato CD)}
\usage{
report_cd_regioni_sintesi(
  perimetro,
  use_coe = TRUE,
  export = FALSE,
  focus = NULL,
  ciclo = NULL
)
}
\arguments{
\item{perimetro}{Dataset di classe perimetro.}

\item{export}{vuoi salvare un csv?}

\item{focus}{nome per file (se @export == TRUE).}

\item{ciclo}{in formato x_CICLO.}
}
\value{
Un file csv con apertura per regione e ambito
}
\description{
Report di sintesi con apertura per regione e ambito di progammazione
}
