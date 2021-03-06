# Programmazione

#' Carica un dataset dal database della programmazione
#'
#' Carica il datase richiesto dal dataset della programmazione.
#'
#' @param ciclo Ciclo di programmazione.
#' @param ambito Ambito di programmazione..
#' @param simplify_loc Logico. Vuoi semplificare le localizzazioni per compatibilità con lo standard dei Report CD?
#' @param use_temi Logico. Vuoi avere anche i temi prioritari FSC?
#' @param use_sog Logico. Vuoi avere anche il soggetto programmatore?
#' @param use_eu Logico. Vuoi avere anche il finanziamento EU e categoria di regione? (solo per SIE)
#' @return Il dataset di programmazione per l'ambito richiesto, con pulizia delle denominazioni territoriali e
#' della codifica di aree tematiche e temi prioritari FSC.
load_db <- function(ciclo, ambito, simplify_loc=FALSE, use_temi=FALSE, use_sog=FALSE, use_ue=FALSE, use_flt=FALSE){

  # DEBUG:
  # ciclo <- "2014-2020"
  # ambito <- "FSC" | "FESR" | "FSE" | "POC" / "PAC" per "0713"

  if (ciclo == "2014-2020") {
    temp <- case_when(ambito == "FESR" ~ "SIE",
                      ambito == "FSE" ~ "SIE",
                      ambito == "FEASR" ~ "SIE",
                      ambito == "FEAMP" ~ "SIE",
                      ambito == "YEI" ~ "SIE", # CHK: decidere se vive
                      TRUE ~ ambito)
    filename <- paste0(temp, "_1420.xlsx")
  } else {
    temp <- case_when(ambito == "FESR" ~ "FS",
                      ambito == "FSE" ~ "FS",
                      ambito == "POC" ~ "PAC",
                      TRUE ~ ambito)
    filename <- paste0(temp, "_0713.xlsx")
  }

  # appo <-  read_excel(file.path(DATA, "db", filename), guess_max = 5000) # MEMO: versione prima di GoogleDrive
  appo <-  read_excel(file.path(DB, filename), guess_max = 5000)

  if (ambito == "FESR" | ambito == "FSE" | ambito == "YEI" | ambito == "FEASR" | ambito == "FEAMP" ) {
    appo <- appo %>%
      filter(OC_DESCR_FONTE == ambito) %>%
      # MEMO: questo serve per integrare versione con Asse
      filter(OC_FLAG_ULTIMA_DECISIONE == "X")
  }

  # switch
  var_ls <- c("OC_CODICE_PROGRAMMA", "OC_DESCRIZIONE_PROGRAMMA", "OC_TIPOLOGIA_PROGRAMMA",
              "OC_DESCR_FONTE",
              "FINANZ_TOTALE_PUBBLICO",
              "OC_MACROAREA", "DEN_REGIONE")
  if (use_temi == TRUE) {
    var_ls <- c(var_ls,
                "DESCR_SETTORE_STRATEGICO_FSC", "DESCR_ASSE_TEMATICO_FSC",
                "COD_RA", "DESCR_RA",
                "OC_COD_ARTICOLAZ_PROGRAMMA")
    # appo <- appo %>%
    #   select(OC_CODICE_PROGRAMMA, OC_DESCRIZIONE_PROGRAMMA, OC_TIPOLOGIA_PROGRAMMA,
    #          OC_DESCR_FONTE,
    #          FINANZ_TOTALE_PUBBLICO,
    #          OC_MACROAREA, DEN_REGIONE,
    #          # MEMO: questa è per "_temi"
    #          DESCR_SETTORE_STRATEGICO_FSC,	DESCR_ASSE_TEMATICO_FSC,	COD_RA,	DESCR_RA,
    #          # NEW: inserito per match con SUS
    #          OC_COD_ARTICOLAZ_PROGRAMMA)
  }

  if (use_sog == TRUE) {
    var_ls <- c(var_ls,
                "OC_DENOM_PROGRAMMATORE")
    # appo <- appo %>%
    #   select(OC_CODICE_PROGRAMMA, OC_DESCRIZIONE_PROGRAMMA, OC_TIPOLOGIA_PROGRAMMA,
    #          OC_DESCR_FONTE,
    #          FINANZ_TOTALE_PUBBLICO,
    #          OC_MACROAREA, DEN_REGIONE,
    #          OC_DENOM_PROGRAMMATORE)
  }

  if (use_ue == TRUE) {
    var_ls <- c(var_ls,
                "FINANZ_UE", "OC_AREA_OBIETTIVO_UE")

    # appo <- appo %>%
    #   select(OC_CODICE_PROGRAMMA, OC_DESCRIZIONE_PROGRAMMA, OC_TIPOLOGIA_PROGRAMMA,
    #          OC_DESCR_FONTE,
    #          FINANZ_TOTALE_PUBBLICO,
    #          OC_MACROAREA, DEN_REGIONE)
  }

  if (use_flt == TRUE) {
    var_ls <- c(var_ls,
                "OC_FLAG_MONITORAGGIO")

    # appo <- appo %>%
    #   select(OC_CODICE_PROGRAMMA, OC_DESCRIZIONE_PROGRAMMA, OC_TIPOLOGIA_PROGRAMMA,
    #          OC_DESCR_FONTE,
    #          FINANZ_TOTALE_PUBBLICO,
    #          OC_MACROAREA, DEN_REGIONE)
  }

  # DEV: prima era seuqenza di if+else esclusivi, ora sono if separati e addizionali

  # select
  appo <- appo %>%
    select(var_ls)


  appo <- appo %>%
    mutate(OC_MACROAREA = toupper(OC_MACROAREA),
           DEN_REGIONE = toupper(DEN_REGIONE)) %>%
    mutate(x_MACROAREA = case_when(OC_MACROAREA == "NC" ~ "Nazionale", # MEMO: nel modello è presenta anche "Trasversale"
                                   is.na(OC_MACROAREA) ~ "Nazionale",
                                   OC_MACROAREA == "MEZZOGIORNO" ~ "Sud",
                                   OC_MACROAREA == "CENTRO NORD" ~ "Centro-Nord",
                                   OC_MACROAREA == "CENTRO-NORD" ~ "Centro-Nord",
                                   TRUE ~ OC_MACROAREA),
           x_REGIONE = case_when(DEN_REGIONE == "NC" ~ "ALTRO TERRITORIO",
                                 is.na(DEN_REGIONE) ~ "ALTRO TERRITORIO",
                                 DEN_REGIONE == "P.A. TRENTO" ~ "PA TRENTO",
                                 DEN_REGIONE == "P.A. BOLZANO" ~ "PA BOLZANO",
                                 DEN_REGIONE == "TRENTO" ~ "PA TRENTO",
                                 DEN_REGIONE == "BOLZANO" ~ "PA BOLZANO",
                                 DEN_REGIONE == "EMILIA ROMAGNA" ~ "EMILIA-ROMAGNA",
                                 DEN_REGIONE == "FRIULI VENEZIA GIULIA" ~ "FRIULI-VENEZIA GIULIA",
                                 DEN_REGIONE == "VALLE D’AOSTA" ~ "VALLE D'AOSTA",
                                 TRUE ~ DEN_REGIONE))

  if (simplify_loc == TRUE) {
    appo <- get_simply_non_loc(appo)
    # MEMO: restituisce x_MACROAREA e x_REGIONE in cormato compatibile con report CD
  }

  if (use_temi == TRUE) {
    appo <- appo %>%
      # MEMO: questa è per "_temi"
      mutate(temp = as.character(regmatches(DESCR_ASSE_TEMATICO_FSC,
                                            gregexpr("^([1-9]\\.?[A-z]?)\\.([0-9]{1,2})", DESCR_ASSE_TEMATICO_FSC))),
             COD_SETTORE_STRATEGICO_FSC = as.character(regmatches(temp, gregexpr("^([1-9])(\\.[A-z])?", temp))),
             COD_ASSE_TEMATICO_FSC = as.character(regmatches(temp, gregexpr("([0-9]{1,2})$", temp))),
             COD_RISULTATO_ATTESO = COD_RA) %>%
      select(-temp)
  }

  return(appo)
}


#' Inizializza il database della programmazione
#'
#' Carica il databse della programmazione, con pulizia della codifica di aree tematiche e temi prioritari FSC.
#'
#' @param usa_temi Vuoi caricare il DB con correzione dei temi prioritari?
#' @param usa_sog Vuoi caricare il DB con il soggetto programmatore?
#' @param usa_eu Vuoi caricare il dataset SIE del DB con le risorse UE e la categoria di regione? (solo per SIE)
#' @param usa_713 Vuoi caricare anche il DB per il 2007-2013?
#' @param export Vuoi avere le tabelle del DB nel GlobalEnv?
#' @return L'intero database dei programmazione, suddiviso in 'po_fesr', 'po_fse', 'po_fsc' e 'po_poc'.
init_programmazione <- function(usa_temi=FALSE, usa_sog=FALSE, usa_eu=FALSE, usa_flt=FALSE, add_713=FALSE, export=TRUE)
{

  # library("tidyverse")

  # switch
  if (usa_temi == TRUE) {
    use_temi <- TRUE
  } else {
    use_temi <- FALSE
  }

  if (usa_sog == TRUE) {
    use_sog <- TRUE
  } else {
    use_sog <- FALSE
  }

  if (usa_eu == TRUE) {
    use_eu <- TRUE
  } else {
    use_eu <- FALSE
  }

  if (usa_flt == TRUE) {
    use_flt <- TRUE
  } else {
    use_flt <- FALSE
  }

  # loads
  # if (usa_temi == TRUE) {
  if (export == TRUE) {
    po_fsc <<- load_db("2014-2020", "FSC", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_fesr <<- load_db("2014-2020", "FESR", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_fse <<- load_db("2014-2020", "FSE", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_poc <<- load_db("2014-2020", "POC", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_yei <<- load_db("2014-2020", "YEI", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_feamp <<- load_db("2014-2020", "FEAMP", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    message("Il db di programmazione è pronto in 'po_fesr', 'po_fse', 'po_fsc', 'po_poc', 'po_yei' e 'po_feamp'")

    if (add_713 == TRUE) {
      print("La programmazione 2007-2013 non è implementata per la modalità 'export'")
    }

  } else {
    po_fsc <- load_db("2014-2020", "FSC", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_fesr <- load_db("2014-2020", "FESR", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_fse <- load_db("2014-2020", "FSE", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_poc <- load_db("2014-2020", "POC", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_yei <- load_db("2014-2020", "YEI", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
    po_feamp <- load_db("2014-2020", "FEAMP", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)

    programmi <- po_fsc %>%
      mutate(x_CICLO = "2014-2020",
             x_AMBITO = "FSC") %>%
      bind_rows(po_poc %>%
                  mutate(x_CICLO = "2014-2020",
                         x_AMBITO = "POC")) %>%
      bind_rows(po_fesr %>%
                  mutate(x_CICLO = "2014-2020",
                         x_AMBITO = "FESR")) %>%
      bind_rows(po_fse %>%
                  mutate(x_CICLO = "2014-2020",
                         x_AMBITO = "FSE")) %>%
      bind_rows(po_yei %>%
                  mutate(x_CICLO = "2014-2020",
                         x_AMBITO = "YEI")) %>%
      bind_rows(po_feamp %>%
                  mutate(x_CICLO = "2014-2020",
                         x_AMBITO = "FEAMP")) %>%
      as.data.frame(.) %>%
      mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "POC", "FSC", "FEASR", "FEAMP", "YEI", "SNAI")),
             x_CICLO = factor(x_CICLO, levels = c("2014-2020", "2007-2013", "2000-2006")))

    if (add_713 == TRUE) {
      po_fsc713 <- load_db("2007-2013", "FSC", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
      po_fesr713 <- load_db("2007-2013", "FESR", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
      po_fse713 <- load_db("2007-2013", "FSE", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)
      po_pac713 <- load_db("2007-2013", "POC", simplify_loc = TRUE, use_temi = use_temi, use_sog = use_sog, use_ue = use_eu, use_flt = use_flt)

      programmi <- programmi %>%
        bind_rows(po_fsc713 %>%
                    mutate(x_CICLO = "2007-2013",
                           x_AMBITO = "FSC")) %>%
        bind_rows(po_pac713 %>%
                    mutate(x_CICLO = "2007-2013",
                           x_AMBITO = "POC")) %>%
        bind_rows(po_fesr713 %>%
                    mutate(x_CICLO = "2007-2013",
                           x_AMBITO = "FESR")) %>%
        bind_rows(po_fse713 %>%
                    mutate(x_CICLO = "2007-2013",
                           x_AMBITO = "FSE"))
    }

    return(programmi)

    }

  # } else if (usa_sog == TRUE) {
  #   if (export == TRUE) {
  #     po_fsc <<- load_db("2014-2020", "FSC", simplify_loc = TRUE, use_sog = TRUE)
  #     po_fesr <<- load_db("2014-2020", "FESR", simplify_loc = TRUE, use_sog = TRUE)
  #     po_fse <<- load_db("2014-2020", "FSE", simplify_loc = TRUE, use_sog = TRUE)
  #     po_poc <<- load_db("2014-2020", "POC", simplify_loc = TRUE, use_sog = TRUE)
  #     po_yei <<- load_db("2014-2020", "YEI", simplify_loc = TRUE, use_sog = TRUE)
  #     message("Il db di programmazione è pronto in 'po_fesr', 'po_fse', 'po_fsc', 'po_poc' e 'po_yei'")
  #
  #   } else {
  #     po_fsc <- load_db("2014-2020", "FSC", simplify_loc = TRUE, use_sog = TRUE)
  #     po_fesr <- load_db("2014-2020", "FESR", simplify_loc = TRUE, use_sog = TRUE)
  #     po_fse <- load_db("2014-2020", "FSE", simplify_loc = TRUE, use_sog = TRUE)
  #     po_poc <- load_db("2014-2020", "POC", simplify_loc = TRUE, use_sog = TRUE)
  #     po_yei <- load_db("2014-2020", "YEI", simplify_loc = TRUE, use_sog = TRUE)
  #
  #     programmi <- po_fsc %>%
  #       mutate(x_CICLO = "2014-2020",
  #              x_AMBITO = "FSC") %>%
  #       bind_rows(po_poc %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "POC")) %>%
  #       bind_rows(po_fesr %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "FESR")) %>%
  #       bind_rows(po_fse %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "FSE")) %>%
  #       bind_rows(po_yei %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "YEI")) %>%
  #       as.data.frame(.) %>%
  #       mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "POC", "FSC", "FEASR", "YEI", "SNAI")),
  #              x_CICLO = factor(x_CICLO, levels = c("2014-2020", "2007-2013", "2000-2006")))
  #
  #     return(programmi)
  #
  #   }

  # } else {
  #   if (export == TRUE) {
  #     po_fsc <<- load_db("2014-2020", "FSC", simplify_loc = TRUE, use_temi = FALSE)
  #     po_fesr <<- load_db("2014-2020", "FESR", simplify_loc = TRUE, use_temi = FALSE)
  #     po_fse <<- load_db("2014-2020", "FSE", simplify_loc = TRUE, use_temi = FALSE)
  #     po_poc <<- load_db("2014-2020", "POC", simplify_loc = TRUE, use_temi = FALSE)
  #     po_yei <<- load_db("2014-2020", "YEI", simplify_loc = TRUE, use_temi = FALSE)
  #     message("Il db di programmazione è pronto in 'po_fesr', 'po_fse', 'po_fsc', 'po_poc' e 'po_yei'")
  #
  #   } else  {
  #     po_fsc <- load_db("2014-2020", "FSC", simplify_loc = TRUE, use_temi = FALSE)
  #     po_fesr <- load_db("2014-2020", "FESR", simplify_loc = TRUE, use_temi = FALSE)
  #     po_fse <- load_db("2014-2020", "FSE", simplify_loc = TRUE, use_temi = FALSE)
  #     po_poc <- load_db("2014-2020", "POC", simplify_loc = TRUE, use_temi = FALSE)
  #     po_yei <- load_db("2014-2020", "YEI", simplify_loc = TRUE, use_temi = FALSE)
  #
  #     programmi <- po_fsc %>%
  #       mutate(x_CICLO = "2014-2020",
  #              x_AMBITO = "FSC") %>%
  #       bind_rows(po_poc %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "POC")) %>%
  #       bind_rows(po_fesr %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "FESR")) %>%
  #       bind_rows(po_fse %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "FSE")) %>%
  #       bind_rows(po_yei %>%
  #                   mutate(x_CICLO = "2014-2020",
  #                          x_AMBITO = "YEI")) %>%
  #       as.data.frame(.) %>%
  #       mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "POC", "FSC", "FEASR", "YEI", "SNAI")),
  #              x_CICLO = factor(x_CICLO, levels = c("2014-2020", "2007-2013", "2000-2006")))
  #
  #     return(programmi)
  #
  #   }
  # }
}


#' Quadro risorse programmate
#'
#' Crea una tabella di sintesi con le risorse programmate.
#'
#' @param usa_713 Vuoi anche le risorse 2007-2013?
#' @return Tabella di sintesi per ciclo, ambito e macroarea. Per il 2007-2013, le risorse vengono inserite in forma semplificata.
make_risorse <- function(usa_713=FALSE, usa_macroaree=FALSE)
{

  programmi <- init_programmazione(usa_temi=FALSE, export=FALSE)

  # bind risorse
  # risorse <- po_fsc %>%
  #   mutate(x_CICLO = "2014-2020",
  #          x_AMBITO = "FSC") %>%
  #   bind_rows(po_poc %>%
  #               mutate(x_CICLO = "2014-2020",
  #                      x_AMBITO = "POC")) %>%
  #   bind_rows(po_fesr %>%
  #               mutate(x_CICLO = "2014-2020",
  #                      x_AMBITO = "FESR")) %>%
  #   bind_rows(po_fse %>%
  #               mutate(x_CICLO = "2014-2020",
  #                      x_AMBITO = "FSE")) %>%
  #   bind_rows(po_yei %>%
  #               mutate(x_CICLO = "2014-2020",
  #                      x_AMBITO = "YEI")) %>%
  risorse <- programmi %>%
    as.data.frame(.) %>%
    mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "POC", "FSC", "FEASR", "FEAMP", "YEI", "SNAI")),
           x_MACROAREA = factor(x_MACROAREA, levels = c("Centro-Nord", "Sud", "Ambito nazionale"))) %>%
    group_by(x_CICLO, x_AMBITO, x_MACROAREA) %>%
    summarise(RIS = sum(FINANZ_TOTALE_PUBBLICO, na.rm = TRUE))

  if (usa_713 == TRUE) {
    risorse_713 <- data_frame(x_CICLO = c("2007-2013", "2007-2013", "2007-2013",
                                   "2007-2013", "2007-2013",
                                   "2007-2013", "2007-2013",
                                   "2007-2013", "2007-2013"),
                       x_AMBITO = c("FSC", "FSC", "FSC",
                                    "POC", "POC",
                                    "FESR", "FESR",
                                    "FSE", "FSE"),
                       x_MACROAREA = c("Sud", "Centro-Nord", "Ambito nazionale",
                                       "Sud", "Centro-Nord",
                                       "Sud", "Centro-Nord",
                                       "Sud", "Centro-Nord"),
                       RIS = c(23179200000, 4843300000, 11624100000,
                               8875600000, 118400000,
                               24979900000, 7038500000,
                               7419400000, 6343600000)
                       # versione semplificata in Meuro
                       # RIS = c(23179.2, 4843.3, 11624.1,
                       #         8875.6, 118.4,
                       #         24979.9, 7038.5,
                       #         7419.4, 6343.6)
                       ) %>%
      mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "POC", "FSC", "FEASR", "FEAMP", "YEI", "SNAI")),
             x_MACROAREA = factor(x_MACROAREA, levels = c("Centro-Nord", "Sud", "Ambito nazionale")),
             x_CICLO = factor(x_CICLO, levels = c("2014-2020", "2007-2013", "2000-2006")))

    risorse <- risorse %>%
      bind_rows(risorse_713)

    if (usa_macroaree == FALSE) {
      risorse <- risorse %>%
        as.data.frame(.) %>%
        # mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "POC", "FSC", "FEASR", "FEAMP", "YEI", "SNAI")),
        #        x_MACROAREA = factor(x_MACROAREA, levels = c("Centro-Nord", "Sud", "Ambito nazionale"))) %>%
        group_by(x_CICLO, x_AMBITO) %>%
        summarise(RIS = sum(RIS, na.rm = TRUE))
    }

  }

  # rm(po_fsc, po_fesr, po_fse, po_poc)

  return(risorse)
}
