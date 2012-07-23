#!/usr/bin/env zsh

main() {
    setopt extendedglob
    case $1 in
        ("")
            echo "Error: need arguments!" >&2
            return 1
        ;;

        ([0-9]##)
            if (( $1 > 0 && $1 <= 12 ))
            then
                local output cipher newchar collong foo
                for ((i=1;i<=$1;++i))
                do
                    newchar=(${$(($[${RANDOM}%16][##16])):l})
                    cipher=(${newchar} ${cipher})
                    output=(${newchar} ${output})
                    (( ($i % 2) == 0 )) && cipher=(: ${cipher})
                done

                newchar=(${output})
                for ((i=${#output};i<12;++i))
                do
                    newchar=(0 ${newchar})
                done

                for j in ${(Oa)newchar}
                do
                    collong=($j $collong)
                    foo=(${collong//:/})
                    (( (${#foo} % 2) == 0 && ${#foo} < 12 )) &&  collong=(: $collong)
                    set +x
                done

                echo "${${(j::)collong}/#00:00:00/fe:ff:ff}"
                return 0
            else
                echo "Error: too much!" >&2
                return 1
            fi
        ;;
          *) echo baz;;
    esac
}

[[ -z $1 ]] && main 6 || main $1

#
#
# btw - found this on this url
# - http://superuser.com/questions/218340/bash-how-to-generate-a-valid-random-mac-adress-with-shell
# bash
# hexchars="0123456789ABCDEF"
# end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/-\1/g' )
# echo 00-60-2F$end
# vim: ft=zsh sw=4 ts=4 et
