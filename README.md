# UKM-servere
Ideelt skal dette være likt prod-miljøet, men det er fortsatt (siden vi starta i 2014) en tilnærmet utgave. Vi kommer stadig nærmere, og siden restarten i 2020, er håpet at ny struktur etter hvert kan bistå hvis vi også går i retning microservices. Fun times!

### Bidrag
Som all vår kode er også dette repoet under kontinuerlig utvikling, og vi tar gjerne i mot forslag til hvordan vi kan gjøre det bedre!

Installasjon
===
1. Installer [virtualbox](https://www.virtualbox.org/) 
2. Installer [vagrant](http://www.vagrantup.com/)
3. Etterspør [datafiler for utviklermiljø](mailto:support@ukm.no?subject=UKMdev_datafiler)
4. Klon dette repoet til din maskin
5. Pakk ut datafilene (fra pkt 3) i repoet, under `salt/ukmlib/datapackage/`
6. Flytt `salt/ukmlib/datapackage/init.sls` til `pillar/ssl/init.sls`
6. Legg til SSL-sertifikatet `salt/ukmlib/datapackage/UKMNorgeCA.pem` i din keychain / nettleser
7. Når du starter en VM, vil vagrant sjekke at du har riktige vagrant-plugins installert, og eventuelt fortelle deg hvordan du installerer disse.

### Starte opp en VM
Vi anbefaler å starte opp en spesifikk VM, hvor role kan være `lite`, ~~`web`, `playback`, `videoconverter`, `videostorage` eller `videocache`~~. Dette gjør du med:

`$ vagrant up <role> `

For å starte alle VMer (ikke anbefalt):

`$ vagrant up`

### Visual Studio Code
Vi benytter [VScode](https://code.visualstudio.com/download) til vår utvikling (du står selvfølgelig fritt til å velge dette selv), og i repoet finner du derfor en workspace-fil (`/UKM.code-workspace`).

### Hosts
Din lokale hosts-fil blir automatisk oppdatert av [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager), og vagrant vil derfor be om administrator-passord på din maskin under `vagrant up`.

### SSL
Siden vi kjører utvikling på en virtuell server, kreves det nå kryptert forbindelse mellom den lokale maskinen og den virtuelle serveren. Ingen av sertifikatene eller private keyene du får tilgang til skal brukes andre steder enn i utviklingsmiljøene.