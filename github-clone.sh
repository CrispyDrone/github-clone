# $1 = url, $2 = directory, $3 = regex...
set -e

read -p "Username: " U
read -s -p "Password: " P
echo ''

jqfilter=$(echo '.[] | select(.clone_url|test("regex")) | .clone_url' | sed 's/regex/'"${3}"'/')
# echo "${jqfilter}"
repos=$(curl -u "${U}:${P}" "${1}")
repo_urls=$(echo "${repos}" | jq-win64.exe "${jqfilter}")

if [[ ! -d "${2}" ]]
then
	echo "creating directory $2"
	mkdir -p "${2}"
fi

echo "entering directory $2"
cd "${2}"

while read -r repo_url; 
do
	echo "processing repo ${repo_url}"
	git clone $(echo "${repo_url}" | sed 's/"\(.*\)"/\1/')
	echo "finished cloning repo ${repo_url}"
done <<< "${repo_urls}"

echo "finished cloning all repos"
