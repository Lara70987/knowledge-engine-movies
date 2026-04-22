import csv
import re
import unicodedata
from pathlib import Path

INPUT_CSV = "2015.csv"
OUTPUT_PL = "base_felicidade.pl"

def normalize_atom(text: str) -> str:
    text = text.strip().lower()
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^a-z0-9]+", "_", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text

def as_float(value: str) -> str:
    return str(float(value))

def main() -> None:
    input_path = Path(INPUT_CSV)
    output_path = Path(OUTPUT_PL)

    with input_path.open(newline="", encoding="utf-8") as f_in, output_path.open("w", encoding="utf-8") as f_out:
        reader = csv.DictReader(f_in)
        for row in reader:
            pais = normalize_atom(row["Country"])
            regiao = normalize_atom(row["Region"])
            rank = int(row["Happiness Rank"])
            score = as_float(row["Happiness Score"])
            gdp = as_float(row["Economy (GDP per Capita)"])
            saude = as_float(row["Health (Life Expectancy)"])
            liberdade = as_float(row["Freedom"])
            confianca = as_float(row["Trust (Government Corruption)"])
            generosidade = as_float(row["Generosity"])

            fato = (
                f"felicidade({pais},{regiao},{rank},{score},"
                f"{gdp},{saude},{liberdade},{confianca},{generosidade}).\n"
            )
            f_out.write(fato)

    print(f"Base Prolog gerada em: {OUTPUT_PL}")

if __name__ == "__main__":
    main()