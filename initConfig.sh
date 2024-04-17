#!/bin/bash

helpFunction()
{
  echo ""
  echo "Usage: $0 -f configuration folder path (-i) (-r root CA file path) (-p password) (-m modules)"
  echo -e "\t-f Configurations folder path"
  echo -e "\t-i Run in interactive mode (optional)"
  echo -e "\t-r Specify root CA (optional)"
  echo -e "\t-p Override default password (ignored in interactive mode) (optional)"
  echo -e "\t-m Specify the module(s), if no module given then the configuration for all modules is created (optional)"
  exit 1 # Exit script after printing help
}

# shellcheck disable=SC2086
import_cert_into_trustore()
{
  certstore_fullpath=$1
  certstore_alias=$2
  certstore_cert_fullpath=$3

  keytool -keystore "$certstore_fullpath" -alias "$certstore_alias" -import -file "$certstore_cert_fullpath" \
          $interactive_params_keytool
}

# shellcheck disable=SC2086
create_certificate()
{
local create_keystore=false
local create_truststore=false
local module_name=$1
local default_common_name=$2

if [ -n "$3" ];
then
  create_keystore="$3"
fi

if [ -n "$4" ];
then
  create_truststore="$4"
fi

if [ -z "$default_common_name" ];
then
  default_common_name="$module_name"
fi

# certificate locations
module_path="$configuration_path/$module_name"
cert_conf_fullpath="$module_path/$module_name.cnf"
cert_sign_request_fullpath="$module_path/$module_name.csr"
cert_key_fullpath="$module_path/$module_name-key.pem"
cert_fullpath="$module_path/$module_name.pem"
pkcs_fullpath="$module_path/$module_name.p12"
keystore_fullpath="$module_path/keystore.jks"
truststore_fullpath="$module_path/truststore.jks"

# default certificate parameters
cert_conf=$(cat << EOF
HOME            = .

####################################################################
[ req ]
default_bits       = 4096
default_keyfile    = $module_name-key.pem
distinguished_name = cert_distinguished_name
req_extensions     = cert_req_extensions
string_mask        = utf8only

####################################################################
[ cert_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default = $default_country

stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = $default_state

localityName         = Locality Name (eg, city)
localityName_default = $default_locality

organizationName            = Organization Name (eg, company)
organizationName_default    = $default_organization

organizationalUnitName         = Organizational Unit (eg, division)
organizationalUnitName_default = $default_organization_unit

commonName           = Common Name (e.g. server FQDN or YOUR name)
commonName_default   = $default_common_name

#emailAddress         = Email Address
#emailAddress_default = test@example.com

####################################################################
[ cert_req_extensions ]

subjectKeyIdentifier = hash
basicConstraints     = CA:FALSE
keyUsage             = digitalSignature, keyEncipherment
subjectAltName       = @alternate_names

####################################################################
[ alternate_names ]

DNS.1  = localhost
DNS.2  = $default_common_name

IP.1   = 127.0.0.1
EOF
)

# Create module directory if not existing
mkdir -p "$module_path"

# generate certificate
echo "$cert_conf" > "$cert_conf_fullpath"

openssl req -newkey rsa:4096 -sha256 -keyout "./$cert_key_fullpath" -keyform PEM -nodes \
            $interactive_params_req \
            -config "./$cert_conf_fullpath" \
            -out "./$cert_sign_request_fullpath" -outform PEM

openssl ca  -notext -policy signing_policy -extensions signing_req \
            $interactive_params_ca \
            -config "./$ca_conf_fullpath" \
            -out "./$cert_fullpath" \
            -infiles "./$cert_sign_request_fullpath"

if [[ "$create_keystore" == "true" ]];
then
  openssl pkcs12 -export -in "./$cert_fullpath" -inkey "./$cert_key_fullpath" \
                 -out "$pkcs_fullpath" -name "$module_name" \
                 -CAfile "$ca_certificate_fullpath" -caname CARoot \
                 $interactive_params_pkcs12

  rm "$keystore_fullpath"

  keytool -importkeystore -deststoretype PKCS12 -destkeystore "$keystore_fullpath" -alias "$module_name" \
          -srckeystore "$pkcs_fullpath" -srcstoretype PKCS12 \
          $interactive_params_importkeystore

  import_cert_into_trustore "$keystore_fullpath" CARoot "$ca_certificate_fullpath"
fi

if [[ "$create_truststore" == "true" ]];
then
  rm "$truststore_fullpath"

  import_cert_into_trustore "$truststore_fullpath" CARoot "$ca_certificate_fullpath"
fi
}

# known modules
mhealthatlas_modules=("keycloak" "frontend" "app" "rating" "taxonomy" "user" "gateway" "consul" "elasticstack" "enterprise" "mhealthatlas-user" "enterprise-app")

# parse arguments
# shellcheck disable=SC2003
while getopts ":f:ir:p:m:" opt
do
  case "$opt" in
    f ) configuration_path="$OPTARG" ;;
    i ) interactive=true ;;
    r ) ca_path="$OPTARG" ;;
    p ) password="$OPTARG" ;;
    m ) modules+=("$OPTARG")
        while [ "$OPTIND" -le "$#" ] && [ "${!OPTIND:0:1}" != "-" ]; do
          modules+=("${!OPTIND}")
          OPTIND="$(expr $OPTIND \+ 1)"
        done
        ;;
    ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# Print helpFunction in case requried parameters are empty
if [ -z "$configuration_path" ]
then
  echo "Not all required parameters given";
  helpFunction
fi
# Create configuration directory if not existing
mkdir -p "$configuration_path"

# set the default password
default_password="mEd@3[-]"
# override the default password
if [ -n "$password" ]
then
  default_password="$password"
fi

# Set interactive mode to false if not set
if [ -z "$interactive" ]
then
  interactive_params_x509="-batch -passin pass:$default_password -passout pass:$default_password"
  interactive_params_req="-batch"
  interactive_params_ca="-batch -passin pass:$default_password"
  interactive_params_pkcs12="-passout "pass:$default_password""
  interactive_params_importkeystore="-deststorepass $default_password -srcstorepass $default_password -noprompt"
  interactive_params_keytool="-deststorepass $default_password -noprompt"
else
  interactive_params_x509=""
  interactive_params_req=""
  interactive_params_ca=""
  interactive_params_pkcs12=""
  interactive_params_importkeystore=""
  interactive_params_keytool=""
fi

# if no module provided initialize all known modules
# check if module names are valid
if [ ${#modules[@]} -eq 0 ];
then
  modules=("${mhealthatlas_modules[@]}")
else
  for module in "${modules[@]}"; do
    is_valid=false
    for validModule in "${mhealthatlas_modules[@]}"; do
      if [[ "$module" == "$validModule" ]];
      then
        is_valid=true
      fi
    done

    if [[ "$is_valid" == false ]]; then
      echo "Module $module is unknown."
      helpFunction
    fi
  done
fi

# default openssl parameters
default_country="DE"
default_state="Berlin"
default_locality="Berlin"
default_organization="MediQSoft"
default_organization_unit="MHealthAtlas"
default_ca_common_name="MediQSoft Root CA"

# setting location
setting_dir=".openssl"

# ca certificates locations
ca_certificate_file="cacert.pem"
ca_key_file="cakey.pem"
ca_conf_file="caconf.cnf"

# default ca certificate parameters
ca_conf=$(cat << EOF
HOME            = .

####################################################################
[ ca ]
default_ca    = CA_default      # The default ca section

[ CA_default ]
base_dir      = ./$configuration_path
certificate   = \$base_dir/$ca_certificate_file   # The CA certifcate
private_key   = \$base_dir/$ca_key_file           # The CA private key
new_certs_dir = \$base_dir/$setting_dir                     # Location for new certs after signing
database      = \$base_dir/$setting_dir/index.txt           # Database index file
serial        = \$base_dir/$setting_dir/serial.txt          # The current serial number

default_days     = 1000         # How long to certify for
default_crl_days = 1000         # How long before next CRL
default_md       = sha256       # Use public key default MD
preserve         = no           # Keep passed DN ordering
unique_subject   = no           # Set to 'no' to allow creation of several certificates with same subject.

x509_extensions = ca_extensions # The extensions to add to the cert

email_in_dn     = no            # Don't concat the email in the DN
copy_extensions = copy          # Required to copy SANs from CSR to cert

####################################################################
[ req ]
default_bits       = 4096
default_keyfile    = $ca_key_file
distinguished_name = ca_distinguished_name
x509_extensions    = ca_extensions
string_mask        = utf8only

####################################################################
[ ca_distinguished_name ]
countryName         = Country Name (2 letter code)
countryName_default = $default_country

stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = $default_state

localityName                = Locality Name (eg, city)
localityName_default        = $default_locality

organizationName            = Organization Name (eg, company)
organizationName_default    = $default_organization

organizationalUnitName         = Organizational Unit (eg, division)
organizationalUnitName_default = $default_organization_unit

commonName         = Common Name (e.g. server FQDN or YOUR name)
commonName_default = $default_ca_common_name

#emailAddress         = Email Address
#emailAddress_default = test@test.com

####################################################################
[ ca_extensions ]

subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always, issuer
basicConstraints       = critical, CA:true
keyUsage               = keyCertSign, cRLSign

####################################################################
[ signing_policy ]
countryName            = optional
stateOrProvinceName    = optional
localityName           = optional
organizationName       = optional
organizationalUnitName = optional
commonName             = supplied
emailAddress           = optional

####################################################################
[ signing_req ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, keyEncipherment
EOF
)


if [ -z "$ca_path" ];
then
  # set path to root CA
  ca_certificate_fullpath="$configuration_path/$ca_certificate_file"
  ca_key_fullpath="$configuration_path/$ca_key_file"
  ca_conf_fullpath="$configuration_path/$ca_conf_file"

  #remove old artifacts
  rm "./$configuration_path/$setting_dir/index.txt"
  rm "./$configuration_path/$setting_dir/index.txt.old"
  rm "./$configuration_path/$setting_dir/index.txt.attr"

  rm "./$configuration_path/$setting_dir/serial.txt"
  rm "./$configuration_path/$setting_dir/serial.txt.old"

  find "./$configuration_path/$setting_dir" -maxdepth 1 -type f -name '*.pem' -delete

  # generate root CA
  mkdir "./$configuration_path/$setting_dir"
  echo 01 > "./$configuration_path/$setting_dir/serial.txt"
  touch "./$configuration_path/$setting_dir/index.txt"
  echo "$ca_conf" > "$ca_conf_fullpath"

  # shellcheck disable=SC2086
  openssl req -x509 -newkey rsa:4096 -sha256 \
              $interactive_params_x509 \
              -config "./$ca_conf_fullpath" \
              -out "./$ca_certificate_fullpath" -outform PEM \
              -keyout "./$ca_key_fullpath" -keyform PEM
else
  # set path to root CA
  ca_certificate_fullpath="$configuration_path/$ca_certificate_file"
  ca_key_fullpath="$configuration_path/$ca_key_file"
  ca_conf_fullpath="$configuration_path/$ca_conf_file"
fi

#  "rating" "taxonomy" "user" "gateway"
# generate for the requested modules the certificates and env files
for module in "${modules[@]}"; do
  case "$module" in
    elasticstack ) create_certificate elasticsearch
                   create_certificate kibana
                   create_certificate filebeat
                   create_certificate logstash
                   ;;
    consul ) create_certificate consul1 server.dc1.consul
             create_certificate consul2 server.dc1.consul
             create_certificate consul3 server.dc1.consul
             ;;
    frontend ) create_certificate frontend mhealthatlas
               ;;
    keycloak ) create_certificate keycloak mhealthatlas-keycloak
               create_certificate keycloak_proxy keycloak-proxy
               ;;
    store ) create_certificate store store-apps-service true true
          ;;
    app ) create_certificate app mhealthatlas-apps-service true true
          ;;
    rating ) create_certificate rating mhealthatlas-rating-service true true
             ;;
    taxonomy ) create_certificate taxonomy mhealthatlas-taxonomy-service true true
               ;;
    user ) create_certificate user mhealthatlas-user-management-service true true
           ;;
    enterprise ) create_certificate enterprise enterprise-management-service true true
           ;;
    mhealthatlas-user ) create_certificate mhealthatlas-user mhealthatlas-user-service true true
           ;;
    enterprise-app ) create_certificate enterprise-app enterprise-apps-service true true
           ;;
    gateway ) create_certificate gateway mhealthatlas-gateway true true
              ;;
    * ) echo "Module $module is unknown."
        helpFunction
        ;;
  esac
done
