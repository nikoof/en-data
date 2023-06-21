#!/bin/bash

# Copyright (c) 2023 Nicolas Bratoveanu

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

check_command() {
  if ! command -v -- "$@" > /dev/null 2>&1; then
    printf >&2 "%s\n" "$@ not found"
    return 1
  fi
}

usage() {
  printf "%s\n" "Usage: $(basename $0) [-c] [-o]"
  printf "%s\n" "-c COUNTY      Specify which county's data to download. If unset will"
  printf "%s\n" "               download all counties by default."
  printf "%s\n" "-y YEAR        Specify from which year to download. If unset will"
  printf "%s\n" "               default to the current year."
  printf "%s\n" "-o FILE        Write output to file. If unset will output to stdout."
}

check_command "jq" && check_command "curl" && check_command "date" || exit 1

COUNTIES="AB AR AG BC BH BN BT BV BR B BZ CS CL CJ CT CV DB DJ GL GR GJ HR HD IL IS IF MM MH MS NT OT PH SM SJ SB SV TR TM TL VS VL VN"
YEAR=$(date +%Y)

while getopts ":c:o:y:" OPTION; do
  case "$OPTION" in
    c)
      COUNTIES=$OPTARG
      ;;
    o)
      exec >$OPTARG
      ;;
    y)
      YEAR=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

CSV_HEADER="county,name,school,ri,ra,rf,mi,ma,mf,lmp,lmi,lma,lmf,mev"
JQ_FILTER=".[] | [.county, .name, .school, .ri, .ra, .rf, .mi, .ma, .mf, .lmp, .lmi, .lma, .lmf, .mev] | @csv"

printf "%s\n" $CSV_HEADER
for COUNTY in $COUNTIES; do
  ENDPOINT="http://static.evaluare.edu.ro/$YEAR/rezultate/$COUNTY/data/candidate.json"
  curl -s "$ENDPOINT" | jq -r "$JQ_FILTER"
done
