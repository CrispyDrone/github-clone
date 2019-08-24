# $1 = url, $2 = directory, $3 = regex...
set -e

read -p "Username: " UserName
read -s -p "Password: " Password
echo ''

url="${1}"
directory="${2:-.}"
regex="${3:-'*'}"

jqfilter=$(echo '.[] | select(.clone_url|test("regex", "i")) | .clone_url' | sed 's/regex/'"${regex}"'/')
repos=$(curl -u "${UserName}:${Password}" "${url}")
repo_urls=$(echo "${repos}" | jq-win64.exe "${jqfilter}")

if [[ ! -d "${directory}" ]]
then
	echo "creating directory $directory"
	mkdir -p "${directory}"
fi

echo "entering directory $directory"
cd "${directory}"

while read -r repo_url; 
do
	echo "processing repo ${repo_url}"
	git clone $(echo "${repo_url}" | sed 's/"\(.*\)"/\1/')
	echo "finished cloning repo ${repo_url}"
done <<< "${repo_urls}"

echo "finished cloning all repos"
