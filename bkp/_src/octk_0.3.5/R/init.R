# OC > Toolkit
# Setup

#' Inizializza OCTK
#'
#' Definisce i puntamenti ai folder di lavoro e ai dati.
#'
#' @param bimestre Versione dei dati di attuazione da utilizzare. Stringa in formato "20180630" come da standard per le date in OC.
#' @param db_ver  Versione dei dati di programmazione da utilizzare. Stringa in formato "20180630" come da standard per le date in OC.
#' @param data_path Percorso allla fonte dati.
#' @param db_path Percorso al bd di programmazione.
#' @param workarea Percorso per la cartella di lavoro. Se vuoto, va di default nella wd.
#' @param elab Nome della cartella dedicata al tipo di elebaorazione (solo con use_drive=TRUE)
#' @param focus Nome della sotto-cartella dedicata all'elebaorazione (solo con use_drive=TRUE). Il nome viene usato anche nel naming dei file in output.
#' @param ver Nome della sotto-sotto-cartella dedicata alla versione dell'elebaorazione (solo con use_drive=TRUE).
#' @param use_drive Logico. Vuoi usare GoogleDrive?
#' @param drive_root Percorso per la cartella di lavoro su GoogleDrive.
#' @param DEV_MODE Logico. Vuoi usare la DEV_MODE?
#' @return I path della workarea (WORK, con INPUT, OUTPUT e TEMP), dei dati di attuazione (DATA)
#' e del database di programmazione (DB) sono disponibili nel Global Environment. Se non esistono, vengono creati i folder
#' "input", "output" e "temp" nella workarea di progetto denominata come "focus" all'interno di "...".
oc_init <- function(bimestre, db_ver,
                    data_path=NULL, db_path=NULL,
                    workarea=NULL, elab=NULL, focus=NULL, ver=NULL,
                    use_drive=TRUE, drive_root=NULL,
                    DEV_MODE=FALSE) {

  # libs
  library("tidyverse")
  library("haven")
  library("readxl")
  library("openxlsx")

  # TODO: inserire gestione per bimestre e db_ver (ricerca di last)
  # if (!exists("bimestre")) {
  #   bimestre <- list.files(data_path) %>%
  #     as.numeric() %>%
  #     max() %>%
  #     as.character()
  #   # MEMO: si aggiorna da solo con nuovo bimestre
  # }

  # wizard dati attuazione
  if (is.null(data_path)) {
    appo <- readline("Quale path per la fonte dati? ")
    data_path <- gsub("\\\"", "", appo)
  }
  # OLD: DATA <<- file.path(data_path, bimestre) # MEMO: versione prima di GoogleDrive

  # wizard db programmazione
  # if (is.null(db_path)) {
  #   appo <- readline("Quale path per il db di programmazione? ")
  #   db_path <- gsub("\\\"", "", appo)
  # }

  # switch
  if (use_drive == TRUE) {
    message("GoogleDrive in uso")
    if (is.null(drive_root)) {
      ROOT <- "/Volumes/GoogleDrive/Drive condivisi"
      # TODO: inserire switch e default per mac/win
    } else {
      ROOT <- drive_root
    }
    # data_path <- file.path(ROOT, "DATI", bimestre, "DASAS", "DATAMART")
    # db_path <- file.path(ROOT, "DATI", bimestre, "PROGRAMMAZIONE", db_ver)
    db_path <- file.path(ROOT, "DATI", "PROGRAMMAZIONE", db_ver)

    # switch per naming
    if (is.null(elab) & is.null(focus)) {
      if (DEV_MODE == TRUE) {
        WORK <- file.path(getwd(), "test")
        focus <- "test"
        message("La DEV_MODE è attiva! La workarea è in locale in oc/test ma i dati sono in GoogleDrive")
      } else {
        WORK <- file.path(getwd())
        temp <- stringr::str_split(getwd(), .Platform$file.sep)[[1]]
        focus <<- temp[length(temp)]
      }

    } else {
      if (!is.null(ver)) {
        WORK <- file.path(ROOT, "ELAB", bimestre, elab, focus, ver)
        # MEMO: si applica solo in Drive

      } else {
        WORK <- file.path(ROOT, "ELAB", bimestre, elab, focus)
      }
    }

  # go local
  } else {
    message("Lavoro in locale")

    # # wizard dati attuazione
    # if (is.null(data_path)) {
    #   appo <- readline("Quale path per la fonte dati? ")
    #   data_path <- gsub("\\\"", "", appo)
    # }
    # # OLD: DATA <<- file.path(data_path, bimestre) # MEMO: versione prima di GoogleDrive

    # wizard db programmazione
    if (is.null(db_path)) {
      appo <- readline("Quale path per il db di programmazione? ")
      db_path <- gsub("\\\"", "", appo)
    }

    # switch per naming
    if (is.null(workarea)) {
      if (is.null(elab) & is.null(focus)) {
        if (DEV_MODE == TRUE) {
          WORK <- file.path(getwd(), "test")
          message("La DEV_MODE è attiva! La workarea è in oc/test")
          focus <- "test"
        } else {
          WORK <- file.path(getwd())
          temp <- stringr::str_split(getwd(), .Platform$file.sep)[[1]]
          focus <<- temp[length(temp)]
        }
      } else {
        # WORK <- file.path(getwd(), elab, focus)
        if (!is.null(ver)) {
          WORK <- file.path(getwd(), elab, focus, ver)
          # MEMO: si applica solo in Drive

        } else {
          WORK <- file.path(getwd(), elab, focus)
        }

      }
    } else {
      WORK <- workarea
    }
  }

  # export path in GlobalEnv
  # DATA <<- file.path(data_path)
  DATA <<- file.path(data_path, bimestre) # MEMO: versione per dati in locale
  message(paste0("Connetto la fonte dati in ", DATA))

  DB <<- file.path(db_path)
  message(paste0("Connetto il db di programmazione in ", DB))

  INPUT <<- file.path(WORK, "input")
  if (!dir.exists(INPUT)) {
    message(paste0("Creo e connetto il folder INPUT in ", INPUT))
    dir.create(INPUT, recursive = TRUE)
  } else {
    message(paste0("Connetto il folder INPUT in ", INPUT))
  }

  TEMP <<- file.path(WORK, "temp")
  if (!dir.exists(TEMP)) {
    message(paste0("Creo e connetto il folder TEMP in ", TEMP))
    dir.create(TEMP, recursive = TRUE)
  } else {
    message(paste0("Connetto il folder TEMP in ", TEMP))
  }

  OUTPUT <<- file.path(WORK, "output")
  if (!dir.exists(OUTPUT)) {
    message(paste0("Creo e connetto il folder OUTPUT in ", OUTPUT))
    dir.create(OUTPUT, recursive = TRUE)
  } else {
    message(paste0("Connetto il folder OUTPUT in ", OUTPUT))
  }

  # export workarea
  WORK <<- WORK

  # export focus (per naming)
  focus <<- focus

  # export bimestre (per naming)
  bimestre <<- bimestre
}

#' Copia i dati di OC da GoogleDrive
#'
#' Copia i dati di OC da GoogleDrive.
#'
#' @param bimestre Versione dei dati di attuazione da utilizzare. Stringa in formato "20180630" come da standard per le date in OC.
#' @param data_path Percorso allla fonte dati (senza folder del bimestre).
#' @return I file di "progetti_preesteso" sono copiati nel folder DATA.
oc_init_data <- function(bimestre, data_path=NULL) {

  # finanziamenti_preesteso.sas7bdat
  # indicatori_pucok.sas7bdat
  # operazioni_pucok.sas7bdat
  # PROGETTI_PREESTESO.csv
  # PROGETTI_PREESTESO.zip

  ROOT <- "/Volumes/GoogleDrive/Drive condivisi"

  # wizard dati attuazione
  if (is.null(data_path)) {
    appo <- readline("Quale path per la fonte dati? ")
    data_path <- gsub("\\\"", "", appo)
  }

  DATA <- file.path(data_path, bimestre)

  file.copy(from = file.path(ROOT, "DATI", bimestre, "DASAS", "DATAMART", "PROGETTI_PREESTESO.zip"),
            to = file.path(DATA, "PROGETTI_PREESTESO.zip"))
  unzip(zipfile = file.path(DATA, "PROGETTI_PREESTESO.zip"),
        exdir = file.path(DATA))

  file.copy(from = file.path(ROOT, "DATI", bimestre, "DASAS", "DATAMART", "finanziamenti_preesteso.sas7bdat"),
            to = file.path(DATA, "finanziamenti_preesteso.sas7bdat"))

  file.copy(from = file.path(ROOT, "DATI", bimestre, "DASAS", "DATAMART", "indicatori_pucok.sas7bdat"),
            to = file.path(DATA, "indicatori_pucok.sas7bdat"))

  file.copy(from = file.path(ROOT, "DATI", bimestre, "DASAS", "DATAMART", "operazioni_pucok.sas7bdat"),
            to = file.path(DATA, "operazioni_pucok.sas7bdat"))

}

