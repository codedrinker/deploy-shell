IN="A"
for i in $(echo $IN | tr ";" "\n")
do
  # process
  echo $i
done