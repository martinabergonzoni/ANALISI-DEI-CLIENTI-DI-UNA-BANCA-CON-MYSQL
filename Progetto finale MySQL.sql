CREATE TABLE tabella_client AS

SELECT
    c.id_cliente,

    #   1. Indicatore di base: Età
    TIMESTAMPDIFF(YEAR, c.data_nascita, CURDATE()) AS eta_cliente,

    #   2. Indicatori sulle transazioni
    ##   Conto le righe in base al segno '+' o '-'
    COUNT(CASE WHEN tt.segno = '-' THEN 1 END) AS nr_transazioni_uscita_tot,
    COUNT(CASE WHEN tt.segno = '+' THEN 1 END) AS nr_transazioni_entrata_tot,

    ##  Sommo gli importi. Ho usato ABS per evitare che negli importi in uscita risultasse il segno -

    COALESCE(ABS(SUM(CASE WHEN tt.segno = '-' THEN t.importo ELSE 0 END)), 0) AS importo_uscita_tot,
    COALESCE(SUM(CASE WHEN tt.segno = '+' THEN t.importo ELSE 0 END), 0) AS importo_entrata_tot,

    #   3. Indicatori sui conti
    ##   Conteggio l numero totale di conti posseduti dal cliente
    COUNT(DISTINCT co.id_conto) AS numero_totale_conti,

    ##   Per ogni tipologia di conto, ne effettuo un conteggio e restituisco il valore
    COUNT(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Base' THEN co.id_conto END) AS nr_conti_base,
    COUNT(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Business' THEN co.id_conto END) AS nr_conti_business,
    COUNT(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Privati' THEN co.id_conto END) AS nr_conti_privati,
    COUNT(DISTINCT CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' THEN co.id_conto END) AS nr_conti_famiglie,

    #   4. Indicatori sulle transazioni per tipologia di conto
    ## Indicatori di nr entrate/nr uscite/importo in uscita/importo in entrata per "Conto Base"
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Base' AND tt.segno = '-' THEN 1 END) AS nr_trans_uscita_base,
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Base' AND tt.segno = '+' THEN 1 END) AS nr_trans_entrata_base,
    COALESCE(ABS(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Base' AND tt.segno = '-' THEN t.importo ELSE 0 END)), 0) AS importo_uscita_base,
    COALESCE(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Base' AND tt.segno = '+' THEN t.importo ELSE 0 END), 0) AS importo_entrata_base,

    ## Indicatori di nr entrate/nr uscite/importo in uscita/importo in entrata per "Conto Business"
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Business' AND tt.segno = '-' THEN 1 END) AS nr_trans_uscita_business,
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Business' AND tt.segno = '+' THEN 1 END) AS nr_trans_entrata_business,
    COALESCE(ABS(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Business' AND tt.segno = '-' THEN t.importo ELSE 0 END)), 0) AS importo_uscita_business,
    COALESCE(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Business' AND tt.segno = '+' THEN t.importo ELSE 0 END), 0) AS importo_entrata_business,

    -## Indicatori di nr entrate/nr uscite/importo in uscita/importo in entrata per "Conto Privati"
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' AND tt.segno = '-' THEN 1 END) AS nr_trans_uscita_privati,
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' AND tt.segno = '+' THEN 1 END) AS nr_trans_entrata_privati,
    COALESCE(ABS(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' AND tt.segno = '-' THEN t.importo ELSE 0 END)), 0) AS importo_uscita_privati,
    COALESCE(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' AND tt.segno = '+' THEN t.importo ELSE 0 END), 0) AS importo_entrata_privati,

    ## Indicatori di nr entrate/nr uscite/importo in uscita/importo in entrata per "Conto Famiglie"
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' AND tt.segno = '-' THEN 1 END) AS nrtrans_uscita_famiglie,
    COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' AND tt.segno = '+' THEN 1 END) AS nr_trans_entrata_famiglie,
    COALESCE(ABS(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' AND tt.segno = '-' THEN t.importo ELSE 0 END)), 0) AS importo_uscita_famiglie,
    COALESCE(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' AND tt.segno = '+' THEN t.importo ELSE 0 END), 0) AS importo_entrata_famiglie

#   Aggrego le tabelle del database per mostrare correttamente i valori selezionati nella nuova tabella
FROM cliente c
LEFT JOIN conto co ON c.id_cliente = co.id_cliente
LEFT JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
LEFT JOIN transazioni t ON co.id_conto = t.id_conto
LEFT JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione

GROUP BY c.id_cliente, c.data_nascita;