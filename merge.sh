function output_spec(){
    F="${1}"
    FNR="${2}"
    EXCLUDE="${3:-}"

    head -1 "${F}" | awk -F "\t" '{
            rs = ""
            for(i = 1; i <= NF; ++i){
                if(i != exclude){
                    if(rs != ""){
                        rs = rs ","
                    }

                    rs = rs fnr "." i
                }
            }

            print rs
        }' fnr="${FNR}" exclude="${EXCLUDE}"
}

function merge(){
    F1="${1}"
    F2="${2}"
    C1="${3}"
    C2="${4}"

    O="$(output_spec "${F1}" "1"),$(output_spec "${F2}" "2" "${C2}")"
    join -t "	" -i --header -o "${O}" -1 ${C1} -2 ${C2} \
        <(head -1 "${F1}"; tail -n +2 "${F1}" | sort -t "	" -f -k${C1},${C1}) \
        <(head -1 "${F2}"; tail -n +2 "${F2}" | sort -t "	" -f -k${C2},${C2})
}
