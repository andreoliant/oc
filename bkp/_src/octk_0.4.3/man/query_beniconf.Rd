% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/peri_query.R
\name{query_beniconf}
\alias{query_beniconf}
\title{Ricerca progetti per flag beni confiscati}
\usage{
query_beniconf(progetti)
}
\arguments{
\item{progetti}{Dataset "progetti_esteso_<BIMESTRE>.csv".}
}
\value{
Un dataframe con COD_LOCALE_PROGETTO, QUERY_BENICONF.
}
\description{
Ricerca progetti per flag beni confiscati da CUP a partire da input in "qsn".
}
