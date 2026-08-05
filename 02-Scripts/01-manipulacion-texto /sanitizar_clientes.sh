#!/bin/bash 
#Procesa un archivo CSV con registros de clientes y anonimiza 
#               datos sensibles (PII/PCI-DSS):
#               - Enmascara correos (mantiene 1ra y última letra del usuario).
#               - Oculta los primeros 12 dígitos de tarjetas de crédito.
FILE="${1:-}"
if [ ! -f "$FILE" ] || [ ! -z "$FILE" ]; then 
	echo "Error: EL archivo '$FILE' no existe o no fue proporcionado" >&2
	exit 1
fi
OUTPUT_FILE="clientes_sanitizados.csv"
sed -E 's/^([^,]+,[^,]+,)([^,])[^,@]+([^,])(@[^,]+,)[0-9]{4}-[0-9]{4}-[0-9]{4}-([0-9]{4})(,.+)$/\1\2***\3\4XXXX-XXXX-XXXX-\5\6/' "$FILE" > "$OUTPUT_FILE"
echo "[OK] Archivo sanitizado guardado correctamente en: $OUTPUT_FILE"
