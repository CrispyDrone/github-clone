# $1 = url, $2 = directory, $3 = regex...
# exit script on error
set -e

# constants
user_or_org_url_regex='^https:\/\/api\.github\.com\/(users|orgs)\/[^\/]*$'
user_or_org_repos_url_regex='^https:\/\/api\.github\.com\/(users|orgs)\/[^\/]*\/repos$'
link_header_next_url_regex='.*<\(.*\)>;\s*rel="next".*'
last_page_number_regex='.*rel="next",\s*<[^?]*.*page=\(.*\)>;\s*rel="last"'
headers_file='headers.txt'
link_header='Link:'

# variables
user_or_org_url="${1}"
user_or_org_repos_url="${1}/repos"
directory="${2:-.}"
regex="${3:-'*'}"
jq_filter=$(echo ".[] | select(.clone_url|test(\"regex\";\"i\")) | .clone_url" | sed 's/regex/'"${regex}"'/')
current_page=0
total_number_of_pages=1

# verify url
if [[ ! ${user_or_org_url} =~ ${user_or_org_url_regex} ]]
then
	echo "Url is not a valid user or organization url. Url should be of the format https://api.github.com/users/<user> or https://api.github.com/orgs/<org>"
	exit 1;
fi

echo "${user_or_org_url}"
echo "${user_or_org_repos_url}"
echo "${jq_filter}"

# request user name and password for github request
read -p "Username: " UserName
read -s -p "Password: " Password
echo ''

# while more than 1 page remaining, treat repos, execute request again with 'rel="next"' url until no more next i.e. final url
while [[ ${current_page} -le ${total_number_of_pages} ]] && [[ ! ${user_or_org_repos_url} == '' ]]
do
	current_page=$((current_page + 1))

	# fetch repos
	paginated_repos=$(curl -u "${UserName}:${Password}" --progress-bar --dump-header "${headers_file}" "${user_or_org_repos_url}")
	link_header_response_value=$(grep "${link_header}" "${headers_file}")
	user_or_org_repos_url=$(grep "${link_header}" "${headers_file}" | sed "/${link_header_next_url_regex}/!d;s//\1/")

	# verify response
	echo "${paginated_repos}"
	echo "${user_or_org_repos_url}"

	if [[ ${current_page} -eq 1 ]]
	then
		total_number_of_pages=$(grep "${link_header}" "${headers_file}" | sed 's/'"${last_page_number_regex}"'/\1/')
		echo "Total number of pages: ${total_number_of_pages:-1}"
	fi

	# execute filter
	repo_urls=$(echo "${paginated_repos}" | jq-win64.exe "${jq_filter}")

	if [[ "${repo_urls}" == '' ]]
	then
		echo "Filter returned no repos."
		continue;
	fi

	# verify
	echo "${repo_urls}"

	if [[ ! -d "${directory}" ]]
	then
		echo "creating directory $directory"
		mkdir -p "${directory}"
	fi

	if [[ ! $PWD == $directory ]]
	then
		echo "entering directory $directory"
		cd "${directory}"
	fi

	while read -r repo_url;
	do
		echo "processing repo ${repo_url}"
		git clone $(echo "${repo_url}" | sed 's/"\(.*\)"/\1/')
		echo "finished cloning repo ${repo_url}"
	done <<< "${repo_urls}"
done

echo "finished cloning all repos"
exit 0
