% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/peri_query.R
\name{query_cup}
\alias{query_cup}
\title{Ricerca progetti per categoria CUP}
\usage{
query_cup(progetti)
}
\arguments{
\item{progetti}{Dataset "progetti_esteso_<BIMESTRE>.csv".}
}
\value{
Un dataframe con COD_LOCALE_PROGETTO, QUERY_CUP.
}
\description{
Ricerca progetti per settore, sotto-settore e categoria CUP a partire da input in "categorie_cup.csv".
}
