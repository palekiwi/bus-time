URL=https://pda.5284.gov.taipei/MQS/StopLocationDyna?stoplocationid=

STOPLOCATIONID=8603

declare -A lines=( [645]=21743 [902]=27677 )

DATA=$(curl -s ${URL}${STOPLOCATIONID})

getTime() {
    SEC=$(echo ${DATA} | jq ".Stop[] | select(.id==${1}).n1" | awk -F"," '{ print $8 }')
    echo $SEC
}

formatTime() {
    SEC=$1
    if [ $SEC -lt 180 ]; then
        echo "arriving"
    else
        echo "$(($SEC / 60)) mins"
    fi
}

printTime() {
    NAME=$1
    ID=$2
    RES=$(getTime $ID)

    notify-send "$NAME" "$(formatTime $RES)"
}

run() {
    for key in "${!lines[@]}"; do printTime $key ${lines[$key]}; done
}

run
