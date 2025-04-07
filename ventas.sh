ARCHIVO="ventas_2024.csv"

# Verificar si el archivo existe
if [[ ! -f "$ARCHIVO" ]]; then
    echo "El archivo $ARCHIVO no existe."
    exit 1
fi

# Función para calcular el total de productos vendidos
total_productos() {
    total=$(tail -n +2 "$ARCHIVO" | awk -F ";" '{suma += $5} END {print suma}')
    echo "El total de productos vendidos fue: $total"
}

# Función para calcular el monto total de ventas
total_de_ventas() {
    total=$(tail -n +2 "$ARCHIVO" | awk -F ";" '{suma += $6} END {print suma}')
    echo "El monto total de ventas fue: $total"
}

# Función para encontrar la venta más elevada
venta_elevada() {
    max=$(tail -n +2 "$ARCHIVO" | awk -F ";" 'NR == 1 {max = $6} $6 > max {max = $6} END {print max}')
    echo "La venta más elevada fue: $max"
}

# Función para buscar ventas por fecha
buscar_por_fecha() {
    read -p "Ingrese la fecha deseada en el formato [YYYY-MM-DD]: " fecha
    echo "Ventas registradas el $fecha:"
    tail -n +2 "$ARCHIVO" | awk -F ";" -v date="$fecha" '$1 == date {print $2, "-", $3, "-", $5, "unidades -", "$" $6}'
}

# Función para calcular total de ventas por mes
ventas_por_mes() {
    echo "Ventas por mes:"
    tail -n +2 "$ARCHIVO" | awk -F ";" '{
        split($1, fecha, "-");
        mes = fecha[1] "-" fecha[2];
        ventas[mes] += $6;
    }
    END {
        for (m in ventas) {
            printf "%s: $%.2f\n", m, ventas[m]
        }
    }' | sort
}

# Función para encontrar el producto más vendido
producto_mas_vendido() {
    echo "Producto más vendido:"
    tail -n +2 "$ARCHIVO" | awk -F ";" '{productos[$3] += $5}
    END {
        for (p in productos) {
            if (productos[p] > max) {
                max = productos[p];
                prod = p;
            }
        }
        print prod, "con", max, "unidades vendidas";
    }'
}

# Función para calcular el monto total anual
monto_total_anual() {
    total=$(tail -n +2 "$ARCHIVO" | awk -F ";" '{suma += $6} END {print suma}')
    echo "El monto total anual de ventas fue: $total"
}

# Función para encontrar el cliente más frecuente
cliente_mas_frecuente() {
    echo "Cliente más frecuente:"
    tail -n +2 "$ARCHIVO" | awk -F ";" '{clientes[$2]++}
    END {
        for (c in clientes) {
            if (clientes[c] > max) {
                max = clientes[c];
                cliente = c;
            }
        }
        print cliente, "con", max, "compras";
    }'
}

# Menú principal
echo "Elija un reporte"
echo "1. Total de productos vendidos"
echo "2. Monto total de ventas"
echo "3. Venta más elevada"
echo "4. Ventas por fecha"
echo "5. Ventas por mes"
echo "6. Producto más vendido"
echo "7. Monto total anual"
echo "8. Cliente más frecuente"
echo "9. Finalizar"

read -p "Elija la opción deseada: " reporte

case $reporte in
    1) total_productos ;;
    2) total_de_ventas ;;
    3) venta_elevada ;;
    4) buscar_por_fecha ;;
    5) ventas_por_mes ;;
    6) producto_mas_vendido ;;
    7) monto_total_anual ;;
    8) cliente_mas_frecuente ;;
    9) echo "Finalizando el programa" ;;
    *) echo "Opción no válida" ;;
esac