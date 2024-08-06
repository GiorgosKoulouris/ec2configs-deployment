print_line() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' .
}

INV_FILE=./01-hosts.ini
SOURCE_REPO=https://github.com/GiorgosKoulouris/ec2configs-source.git

pre_checks() {
    echo
    print_line
    echo "Executing pre-checks.."
    echo

    ansible_ssh_key="$(grep 'ansible_ssh_private_key_file' "$INV_FILE" | awk -F '=' {'print $2'})"
    if [ -f $ansible_ssh_key ]; then
        echo "Ansible SSH key exists..."
    else
        echo "Ansible SSH key ($ansible_ssh_key) does not exist. Exiting..."
        exit 1
    fi

    ssh-keygen -y -e -f "$ansible_ssh_key" &>/dev/null
    if [ "$?" -ne 0 ]; then
        echo "Ansible SSH key ($ansible_ssh_key) is not valid. Exiting..."
        exit 1
    else
        echo "Ansible SSH key is valid..."
    fi

    certFile=../configs/ssl_certs/ec2configs.pem
    openssl x509 -inform PEM -in $certFile &>/dev/null
    if [ "$?" -ne 0 ]; then
        echo "SSL certificate ($certFile) is not valid. Exiting..."
        exit 1
    else
        echo "SSL certificate is valid..."
    fi

    keyFile=../configs/ssl_certs/ec2configs-key.pem
    openssl rsa -inform PEM -in $keyFile &>/dev/null
    if [ "$?" -ne 0 ]; then
        echo "SSL certificate key ($keyFile) is not valid. Exiting..."
        exit 1
    else
        echo "SSL certificate key is valid..."
    fi

}

create_user_pre() {
    echo
    print_line
    echo "EC2C admin user options..."
    echo

    EC2C_ADMIN=ec2cadmin
    read -p "Enter username for the new user (Default: ec2cadmin): " NEW_USER
    if [ "$NEW_USER" != '' ]; then
        EC2C_ADMIN="$NEW_USER"
    fi

    read -s -p "Enter password for $EC2C_ADMIN: " password
    echo

    PASSWORD_HASH=$(ansible all -i localhost, -m debug -a "msg={{ '$password' | password_hash('sha512', 'lefkvhbjekv') }}" |
        awk -F'"msg": "' '{print $2}' | awk -F'"' '{print $1}' | grep -v "^$")

    grep -q 'ec2cadmin_ssh_public_key_file' "$INV_FILE"
    if [ "$?" -ne 0 ]; then
        echo
        echo "ec2cadmin_ssh_public_key_file variable does not exist in inventory file ($INV_FILE)."
        echo "Exiting..."
        exit 1
    fi

    EC2CADMIN_SSH_KEY_FILE="$(grep 'ec2cadmin_ssh_public_key_file' "$INV_FILE" | awk -F '=' {'print $2'})"

    if [ "$EC2CADMIN_SSH_KEY_FILE" == "" ]; then
        echo
        echo "ec2cadmin_ssh_public_key_file variable is set as an empty string ($INV_FILE)."
        echo "Exiting..."
        exit 1
    fi

    if [ ! -f "$EC2CADMIN_SSH_KEY_FILE" ]; then
        echo
        echo "Specified SSH key not found ($EC2CADMIN_SSH_KEY_FILE)."

        while true; do
            read -rp "Create new SSH key? (./ssh/$EC2C_ADMIN and ./ssh/$EC2C_ADMIN.pub). This will also modify the inventory file to match the new key. (y/n): " yn
            case $yn in
            [Yy]*)
                echo "Creating a new SSH key for user $EC2C_ADMIN at .ssh/$EC2C_ADMIN. Please store your private key in a safe place afterwards."
                ssh-keygen -t rsa -b 4096 -f "./ssh/$EC2C_ADMIN" -C "$EC2C_ADMIN"
                echo
                echo "Modifying inventory file"
                sed -i'' -e "s|ec2cadmin_ssh_public_key_file=$EC2CADMIN_SSH_KEY_FILE|ec2cadmin_ssh_public_key_file=./ssh/$EC2C_ADMIN.pub|" "$INV_FILE"
                break
                ;;
            [Nn]*)
                echo "Cannot proceed without a valid key. Exiting..."
                exit 1
                ;;
            *)
                echo "Please answer y or n."
                ;;
            esac
        done

    else
        echo
        echo "Specified SSH key for user $EC2C_ADMIN found."
        ssh-keygen -y -e -f "$EC2CADMIN_SSH_KEY_FILE" &>/dev/null
        if [ "$?" -eq 0 ]; then
            echo "Key for user $EC2C_ADMIN is valid."
        else
            echo "The specified SSH key is invalid. Make sure $EC2CADMIN_SSH_KEY_FILE is a valid SSH key."
            echo
            while true; do
                read -rp "Create new SSH key? (./ssh/$EC2C_ADMIN and ./ssh/$EC2C_ADMIN.pub). This will also modify the inventory file to match the new key. (y/n): " yn
                case $yn in
                [Yy]*)
                    echo "Creating a new SSH key for user $EC2C_ADMIN at .ssh/$EC2C_ADMIN. Please store your private key in a safe place afterwards."
                    ssh-keygen -t rsa -b 4096 -f "./ssh/$EC2C_ADMIN" -C "$EC2C_ADMIN"
                    echo
                    echo "Modifying inventory file"
                    sed -i'' -e "s|ec2cadmin_ssh_public_key_file=$EC2CADMIN_SSH_KEY_FILE|ec2cadmin_ssh_public_key_file=./ssh/$EC2C_ADMIN.pub|" "$INV_FILE"
                    break
                    ;;
                [Nn]*)
                    echo "Cannot proceed without a valid key. Exiting..."
                    exit 1
                    ;;
                *)
                    echo "Please answer y or n."
                    ;;
                esac
            done
        fi
    fi
}

edit_inventory_pre() {
    echo
    print_line
    echo "Edit the inventory file..."
    sleep 2
    vi "$INV_FILE"
}

ha_options_pre() {
    echo
    print_line
    echo "High Availability options..."
    echo

    while true; do
        read -rp "Is it a HA deployment (proxy + multiple app hosts)? (y/n): " yn
        case $yn in
        [Yy]*)
            BEHIND_PROXY='true'
            break
            ;;
        [Nn]*)
            BEHIND_PROXY='false'
            break
            ;;
        *)
            echo "Please answer y or n."
            ;;
        esac
    done

    if [ "$BEHIND_PROXY" == 'true' ]; then
        while true; do
            read -rp "Enter the subnet of the backend hosts (CIDR): " subnet
            if [ "$subnet" == '' ]; then
                echo "Subnet cannot be an empty string."
            else
                BACKEND_SUBNET="$subnet"
                break
            fi
        done

        while true; do
            read -rp "Enter the ip of the main backend host (affects only the NFS mounts): " host
            if [ "$host" == '' ]; then
                echo "IP cannot be an empty string."
            else
                MAIN_BACKEND_HOST="$host"
                break
            fi
        done
    fi
}

disk_options_pre() {
    echo
    print_line
    echo "Dedicated appData disk options..."
    echo

    APPDATA_DISKNAME=''
    while true; do
        read -rp "Have you attached a dedicated disk for the application data? On HA scenarios this disk MUST be attached to the node you selected as the main one (y/n): " yn
        case $yn in
        [Yy]*)
            APPDATA_DISK_ATTACHED='true'
            while true; do
                read -rp "Enter the name of the disk, WITHOUT the /dev prefix (example: nvme1n1): " diskname
                if [ "$diskname" == '' ]; then
                    echo "Disk name cannot be empty."
                else
                    APPDATA_DISKNAME="$diskname"
                    break
                fi
            done
            break
            ;;
        [Nn]*)
            APPDATA_DISK_ATTACHED='false'
            break
            ;;
        *)
            echo "Please answer y or n."
            ;;
        esac
    done
}

db_options_pre() {
    echo
    print_line
    echo "EC2C database options..."
    echo

    while true; do
        read -sp "Enter the password of the db user (ec2cdbuser): " pw
        if [ "$pw" == '' ]; then
            echo "Password cannot be empty."
        else
            DB_USER_PASSWORD="$pw"
            echo
            break
        fi
    done
}

backend_options_pre() {
    echo
    print_line
    echo "Backend deployment options..."
    echo

    while true; do
        read -rp "Modify the unit file? (y/n): " yn
        case $yn in
        [Yy]*)
            vi ../configs/backend/ec2c.service
            break
            ;;
        [Nn]*)
            break
            ;;
        *)
            echo "Please answer y or n."
            ;;
        esac
    done
}

frontend_options_pre() {
    echo
    print_line
    echo "Frontend deployment options..."
    echo

    while true; do
        read -rp "Modify the environment file? (y/n): " yn
        case $yn in
        [Yy]*)
            vi ../configs/frontend/.env
            break
            ;;
        [Nn]*)
            break
            ;;
        *)
            echo "Please answer y or n."
            ;;
        esac
    done

    while true; do
        read -rp "Enter the domain (server name) for nginx listeners (by default, this redirects www.mydomain.tld to mydomain.tld, so do not include www): " dmn
        if [ "$dmn" == '' ]; then
            echo "Domain/name cannot be empty."
        else
            DOMAIN="$dmn"
            echo "Creating configuration files..."
            break
        fi
    done

    cat <<'EOF' >../configs/frontend/nginx-behind-proxy.conf
log_format mformat '$remote_addr - [$time_local] "$request" $status $body_bytes_sent "$http_user_agent" "$gzip_ratio"';

server {
EOF
    echo "    server_name $DOMAIN;" >>../configs/frontend/nginx-behind-proxy.conf
    cat <<'EOF' >>../configs/frontend/nginx-behind-proxy.conf
    listen 80;
  
    location / {
        root /usr/share/nginx/ec2configs;
        include /etc/nginx/mime.types;
        try_files $uri $uri/ /index.html;
        access_log  /var/log/nginx/access.log mformat;
  }
}

server {
    listen 80;
EOF
    echo "     server_name www.$DOMAIN;" >>../configs/frontend/nginx-behind-proxy.conf
    echo "     return 301 \$scheme://$DOMAIN\$request_uri;" >>../configs/frontend/nginx-behind-proxy.conf
    echo "     access_log  /var/log/nginx/access.log mformat;" >>../configs/frontend/nginx-behind-proxy.conf
    echo "}" >>../configs/frontend/nginx-behind-proxy.conf

    cat <<'EOF' >../configs/frontend/nginx-no-proxy.conf
log_format mformat '$remote_addr - [$time_local] "$request" $status $body_bytes_sent "$http_user_agent" "$gzip_ratio"';

server {
EOF

    echo "    server_name $DOMAIN;" >>../configs/frontend/nginx-no-proxy.conf
    cat <<'EOF' >>../configs/frontend/nginx-no-proxy.conf
    listen 443 ssl http2;
    ssl_certificate /etc/nginx/certs/ec2configs.pem;
    ssl_certificate_key /etc/nginx/certs/ec2configs-key.pem;

    location / {
        root /usr/share/nginx/ec2configs;
        include /etc/nginx/mime.types;
        try_files $uri $uri/ /index.html;
        access_log  /var/log/nginx/frontend.log mformat;
    }
  
    location /api/ {
        proxy_pass http://localhost:30002;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        access_log  /var/log/nginx/backend.log mformat;
    }
}

server {
    listen 443 ssl;
EOF
    cat <<'EOF' >>../configs/frontend/nginx-no-proxy.conf
    ssl_certificate /etc/nginx/certs/ec2configs.pem;
    ssl_certificate_key /etc/nginx/certs/ec2configs-key.pem;
EOF
    echo "      server_name www.$DOMAIN;" >>../configs/frontend/nginx-no-proxy.conf
    echo "      return 301 \$scheme://$DOMAIN\$request_uri;" >>../configs/frontend/nginx-no-proxy.conf
    echo "      access_log  /var/log/nginx/access.log mformat;" >>../configs/frontend/nginx-no-proxy.conf
    echo "}" >>../configs/frontend/nginx-no-proxy.conf

}

proxy_options_pre() {
    echo
    print_line
    echo "Proxy deployment options..."
    echo

    if [ "$BEHIND_PROXY" == 'false' ]; then
        echo "No HA deployment will be configured. Skipping..."
    else

        cat <<'EOF' >../configs/proxy/proxy.conf
log_format proxyFormat '$remote_addr - [$time_local] "$request" $status $body_bytes_sent "$http_user_agent" "$gzip_ratio"';

upstream frontend {
    least_conn;
}
upstream backend {
    least_conn;
}

server {
EOF
        echo "  server_name $DOMAIN;" >>../configs/proxy/proxy.conf
        cat <<'EOF' >>../configs/proxy/proxy.conf
  listen 443 ssl http2;
  ssl_certificate /etc/nginx/certs/ec2configs.pem;
  ssl_certificate_key /etc/nginx/certs/ec2configs-key.pem;

  location / {
    proxy_pass http://frontend;
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_send_timeout 300;
    access_log  /var/log/nginx/frontend.log proxyFormat;
  }
  location /api/ {
    proxy_pass http://backend;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    access_log  /var/log/nginx/backend.log proxyFormat;
  }
}

server {
EOF
        echo "  server_name $DOMAIN;" >>../configs/proxy/proxy.conf
        echo "  return 301 \$scheme://$DOMAIN\$request_uri;" >>../configs/proxy/proxy.conf
        cat <<'EOF' >>../configs/proxy/proxy.conf
  listen 443 ssl;
  ssl_certificate /etc/nginx/certs/ec2configs.pem;
  ssl_certificate_key /etc/nginx/certs/ec2configs-key.pem;
  access_log  /var/log/nginx/access.log proxyFormat;
}
EOF

        read -rp "Type the IP of your frontend host: " ip
        echo "    server $ip;" >../configs/proxy/frontend.ini
        while true; do
            read -rp "Add another host? (y\n): " action
            case $action in
            [Yy]*)
                read -rp "Type the IP of your frontend host: " ip
                echo "    server $ip;" >>../configs/proxy/frontend.ini
                ;;
            [Nn]*)
                break
                ;;
            *)
                echo "Please answer y or n."
                ;;
            esac
        done

        echo

        read -rp "Type the IP of your backend host: " ip
        echo "    server $ip:30002;" >../configs/proxy/backend.ini
        while true; do
            read -rp "Add another host? (y\n): " action
            case $action in
            [Yy]*)
                read -rp "Type the IP of your frontend host: " ip
                echo "    server $ip:30002;" >>../configs/proxy/backend.ini
                ;;
            [Nn]*)
                break
                ;;
            *)
                echo "Please answer y or n."
                ;;
            esac
        done

    fi

}

os_bootstrap() {
    ansible-playbook os_bootstrap.yml -i 01-hosts.ini -e \
        "patch=true \
        ansible_become_password=$ANSIBLE_BECOME_PASS"
}

create_user() {
    ansible-playbook os_create_user.yml -i 01-hosts.ini -e \
        "username=$EC2C_ADMIN \
        password=$PASSWORD_HASH \
        ansible_become_password=$ANSIBLE_BECOME_PASS"
}

deploy_db() {
    ansible-playbook app_deploy_db.yml -i 01-hosts.ini -e \
        "dbuser_password=$DB_USER_PASSWORD \
        ansible_become_password=$ANSIBLE_BECOME_PASS"
}

deploy_backend() {
    ansible-playbook app_deploy_backend.yml -i 01-hosts.ini -e \
        "source_repo=$SOURCE_REPO \
        username=$EC2C_ADMIN \
        ha_configured=$BEHIND_PROXY \
        main_host=$MAIN_BACKEND_HOST \
        appdata_disk_configured=$APPDATA_DISK_ATTACHED \
        appdata_diskname=$APPDATA_DISKNAME \
        ansible_become_password=$ANSIBLE_BECOME_PASS"

    if [ "$BEHIND_PROXY" == 'true' ]; then

        ansible-playbook os_config_nfs_mounts.yml -i 01-hosts.ini -e "username=$EC2C_ADMIN  \
            allowed_subnet=$BACKEND_SUBNET \
            main_host=$MAIN_BACKEND_HOST \
            ansible_become_password=$ANSIBLE_BECOME_PASS"
    fi
}

deploy_frontend() {
    ansible-playbook app_deploy_frontend.yml -i 01-hosts.ini -e \
        "source_repo=$SOURCE_REPO \
        behind_proxy=$BEHIND_PROXY \
        username=$EC2C_ADMIN \
        ansible_become_password=$ANSIBLE_BECOME_PASS"
}

deploy_proxy() {
    if [ "$BEHIND_PROXY" == 'true' ]; then
        ansible-playbook app_deploy_proxy.yml -i 01-hosts.ini \
            -e "ansible_become_password=$ANSIBLE_BECOME_PASS"
    fi
}

ask_ansible_become_pass() {

    while true; do
        read -sp "Enter ansible become password: " pw
        if [ "$pw" == '' ]; then
            echo "Password cannot be empty."
        else
            ANSIBLE_BECOME_PASS="$pw"
            echo
            break
        fi
    done

}

main() {
    pre_checks

    ask_ansible_become_pass
    edit_inventory_pre
    create_user_pre
    db_options_pre
    ha_options_pre
    disk_options_pre
    backend_options_pre
    frontend_options_pre
    proxy_options_pre

    os_bootstrap
    create_user
    deploy_db
    deploy_backend
    deploy_frontend
    deploy_proxy
}

main $@
