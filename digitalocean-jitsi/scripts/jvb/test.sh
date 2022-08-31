pass=wow
domain=madmain


curl --location --request GET 'apollo.domain.com/jvb/set-pass?domain='"$domain"'&password='"$pass"''
curl --location --request GET 'apollo.domain.com/jvb/get-pass?domain='"$domain"''
