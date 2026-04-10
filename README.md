# ANALISI-DEI-CLIENTI-DI-UNA-BANCA-CON-MYSQL

## Descrizione del Progetto
Questo progetto consiste nella realizzazione di un'architettura SQL per l'estrazione di indicatori sintetici relativi al comportamento dei clienti di una banca. L'obiettivo è trasformare dati transazionali grezzi in una tabella che permetta di analizzare il profilo di ogni cliente attraverso diverse metriche.

La parte principale del progetto è una query di creazione di una tabella sintetica (tabella_client) che aggrega informazioni demografiche, volumi di transazioni (entrate/uscite) e tipologie di conto possedute.

## Caratteristiche dei Dati
La query elabora e aggrega i dati provenienti dalle seguenti aree:

- *Anagrafica cliente*

- *Gestione conti*: analisi dei conti attivi (Base, Business, Privati, Famiglie)

- *Movimenti finanziari*: calcolo del numero e dell'importo totale delle transazioni, suddivise per segno (entrata/uscita) e per tipologia di conto

## Indicatori Calcolati
Per ogni cliente, la tabella finale include:

- *Età*, calcolata a partire dalla data di nascita

- *Transazioni totali*: conteggio e somma degli importi per entrate (+) e uscite (-)

- *Dettaglio conti*: numero di conti totali e suddivisione per categoria

- *Altre metriche*: indicatori di flusso (numero e importi) specifici per ogni tipologia di conto gestito

## Struttura del Database
Il progetto si basa su un modello relazionale che include le seguenti tabelle:

- cliente: dati anagrafici

- conto: informazioni sui conti correnti

- tipo_conto: descrizione delle categorie di conto

- transazioni: dettaglio dei singoli movimenti finanziari

- tipo_transazione: classificazione del segno della transazione.
