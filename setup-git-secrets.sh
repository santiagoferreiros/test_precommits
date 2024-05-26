# Configurar git-secrets
git secrets --install
git secrets --register-aws

# Agregar patrones comunes
git secrets --add 'private_key'
git secrets --add 'PRIVATE KEY'
git secrets --add 'BEGIN RSA PRIVATE KEY'
git secrets --add 'BEGIN DSA PRIVATE KEY'
git secrets --add 'BEGIN EC PRIVATE KEY'
git secrets --add 'BEGIN OPENSSH PRIVATE KEY'
git secrets --add 'BEGIN PGP PRIVATE KEY BLOCK'
git secrets --add 'AKIA[0-9A-Z]{16}'
git secrets --add 'ASIA[0-9A-Z]{16}'
git secrets --add 'A3T[A-Z0-9]{13}'
git secrets --add 'ACCA[A-Z0-9]{10}'
git secrets --add 'xox[baprs]-[0-9a-zA-Z]{10,48}'

# Ejecutar escaneo de secretos
git secrets --scan