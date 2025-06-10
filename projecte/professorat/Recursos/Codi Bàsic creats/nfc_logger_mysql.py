
import time
import board
import busio
import adafruit_pn532.i2c
import mysql.connector
from mysql.connector import Error

# Configura la connexió I2C per al lector PN532
i2c = busio.I2C(board.SCL, board.SDA)
pn532 = adafruit_pn532.i2c.PN532_I2C(i2c, debug=False)

pn532.SAM_configuration()

print("Esperant targeta NFC...")

# Connexió amb la base de dades MySQL
try:
    conn = mysql.connector.connect(
        host='localhost',      # o IP del servidor MySQL
        user='usuari',         # posa el teu usuari
        password='contrasenya',# i contrasenya
        database='assistencia_nfc'
    )

    cursor = conn.cursor()

    while True:
        uid = pn532.read_passive_target(timeout=0.5)
        if uid is None:
            continue

        uid_str = ''.join(['{:02X}'.format(i) for i in uid])
        print(f"Targeta detectada: {uid_str}")

        # Comprovar si la targeta està registrada
        cursor.execute("SELECT id_targeta FROM targetes WHERE id_targeta = %s", (uid_str,))
        if cursor.fetchone():
            # Inserir accés
            cursor.execute(
                "INSERT INTO accessos (id_targeta, accio) VALUES (%s, %s)",
                (uid_str, "entrada")
            )
            conn.commit()
            print("Accés registrat correctament.\n")
        else:
            print("⚠️ Targeta no registrada!\n")

        time.sleep(1)

except Error as e:
    print("Error amb la base de dades:", e)

except KeyboardInterrupt:
    print("Aturat per l'usuari")

finally:
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("Connexió MySQL tancada")
