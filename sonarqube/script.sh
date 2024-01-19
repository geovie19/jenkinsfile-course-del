# https://github.com/SonarSource/sonar-scanner-cli/releases

sudo apt update -y
sudo apt install nodejs npm wget unzip -y

sonar_scanner_version="5.0.1.3006"                 
wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonar_scanner_version}-linux.zip
unzip sonar-scanner-cli-${sonar_scanner_version}-linux.zip
sudo mv sonar-scanner-${sonar_scanner_version}-linux sonar-scanner
sudo rm -rf  /var/opt/sonar-scanner || true
sudo mv sonar-scanner /var/opt/
sudo rm -rf /usr/local/bin/sonar-scanner || true
sudo ln -s /var/opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/ || true
sonar-scanner -v


