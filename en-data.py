import requests
import bs4
import csv
import time
from string import digits

COUNTIES = ["AB", "AR", "AG", "BC", "BH", "BN", "BT", "BV", "BR", "B", "BZ", "CS", "CL", "CJ", "CT", "CV", "DB", "DJ", "GL", "GR", "GJ", "HR", "HD", "IL", "IS", "IF", "MM", "MH", "MS", "NT", "OT", "PH", "SM", "SJ", "SB", "SV", "TR", "TM", "TL", "VS", "VL", "VN"]

def get_page_count(html_src) -> int:
    soup = bs4.BeautifulSoup(html_src, "html.parser")
    return int(soup("select")[0]("option")[-1]["value"])

def get_pages(endpoint, county):
    headers = {
        "Host": "evaluare.edu.ro",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "keep-alive",
        "Referer": "http://evaluare.edu.ro/Evaluare/RapoarteJ.aspx?jud=1",
        "Upgrade-Insecure-Requests": "1",
        "Pragma": "no-cache",
        "Cache-Control": "no-cache",
    }
    html = requests.get(endpoint, headers=headers, params={"Jud": county, "PageN": 1}).text
    page_count = get_page_count(html)
    
    for i in range(1, page_count + 1):
        yield requests.get(endpoint, headers=headers, params={"Jud": county, "PageN": i}).text


def parse_page(html_src):
    soup = bs4.BeautifulSoup(html_src, "html.parser")
    rows = soup("table", class_="mainTable")[0]("tr")[2:]

    def parse_float(s: str) -> float | None:
        try:
            return float(s)
        except ValueError:
            return None

    candidates = []
    for row in rows:
        fields = [field.string for field in row("td")]
        candidates.append({
            "county":        fields[1].translate(str.maketrans("", "", digits)),
            "name":          fields[1],
            "school":        fields[3],
            "rom_init":      parse_float(fields[4]),
            "rom_contest":   parse_float(fields[5]),
            "rom_final":     parse_float(fields[6]),
            "mate_init":     parse_float(fields[7]),
            "mate_contest":  parse_float(fields[8]),
            "mate_final":    parse_float(fields[9]),
            "limba_materna": fields[10],
            "lm_init":       parse_float(fields[11]),
            "lm_contest":    parse_float(fields[12]),
            "lm_final":      parse_float(fields[13]),
            "final_grade":   parse_float(fields[14]),
        })

    return candidates

def main():
    with open("2023.csv", "w", newline="") as f:
        endpoint = "http://evaluare.edu.ro/Evaluare/CandFromJudAlfa.aspx"
        fieldnames = ["county", "name", "school", "rom_init", "rom_contest", "rom_final", "mate_init", "mate_contest", "mate_final", "limba_materna", "lm_init", "lm_contest", "lm_final", "final_grade"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writerow({i: i for i in fieldnames})
        for county in range(1, 43):
            print(f"Getting data for county {COUNTIES[county - 1]}...")
            for i, page in enumerate(get_pages(endpoint, county)):
                print(f"* Page {i + 1}/{get_page_count(page)}")
                writer.writerows(parse_page(page))

if __name__ == "__main__":
    main()
