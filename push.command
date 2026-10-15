#!/bin/bash

# Si sposta automaticamente nella cartella in cui si trova questo file
cd "$(dirname "$0")"

# Funzione interna per disegnare la barra di avanzamento grafica
mostra_barra() {
    local percentuale=$1
    local messaggio=$2
    local larghezza=40
    local completati=$((percentuale * larghezza / 100))
    local restanti=$((larghezza - completati))
    
    # Costruisce la stringa visiva della barra
    local barra=""
    for ((i=0; i<completati; i++)); do barra="${barra}█"; done
    for ((i=0; i<restanti; i++)); do barra="${barra}░"; done
    
    # Cancella la riga precedente e stampa la barra aggiornata
    printf "\r[%s] %d%% - %s" "$barra" "$percentuale" "$messaggio"
}

# ─────────────────────────────────────────────────────────────
# FASE 1: Rilevamento e indicizzazione dei nuovi materiali
# ─────────────────────────────────────────────────────────────
mostra_barra 10 "Analisi della cartella in corso..."
sleep 0.5
git add .
mostra_barra 35 "Materiali indicizzati con successo!"
sleep 0.5

# ─────────────────────────────────────────────────────────────
# FASE 2: Preparazione del pacchetto Git (Commit)
# ─────────────────────────────────────────────────────────────
mostra_barra 50 "Creazione del pacchetto di studio..."
DATA_ORA=$(date "+%Y-%m-%d %H:%M:%S")
MESSAGGIO="Aggiornamento materiali studio ($DATA_ORA)"
# Esegue il commit reindirizzando gli output testuali per non rompere la barra grafica
git commit -m "$MESSAGGIO" > /dev/null 2>&1
mostra_barra 70 "Pacchetto pronto per l'invio!"
sleep 0.5

# ─────────────────────────────────────────────────────────────
# FASE 3: Trasferimento dei file su GitHub (Push)
# ─────────────────────────────────────────────────────────────
mostra_barra 85 "Connessione a GitHub e invio dati..."
git push > /dev/null 2>&1

# Controllo di sicurezza se il push fallisce (es. mancanza di internet)
if [ $? -ne 0 ]; then
    printf "\n❌ [ERRORE] Il caricamento su GitHub è fallito! Controlla la connessione.\n"
    read -p "Premi Invio per chiudere..."
    exit 1
fi

# Completamento dell'operazione
mostra_barra 100 "Tutto caricato con successo!"
printf "\n\n✅ Fatto! Ora puoi andare sulla tua App di Claude e premere il tasto Sync.\n"

# Mantiene aperta la schermata per 4 secondi per farti leggere il successo
sleep 3
