# Funzioni per la creazione di variabili
# Logica: entra un df, esce lo stesso df con nuova variabile
# Per alcune è presente anche debug_mode

# TODO:
# get_categorie_UE: read_csv2(file.path(DATA, "clp_tema_campointervento.csv"))
# get_stato_attuazione: write.csv2(file.path(tmp_path, "chk_stato_proced.csv"), na = "", row.names = FALSE)


# Aggiunge categoria UE
# DEPRECATED
# get_categorie_UE <- function(df) {
#
#   # load categorie UE
#   appo_tema <- read_csv2(file.path(DATA, "clp_tema_campointervento.csv")) %>%
#     mutate(OC_COD_CICLO = case_when(TIPO == "CAMPO" ~ 2,
#                                     TIPO == "TEMA" ~ 1)) %>%
#     select(-TIPO)
#
#   # semplifcazione categorie UE
#   temp_tema <- df %>%
#     select(COD_LOCALE_PROGETTO) %>%
#     left_join(appo_tema,
#               by = "COD_LOCALE_PROGETTO") %>%
#     # group_by(COD_LOCALE_PROGETTO, OC_COD_CICLO) %>%
#     group_by(COD_LOCALE_PROGETTO) %>%
#     # MEMO: serve collapse per 1:N nel campo di intervento 1420 (assente in 713)
#     summarise(COD_TEMA_CAMPO = paste(COD_TEMA_CAMPO, collapse=":::"),
#               DESCR_TEMA_CAMPO = paste(DESCR_TEMA_CAMPO, collapse=":::"))
#
#   # DEBUG:
#   # dim(df)[1] == dim(temp_tema)[1]
#
#   out <- df %>%
#     left_join(temp_tema,
#             by = "COD_LOCALE_PROGETTO")
#
#     return(out)
#
# }


# Aggiunge dimensione finanziaria
get_dimensione_fin <- function(df, debug_mode=FALSE) {
  # DEBUG:
  # df <- perimetro
  # DEV: da implementare via progetti e con debug_mode (come per "get_stato_attuazione.R")

  # load progetti
  # source("loader.R")

  # NEW BLOCK
  if (!any(names(df) == "OC_FINANZ_TOT_PUB_NETTO")) {
    df <- df %>%
      left_join(progetti %>%
                  select(COD_LOCALE_PROGETTO, OC_FINANZ_TOT_PUB_NETTO),
                by = "COD_LOCALE_PROGETTO")
  }

  df <- df %>%
    # aggiunge classe dimensione finanziaria
    mutate(CLASSE_FIN = case_when(OC_FINANZ_TOT_PUB_NETTO <= 100000 ~ "0-100k",
                                  OC_FINANZ_TOT_PUB_NETTO > 100000 & OC_FINANZ_TOT_PUB_NETTO <= 500000 ~ "100k-500k",
                                  OC_FINANZ_TOT_PUB_NETTO > 500000 & OC_FINANZ_TOT_PUB_NETTO <= 1000000 ~ "500k-1M",
                                  OC_FINANZ_TOT_PUB_NETTO > 1000000 & OC_FINANZ_TOT_PUB_NETTO <= 2000000 ~ "1M-2M",
                                  OC_FINANZ_TOT_PUB_NETTO > 2000000 & OC_FINANZ_TOT_PUB_NETTO <= 5000000 ~ "2M-5M",
                                  OC_FINANZ_TOT_PUB_NETTO > 5000000 & OC_FINANZ_TOT_PUB_NETTO <= 10000000 ~ "5M-10M",
                                  OC_FINANZ_TOT_PUB_NETTO > 10000000 ~ "10M-infty")) %>%
    mutate(CLASSE_FIN = factor(CLASSE_FIN, levels=c("0-100k", "100k-500k", "500k-1M", "1M-2M", "2M-5M", "5M-10M", "10M-infty")))

  return(df)


}


# Semplifica regione
get_regione_simply <- function(df, progetti=NULL) {
  # MEMO: deve avere struttura di progetti

  if (is.null(progetti)) {
    progetti <- load_progetti(bimestre = bimestre, visualizzati = TRUE, light = TRUE)
  }

  # NEW BLOCK
  if (!any(names(df) == "COD_REGIONE")) {
    df <- df %>%
      left_join(progetti %>%
                  select(COD_LOCALE_PROGETTO, COD_REGIONE, DEN_REGIONE, COD_PROVINCIA),
                by = "COD_LOCALE_PROGETTO")

  } else if (!any(names(df) == "DEN_REGIONE")) {
    df <- df %>%
      left_join(progetti %>%
                  select(COD_LOCALE_PROGETTO, DEN_REGIONE, COD_PROVINCIA),
                by = "COD_LOCALE_PROGETTO")
  }

  reg_cn <- c("001", "002", "003", "004", "005", "006",
              "007", "008", "009", "010", "011", "012")
  names(reg_cn) <- c("PIEMONTE", "VALLE D'AOSTA", "LOMBARDIA", "TRENTINO-ALTO ADIGE", "VENETO", "FRIULI-VENEZIA GIULIA",
                     "LIGURIA",  "EMILIA-ROMAGNA", "TOSCANA", "UMBRIA", "MARCHE", "LAZIO")

  reg_sud <- c("013", "014", "015", "016", "017", "018", "019", "020")
  names(reg_sud) <- c("ABRUZZO", "MOLISE", "CAMPANIA", "PUGLIA", "BASILICATA", "CALABRIA", "SICILIA", "SARDEGNA")

  temp <- c(names(reg_cn[1:3]), "PA TRENTO", "PA BOLZANO", names(reg_cn[5:12]), names(reg_sud), "ALTRO TERRITORIO")

  # regioni
  df <- df %>%
    # fix per denominazione bilingue
    # mutate(DEN_REGIONE = case_when(COD_REGIONE == "002" ~ "VALLE D'AOSTA",
    #                                COD_REGIONE == "004" ~ "TRENTINO-ALTO ADIGE",
    #                                TRUE ~ DEN_REGIONE)) %>%
    mutate(x_REGIONE = ifelse(COD_REGIONE %in% c(reg_cn, reg_sud), DEN_REGIONE, "ALTRO TERRITORIO")) %>%
    # fix per preesteso (nomi tranciati di doppie regioni)
    # mutate(DEN_REGIONE_2 = case_when(DEN_REGIONE == "EMILIA" ~ "EMILIA-ROMAGNA",
    #                                  DEN_REGIONE == "FRIULI" ~ "FRIULI-VENEZIA GIULIA",
    #                                  TRUE ~ DEN_REGIONE_2)) %>%
    # mutate(x_REGIONE = factor(x_REGIONE, levels = c(names(reg_cn), names(reg_sud), "ALTRO TERRITORIO")))
    mutate(x_REGIONE = case_when(COD_PROVINCIA == "004021" ~ "PA BOLZANO",
                                 COD_PROVINCIA == "004022" ~ "PA TRENTO",
                                 # fix
                                 COD_PROVINCIA == "004000" & COD_LOCALE_PROGETTO == "2BO5-1a-237" ~ "PA BOLZANO", # MEMO: progetto del POR PA Bolzano
                                 COD_PROVINCIA == "004000" & COD_LOCALE_PROGETTO == "1ML1279" ~ "PA TRENTO", # MEMO: progetto del PON AdS FSE forzato qui
                                 TRUE ~ x_REGIONE)) %>%
    mutate(x_REGIONE = factor(x_REGIONE, levels = temp))

  return(df)
}


# Aggiunge macroarea
get_macroarea <- function(df, progetti=NULL, debug_mode=FALSE) {
  # DEBUG:
  # df <- perimetro
  # DEV: da implementare via progetti e con debug_mode (come per "get_stato_attuazione.R")

  # load progetti
  # source("loader.R")

  if (is.null(progetti)) {
    progetti <- load_progetti(bimestre = bimestre, visualizzati = TRUE, light = TRUE)
  }

  # NEW BLOCK
  if (!any(names(df) == "COD_REGIONE")) {
    df <- df %>%
      left_join(progetti %>%
                  select(COD_LOCALE_PROGETTO, COD_REGIONE),
                by = "COD_LOCALE_PROGETTO")
  }

  # fix per macroarea
  reg_cn <- c("001", "002", "003", "004", "005", "006",
              "007", "008", "009", "010", "011", "012")
  names(reg_cn) <- c("PIEMONTE", "VALLE D'AOSTA", "LOMBARDIA", "TRENTINO-ALTO ADIGE", "VENETO", "FRIULI-VENEZIA GIULIA",
                     "LIGURIA",  "EMILIA-ROMAGNA", "TOSCANA", "UMBRIA", "MARCHE", "LAZIO")

  reg_sud <- c("013", "014", "015", "016", "017", "018", "019", "020")
  names(reg_sud) <- c("ABRUZZO", "MOLISE", "CAMPANIA", "PUGLIA", "BASILICATA", "CALABRIA", "SICILIA", "SARDEGNA")

  chk_regione <- function(data_vector, test_vector) {
    # DEBUG:
    # temp <- c("001:::002", "001:::003", "001:::020")
    # chk_regione(temp, reg_cn)
    sapply(data_vector, function(x) {all(unlist(str_split(x, pattern = ":::")) %in% test_vector)})
  }

  df <- df %>%
    mutate(x_MACROAREA = case_when(COD_REGIONE %in% reg_cn ~ "Centro-Nord",
                                 COD_REGIONE %in% reg_sud ~ "Sud",
                                 COD_REGIONE == "000" ~ "Nazionale", # AMBITO NAZIONALE
                                 grepl(":::", COD_REGIONE) & chk_regione(COD_REGIONE, reg_cn) == TRUE ~ "Centro-Nord",
                                 grepl(":::", COD_REGIONE) & chk_regione(COD_REGIONE, reg_sud) == TRUE ~ "Sud",
                                 grepl(":::", COD_REGIONE) ~ "Trasversale", # MEMO: multi-regionale su più macroaree
                                 TRUE ~ "Estero")) %>%
    mutate(x_MACROAREA = factor(x_MACROAREA, levels = c("Centro-Nord", "Sud", "Trasversale", "Nazionale", "Estero")))

  return(df)

}


# Aggiunge stato di attuazione
# get_stato_attuazione <- function(df, chk_today, debug_mode=FALSE) {
#   # MEMO: formato per data è numerico tipo 20180531 oppure character tipo "20180531"
#   # DEBUG:
#   # df <- perimetro
#   # chk_today <-  as.numeric("20180731")
#   # sintesi avanzamento procedurale per PO
#   if (missing(chk_today)) {
#     chk_today <- as.numeric(gsub("-", "", as.character(today())))
#   } else {
#     chk_today <- as.numeric(chk_today)
#   }
#
#   # load progetti
#   # source("loader.R")
#
#   var_ls <- c("OC_STATO_PROGETTO",
#               "OC_STATO_FINANZIARIO",
#               "DATA_INIZIO_EFF_COLLAUDO", "DATA_FINE_EFF_COLLAUDO",
#               "DATA_INIZIO_EFF_ESECUZIONE", "DATA_FINE_EFF_ESECUZIONE",
#               "DATA_INIZIO_EFF_STIP_ATTRIB", "DATA_FINE_EFF_STIP_ATTRIB",
#               "DATA_INIZIO_EFF_AGG_BANDO", "DATA_FINE_EFF_AGG_BANDO",
#               "DATA_INIZIO_EFF_PROG_ESEC", "DATA_FINE_EFF_PROG_ESEC",
#               "DATA_INIZIO_EFF_PROG_DEF", "DATA_FINE_EFF_PROG_DEF",
#               "DATA_INIZIO_EFF_PROG_PREL", "DATA_FINE_EFF_PROG_PREL",
#               "DATA_INIZIO_EFF_STUDIO_FATT", "DATA_FINE_EFF_STUDIO_FATT",
#               "IMPEGNI", "TOT_PAGAMENTI", "OC_FINANZ_TOT_PUB_NETTO", "COSTO_REALIZZATO")
#
#   appo <- progetti %>%
#     semi_join(df, by = "COD_LOCALE_PROGETTO") %>%
#     select("COD_LOCALE_PROGETTO", var_ls)
#   # MEMO: recupera solo le variabili che non sono gia presenti in df
#
#   out <- appo %>%
#     mutate(CHK_END = case_when(DATA_FINE_EFF_COLLAUDO <= chk_today ~ 1,
#                                DATA_INIZIO_EFF_COLLAUDO <= chk_today ~ 1,
#                                DATA_FINE_EFF_ESECUZIONE <= chk_today ~ 1,
#                                TRUE ~ 0),
#            CHK_ESEC = case_when(DATA_INIZIO_EFF_ESECUZIONE <= chk_today ~ 1,
#                                 DATA_FINE_EFF_STIP_ATTRIB <= chk_today ~ 1, # MEMO: da portare sotto...? altrimenti resta classe GARA quasi vuota
#                                 # DATA_FINE_EFF_AGG_BANDO <= chk_today ~ 1,
#                                 # is.na(DATA_INIZIO_EFF_ESECUZIONE) ~ 0,
#                                 TRUE ~ 0),
#            CHK_GARA = case_when(DATA_INIZIO_EFF_STIP_ATTRIB <= chk_today ~ 1,
#                                 DATA_FINE_EFF_AGG_BANDO <= chk_today ~ 1,
#                                 DATA_INIZIO_EFF_AGG_BANDO <= chk_today ~ 1,
#                                 # DATA_FINE_EFF_PROG_ESEC <= chk_today ~ 1,
#                                 TRUE ~ 0),
#            # MEMO: blocco su progettazione presente solo per le opere
#            CHK_PROG = case_when(DATA_FINE_EFF_PROG_ESEC <= chk_today ~ 1,
#                                 DATA_INIZIO_EFF_PROG_ESEC <= chk_today ~ 1,
#                                 DATA_FINE_EFF_PROG_DEF <= chk_today ~ 1,
#                                 DATA_INIZIO_EFF_PROG_DEF <= chk_today ~ 1,
#                                 DATA_FINE_EFF_PROG_PREL <= chk_today ~ 1,
#                                 DATA_INIZIO_EFF_PROG_PREL <= chk_today ~ 1,
#                                 # DATA_FINE_EFF_STUDIO_FATT <= chk_today ~ 1,
#                                 # DATA_INIZIO_EFF_STUDIO_FATT <= chk_today ~ 1,
#                                 TRUE ~ 0),
#            CHK_AVVP = case_when(DATA_FINE_EFF_STUDIO_FATT <= chk_today ~ 1,
#                                 DATA_INIZIO_EFF_STUDIO_FATT <= chk_today ~ 1,
#                                 TRUE ~ 0)) %>%
#     # mutate(STATO_PROCED = case_when(CHK_END == 1 ~ "esercizio",
#     #                                 CHK_ESEC == 1 ~ "esecuzione",
#     #                                 CHK_GARA == 1 ~ "affidamento",
#     #                                 CHK_PROG == 1 ~ "progettazione",
#     #                                 IMPEGNI > 0 ~ "esecuzione", # MEMO: assegnazione forzata per risolvere anomalie
#     #                                 TRUE ~ "programmazione")) %>%
#     mutate(STATO_PROCED = case_when(OC_STATO_PROGETTO == "Concluso" ~ "Esercizio",
#                                     OC_STATO_PROGETTO == "Liquidato" ~ "Esercizio",
#                                     OC_STATO_PROGETTO == "In corso" & CHK_END == 1 ~ "Esercizio",
#                                     OC_STATO_PROGETTO == "In corso" & CHK_ESEC == 1 ~ "Esecuzione",
#                                     OC_STATO_PROGETTO == "In corso" & CHK_GARA == 1 ~ "Affidamento",
#                                     OC_STATO_PROGETTO == "In corso" & CHK_PROG == 1 ~ "Progettazione",
#                                     OC_STATO_PROGETTO == "In corso" & CHK_AVVP == 1 ~ "Avvio",
#                                     OC_STATO_PROGETTO == "In corso" & TOT_PAGAMENTI / OC_FINANZ_TOT_PUB_NETTO > 0.1 ~ "Esecuzione",
#                                     OC_STATO_PROGETTO == "In corso" ~ "Avvio",
#                                     # OC_STATO_PROGETTO == "In corso" & IMPEGNI > 0 ~ "Esecuzione", # MEMO: assegnazione forzata per risolvere anomalie
#                                     OC_STATO_PROGETTO == "Non avviato" ~ "Programmazione",
#                                     TRUE ~ "Programmazione")) %>%
#     mutate(STATO_PROCED = factor(STATO_PROCED, levels = c("Programmazione", "Avvio", "Progettazione", "Affidamento", "Esecuzione", "Esercizio")))
#
#   if (debug_mode == TRUE) {
#     out <- out %>%
#       # DEBUG: controllo su importi (variabili da reperire o ridenominare in debug)
#       mutate(CHK_IMP = IMPEGNI / OC_FINANZ_TOT_PUB_NETTO,
#              CHK_IMP_CLASS = case_when(CHK_IMP > 1 ~ ">1",
#                                        CHK_IMP > 0.7 ~ "0.7-1",
#                                        CHK_IMP > 0.3 ~ "0.3-0.7",
#                                        CHK_IMP > 0.1 ~ "0.1-0.3",
#                                        TRUE ~ "0-0.1"),
#              CHK_PAG = TOT_PAGAMENTI / OC_FINANZ_TOT_PUB_NETTO,
#              CHK_PAG_CLASS = case_when(CHK_PAG > 1 ~ ">1",
#                                        CHK_PAG > 0.7 ~ "0.7-1",
#                                        CHK_PAG > 0.3 ~ "0.3-0.7",
#                                        CHK_PAG > 0.1 ~ "0.1-0.3",
#                                        TRUE ~ "0-0.1")) %>%
#       mutate(CHK_IMP_CLASS = factor(CHK_IMP_CLASS, c(">1", "0.7-1", "0.3-0.7", "0.1-0.3", "0-0.1")),
#              CHK_PAG_CLASS = factor(CHK_PAG_CLASS, c(">1", "0.7-1", "0.3-0.7", "0.1-0.3", "0-0.1")))
#     select(COD_LOCALE_PROGETTO,
#            DATA_FINE_EFF_COLLAUDO,
#            DATA_INIZIO_EFF_COLLAUDO,
#            DATA_FINE_EFF_ESECUZIONE, CHK_END,
#            DATA_INIZIO_EFF_ESECUZIONE,
#            DATA_FINE_EFF_STIP_ATTRIB, CHK_ESEC,
#            DATA_INIZIO_EFF_STIP_ATTRIB,
#            DATA_FINE_EFF_AGG_BANDO,
#            DATA_INIZIO_EFF_AGG_BANDO, CHK_GARA,
#            DATA_INIZIO_EFF_PROG_ESEC,
#            DATA_INIZIO_EFF_PROG_DEF, DATA_FINE_EFF_PROG_DEF,
#            DATA_INIZIO_EFF_PROG_PREL, DATA_FINE_EFF_PROG_PREL,
#            DATA_FINE_EFF_STUDIO_FATT,
#            DATA_INIZIO_EFF_STUDIO_FATT, CHK_PROG,
#            STATO_PROCED,
#            COSTO_REALIZZATO,
#            OC_STATO_PROGETTO,
#            OC_STATO_FINANZIARIO,
#            CHK_IMP, CHK_IMP_CLASS, CHK_PAG, CHK_PAG_CLASS)
#
#     out %>%
#       write.csv2(file.path(tmp_path, "chk_stato_proced.csv"), na = "", row.names = FALSE)
#
#     # out %>%
#     #   count(STATO_PROCED, CHK_PAG_CLASS) %>%
#     #   spread(CHK_PAG_CLASS, n)
#
#     # out %>%
#     #   group_by(STATO_PROCED, CHK_PAG_CLASS) %>%
#     #   mutate(FTP = sum(OC_FINANZ_TOT_PUB_NETTO, na.rm = TRUE)) %>%
#     #   select(STATO_PROCED, CHK_PAG_CLASS, FTP) %>%
#     #   group_by(STATO_PROCED, CHK_PAG_CLASS) %>%
#     #   mutate(FTP = sum(FTP, na.rm = TRUE)) %>%
#     #   spread(CHK_PAG_CLASS, FTP)
#
#
#   } else {
#     out <- df %>%
#       left_join(out %>%
#                   select(COD_LOCALE_PROGETTO, STATO_PROCED),
#                 by = "COD_LOCALE_PROGETTO")
#     return(out)
#   }
# }


# Aggiunge categoira di regione UE
get_catreg_UE <- function(df, progetti=NULL, debug_mode=FALSE) {
  # DEBUG:
  # df <- perimetro
  # DEV: da implementare via progetti e con debug_mode (come per "get_stato_attuazione.R")

  # load progetti
  # source("loader.R")

  if (is.null(progetti)) {
    progetti <- load_progetti(bimestre = bimestre, visualizzati = TRUE, light = TRUE)
  }

  # NEW BLOCK
  if (!any(names(df) == "COD_REGIONE")) {
    df <- df %>%
      left_join(progetti %>%
                  select(COD_LOCALE_PROGETTO, COD_REGIONE),
                by = "COD_LOCALE_PROGETTO")
  }

  # fix per macroarea
  rs <- c("001", "002", "003", "004", "005", "006",
              "007", "008", "009", "010", "011", "012")
  names(rs) <- c("PIEMONTE", "VALLE D'AOSTA", "LOMBARDIA", "TRENTINO-ALTO ADIGE", "VENETO", "FRIULI-VENEZIA GIULIA",
                     "LIGURIA",  "EMILIA-ROMAGNA", "TOSCANA", "UMBRIA", "MARCHE", "LAZIO")

  rt <- c("013", "014", "020")
  names(rt) <- c("ABRUZZO", "MOLISE", "SARDEGNA")

  rms <- c("015", "016", "017", "018", "019")
  names(rms) <- c("CAMPANIA", "PUGLIA", "BASILICATA", "CALABRIA", "SICILIA")

  chk_regione <- function(data_vector, test_vector) {
    # DEBUG:
    # temp <- c("001:::002", "001:::003", "001:::020")
    # chk_regione(temp, reg_cn)
    sapply(data_vector, function(x) {all(unlist(str_split(x, pattern = ":::")) %in% test_vector)})
  }

  df <- df %>%
    mutate(CATREG = case_when(COD_REGIONE %in% rs ~ "RS",
                              COD_REGIONE %in% rt ~ "RT",
                              COD_REGIONE %in% rms ~ "RMS",
                              COD_REGIONE == "000" ~ "Nazionale", # AMBITO NAZIONALE
                              grepl(":::", COD_REGIONE) & chk_regione(COD_REGIONE, rs) == TRUE ~ "RS",
                              grepl(":::", COD_REGIONE) & chk_regione(COD_REGIONE, rt) == TRUE ~ "RT",
                              grepl(":::", COD_REGIONE) & chk_regione(COD_REGIONE, rms) == TRUE ~ "RMS",
                              grepl(":::", COD_REGIONE) ~ "Trasversale", # MEMO: multi-regionale su più macroaree
                              TRUE ~ "Estero")) %>%
    mutate(CATREG = factor(CATREG, levels = c("RS", "RT", "RMS", "Trasversale", "Nazionale", "Estero"))) %>%
    select(-COD_REGIONE)

  return(df)


}


# Aggiunge variabili "X" di riflassificazione dei PO
get_x_vars_old <- function(df, debug_mode=FALSE) {
  df <- df %>%
    left_join(po_riclass %>%
                select(-NOTE),
              by = "OC_CODICE_PROGRAMMA")
  return(df)
}



# Aggiunge variabili "X" di riflassificazione dei PO
# get_x_vars_new1 <- function(df, debug_mode=FALSE, progetti=NULL) {
#   # MEMO: nuova versione con "x_AMBITO"
#   # DEV: definire "bimestre" nella funzione!
#
#   temp <- names(df)
#
#   df <- df %>%
#     left_join(po_riclass %>%
#                 select(-NOTE),
#               by = "OC_CODICE_PROGRAMMA")
#
#   # recupera fondo comunitario da progetti (se assente in df)
#   if (!(any(names(df) == "FONDO_COMUNITARIO"))) {
#
#     if (is.null(progetti)) {
#       progetti <- load_progetti(bimestre = bimestre, visualizzati=TRUE)
#     }
#
#     df <- df %>%
#       left_join(progetti %>%
#                   select(COD_LOCALE_PROGETTO, FONDO_COMUNITARIO),
#                 by = "COD_LOCALE_PROGETTO")
#   }
#
#   df <- df %>%
#     mutate(x = gsub("PROGRAMMI ", "", x_FONDO)) %>%
#     mutate(x_AMBITO = case_when(x == "MISTI" ~ "FESR", # MEMO: privilegio FESR su altro per MISTI
#                                 x == "FESR-FSE" ~ FONDO_COMUNITARIO, # MEMO: split per programmi pluri-fondo
#                                 x == "FSC" ~ "FSC",
#                                 x == "POC" ~ "POC",
#                                 x == "PAC" ~ "POC", # MEMO: solo per 713
#                                 x == "ALTRO" ~ "SNAI",
#                                 TRUE ~ x)) %>%
#     mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "FEASR", "POC", "FSC", "SNAI")))
#
#   # TODO: inserire direttamente in po_riclass.csv (tutto tranne "FESR-FSE" e "MISTI")
#
#     # riordina vars
#     df <- df %>%
#       select(temp, x_CICLO, x_FONDO, x_AMBITO, x_GRUPPO, x_PROGRAMMA)
#
#   return(df)
# }


# Aggiunge variabili "X" di riflassificazione dei PO
get_x_vars <- function(df, debug_mode=FALSE, progetti=NULL) {
  # MEMO: nuova versione con "x_AMBITO"
  # DEV: definire "bimestre" nella funzione!

  temp <- names(df)

  df <- df %>%
    left_join(po_riclass %>%
                select(-NOTE),
              by = "OC_CODICE_PROGRAMMA")

  # recupera fondo comunitario da progetti (se assente in df)
  if (!(any(names(df) == "FONDO_COMUNITARIO"))) {

    if (is.null(progetti)) {
      progetti <- load_progetti(bimestre = bimestre, visualizzati=TRUE, light = FALSE)
    }

    df <- df %>%
      left_join(progetti %>%
                  select(COD_LOCALE_PROGETTO, FONDO_COMUNITARIO),
                by = "COD_LOCALE_PROGETTO")
  }

  df <- df %>%
    mutate(x_AMBITO = case_when(x_AMBITO == "FESR-FSE" ~ FONDO_COMUNITARIO, # MEMO: split per programmi pluri-fondo
                                TRUE ~ x_AMBITO)) %>%
    mutate(x_AMBITO = factor(x_AMBITO, levels = c("FESR", "FSE", "FEASR", "POC", "FSC", "SNAI", "YEI", "CTE", "FEAMP", "FEAD", "FAMI")))

  # TODO: inserire elaboraizone diretta anche su "MISTI"?

  # riordina vars
  df <- df %>%
    select(temp, x_CICLO, x_FONDO, x_AMBITO, x_GRUPPO, x_PROGRAMMA)

  return(df)
}


