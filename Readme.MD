Security groups
- frontend [NGINX]
- backend [NODEJS]
- database [MYSQL]
- bastion

Security group rules

- bastion should accpet connections from laptop [22]

- frontend should accept connections from bastion [80]

- backend should accept connections from bastion [22,8080]
- mysql should accepts connections from bastion [22,3306]

- backend should accept connections from frontend [8080]
- mysql should accept connections from backend [8080]
