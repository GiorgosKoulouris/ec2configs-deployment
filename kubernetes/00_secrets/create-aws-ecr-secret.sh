while true; do
  if [ "$ACCOUNT_ID" == '' ]; then
    read -rp "AWS Account ID: " ACCOUNT_ID
    if [ "$ACCOUNT_ID" == '' ]; then
      echo "Account ID cannot be an empty string."
    else
      break
    fi
  else
    break
  fi
done

while true; do
  if [ "$REGION" == '' ]; then
    read -rp "Region: " REGION
    if [ "$REGION" == '' ]; then
      echo "Region cannot be an empty string."
    else
      break
    fi
  else
    break
  fi
done

kubectl create secret docker-registry ec2c-regcreds \
  --docker-server=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=default
