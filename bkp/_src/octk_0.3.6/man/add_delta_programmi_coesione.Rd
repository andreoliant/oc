% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coesione.R
\name{add_delta_programmi_coesione}
\alias{add_delta_programmi_coesione}
\title{Integra report per Programmi con delta da un bimestre precedente (per coesione)}
\usage{
add_delta_programmi_coesione(
  bimestre,
  programmi,
  last_bimestre,
  last_data_path,
  usa_meuro = FALSE,
  focus = "delta",
  export = FALSE
)
}
\arguments{
\item{bimestre}{Bimestre di riferimento (in formato OC tipo "20181231").}

\item{programmi}{Dataset generato con make_report_programmi().}

\item{last_bimestre}{Bimestre con cui effettuare il confronto (in formato OC tipo "20181231").}

\item{usa_meuro}{Vuoi i dati in Meuro? Di default sono in euro.}

\item{focus}{nome per file.}

\item{export}{vuoi salvare il file?}
}
\value{
Un file csv con apertura per programma, fase procedurale e bimestre.
}
\description{
Integra il report da make_report_programmi() con il confronto con il bimestre indicato.
}
\note{
DA COMPLETARE
}
