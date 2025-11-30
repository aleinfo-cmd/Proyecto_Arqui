import tkinter as tk
from tkinter import filedialog, messagebox

# **********************************************************
# TABLA DE INSTRUCCIONES (R, I, J)
# **********************************************************

INSTRUCTION_TABLE = {
    # ------------------ TIPO R ------------------
    "ADD":  {"type": "R", "opcode": "000000", "funct": "100000"},
    "SUB":  {"type": "R", "opcode": "000000", "funct": "100010"},
    "AND":  {"type": "R", "opcode": "000000", "funct": "100100"},
    "OR":   {"type": "R", "opcode": "000000", "funct": "100101"},
    "SLT":  {"type": "R", "opcode": "000000", "funct": "101010"},
    "NOR":  {"type": "R", "opcode": "000000", "funct": "100111"},

    # ------------------ TIPO I ------------------
    "ADDI": {"type": "I", "opcode": "001000"},
    "STLI": {"type": "I", "opcode": "001010"},
    "ANDI": {"type": "I", "opcode": "001100"},
    "ORI":  {"type": "I", "opcode": "001101"},
    "XORI": {"type": "I", "opcode": "001110"},
    "LW":   {"type": "I", "opcode": "100011"},
    "SW":   {"type": "I", "opcode": "101011"},
    "BEQ":  {"type": "I", "opcode": "000100"},

    # ------------------ TIPO J ------------------
    "J":    {"type": "J", "opcode": "000010"}
}

# **********************************************************
# PARSEADORES PARA CADA TIPO R I J
# **********************************************************

def parse_R(parts, mnemonic, meta):
    """R: MNEMONIC rd, rs, rt"""
    if len(parts) != 4:
        raise ValueError("Formato esperado: ADD $rd $rs $rt")

    rd = parse_register(parts[1])
    rs = parse_register(parts[2])
    rt = parse_register(parts[3])

    return (
        meta["opcode"]
        + f"{rs:05b}"
        + f"{rt:05b}"
        + f"{rd:05b}"
        + "00000"
        + meta["funct"]
    )


def parse_I(parts, mnemonic, meta):
    """
    I: 
        ADDI $rt $rs #imm
        LW   $rt $rs #offset
        SW   $rt $rs #offset
        BEQ  $rs $rt #offset
    """
    if len(parts) != 4:
        raise ValueError("Formato esperado: OPCODE $rt $rs #imm")

    rt = parse_register(parts[1])
    rs = parse_register(parts[2])
    imm = parse_immediate(parts[3])

    return (
        meta["opcode"]
        + f"{rs:05b}"
        + f"{rt:05b}"
        + f"{imm & 0xFFFF:016b}"
    )


def parse_J(parts, mnemonic, meta):
    """
    J #target
    """
    if len(parts) != 2:
        raise ValueError("Formato esperado: J #addr")

    addr = parse_immediate(parts[1])

    return meta["opcode"] + f"{addr & 0x3FFFFFF:026b}"


# **********************************************************
# VALIDACIONES
# **********************************************************

def parse_register(txt):
    if not txt.startswith("$"):
        raise ValueError(f"Registro inválido: {txt}")

    val = int(txt.replace("$", ""))
    if not (0 <= val < 32):
        raise ValueError(f"Registro fuera de rango (0-31): {txt}")

    return val


def parse_immediate(txt):
    if not txt.startswith("#"):
        raise ValueError(f"Inmediato inválido (falta '#'): {txt}")

    return int(txt.replace("#", ""))


# **********************************************************
# DECODIFICADOR
# **********************************************************

def instruccion_a_binario(instr):
    parts = instr.replace(",", " ").split()
    if not parts:
        return ""

    mnemonic = parts[0].upper()

    if mnemonic not in INSTRUCTION_TABLE:
        messagebox.showerror("Error", f"Instrucción inválida o no soportada: {mnemonic}")
        return ""

    meta = INSTRUCTION_TABLE[mnemonic]

    try:
        if meta["type"] == "R":
            bits = parse_R(parts, mnemonic, meta)

        elif meta["type"] == "I":
            bits = parse_I(parts, mnemonic, meta)

        elif meta["type"] == "J":
            bits = parse_J(parts, mnemonic, meta)

        else:
            raise ValueError("Tipo de instrucción desconocido")

    except Exception as e:
        messagebox.showerror("Error de Formato", f"{instr}\n\n{e}")
        return ""

    # Formato BIG ENDIAN → cada 8 bits
    return "\n".join(bits[i:i+8] for i in range(0, 32, 8))


# **********************************************************
# FUNCIONES
# **********************************************************

def convertir():
    salida_bin.delete("1.0", tk.END)
    instrucciones = entrada_instr.get("1.0", tk.END).strip().split("\n")

    resultados = []
    for linea in instrucciones:
        if linea.strip():
            res = instruccion_a_binario(linea.strip())
            if res:
                resultados.append(res)

    if resultados:
        salida_bin.insert(tk.END, "\n\n".join(resultados))
    else:
        messagebox.showwarning("Atención", "No se generó ninguna conversión válida.")


def guardar():
    contenido = salida_bin.get("1.0", tk.END).strip()
    if not contenido:
        messagebox.showwarning("Atención", "No hay nada que guardar.")
        return

    ruta = filedialog.asksaveasfilename(
        defaultextension=".txt",
        filetypes=[("Texto", "*.txt"), ("Todos", "*.*")],
        title="Guardar archivo binario"
    )
    if ruta:
        try:
            with open(ruta, "w") as f:
                f.write(contenido.replace("\n\n", "\n"))
            messagebox.showinfo("Guardado", "Archivo guardado correctamente.")
        except Exception as e:
            messagebox.showerror("Error", str(e))


def limpiar():
    entrada_instr.delete("1.0", tk.END)
    salida_bin.delete("1.0", tk.END)


def abrir_archivo():
    ruta = filedialog.askopenfilename(
        filetypes=[("Texto", "*.txt"), ("Todos", "*.*")],
        title="Abrir archivo"
    )
    if not ruta:
        return

    try:
        with open(ruta, "r") as f:
            contenido = f.read()
        limpiar()
        entrada_instr.insert("1.0", contenido)
    except Exception as e:
        messagebox.showerror("Error", str(e))


# **********************************************************
# INTERFAZ
# **********************************************************

ventana = tk.Tk()
ventana.title("Conversor MIPS R/I/J a Binario")
ventana.geometry("750x500")
ventana.configure(bg="#f0f0f0")

main = tk.Frame(ventana, padx=15, pady=15, bg="#f0f0f0")
main.pack(fill=tk.BOTH, expand=True)

tk.Label(main, text="Instrucciones (una por línea):", font=("Arial", 10, "bold"), bg="#f0f0f0").pack(anchor="w")
entrada_instr = tk.Text(main, width=70, height=6, font=("Courier New", 10))
entrada_instr.pack(pady=5, fill=tk.X)

tk.Label(main, text="Resultado en binario:", font=("Arial", 10, "bold"), bg="#f0f0f0").pack(anchor="w")
salida_bin = tk.Text(main, width=70, height=8, font=("Courier New", 10), bg="#e0e0e0")
salida_bin.pack(pady=5, fill=tk.X)

bot = tk.Frame(main, bg="#f0f0f0")
bot.pack(pady=15)

button_style = {"font": ("Arial", 10, "bold"), "width": 12, "height": 2}
tk.Button(bot, text="Abrir", command=abrir_archivo, bg="#c8e6c9", **button_style).grid(row=0, column=0, padx=10)
tk.Button(bot, text="Convertir", command=convertir, bg="#a2d2ff", **button_style).grid(row=0, column=1, padx=10)
tk.Button(bot, text="Guardar", command=guardar, bg="#bde0fe", **button_style).grid(row=0, column=2, padx=10)
tk.Button(bot, text="Limpiar", command=limpiar, bg="#ffafcc", **button_style).grid(row=0, column=3, padx=10)
tk.Button(bot, text="Salir", command=ventana.destroy, bg="#ffc8dd", **button_style).grid(row=0, column=4, padx=10)

ventana.mainloop()

