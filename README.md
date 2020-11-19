# UKM-servere
Ideelt skal dette være likt prod-miljøet, men det er fortsatt (siden vi starta i 2014) en tilnærmet utgave. Vi kommer stadig nærmere, og siden restarten i 2020, er håpet at ny struktur etter hvert kan bistå hvis vi også går i retning microservices. Fun times!

### Bidrag
Som all vår kode er også dette repoet under kontinuerlig utvikling, og vi tar gjerne i mot forslag til hvordan vi kan gjøre det bedre!

Installasjon
===
1. Installer [virtualbox](https://www.virtualbox.org/) 
2. Installer [vagrant](http://www.vagrantup.com/)
3. Etterspør [datafiler for utviklermiljø](mailto:support@ukm.no?subject=UKMdev_datafiler)
4. Klon dette repoet til din maskin <br /> 
   f.eks. `$ git clone https://github.com/UKMNorge/servere UKM`
5. Pakk ut datafilene *(fra pkt 3)* [./datapackage](datapackage/) i repoet.
6. Legg til SSL-sertifikatet [./datapackage/UKMNorgeCA.pem](datapackage/UKMNorgeCA.pem) i din keychain / nettleser
7. Når du starter en VM, vil vagrant sjekke at du har riktige vagrant-plugins installert, og eventuelt fortelle deg hvordan du installerer disse.

### Starte opp en VM
Vi anbefaler å starte opp en spesifikk VM, hvor `<role>` er være en av de [ulike VM'ene](#de-ulike-vmene) (`lite`, `main`, `playback`, ~~`videoconverter`~~, ~~`videostorage`~~ eller ~~`videocache`~~). Dette gjør du med:

`$ vagrant up <role> `

For å starte alle VMer (ikke anbefalt):

`$ vagrant up`

### Visual Studio Code
Vi benytter [VScode](https://code.visualstudio.com/download) til vår utvikling (du står selvfølgelig fritt til å velge dette selv), og i repoet finner du derfor en workspace-fil [./UKM.code-workspace](UKM.code-workspace)).

### Hosts
Din lokale hosts-fil blir automatisk oppdatert av [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager), og vagrant vil derfor be om administrator-passord på din maskin under `vagrant up`.

### SSL
Siden vi kjører utvikling på en virtuell server, kreves det kryptert forbindelse mellom den lokale maskinen og den virtuelle serveren. Ingen av sertifikatene eller private key'ene du får tilgang til skal brukes andre steder enn i utviklingsmiljøene.

### Database-tilgang
Etter du har kjørt `vagrant up lite` eller `vagrant up main`, har du tilgang på dev-databasen, f.eks med [Sequel pro](https://sequelpro.com/download). OBS: de to VM'ene kjører hver sin utgave av databasen.

Bruk SSH for å koble til (bytt ut `<repo>` med den faktiske filbanen til repoet på din maskin).

**Lite-maskinen**
```yaml
SSH:
    Host: lite.ukm.dev
    User: vagrant
    Key: <repo>/.vagrant/machines/lite/virtualbox/private_key
```
**Main-maskinen**
```yaml
SSH:
    Host: ukm.dev
    User: vagrant
    Key: <repo>/.vagrant/machines/main/virtualbox/private_key
```
**Felles MySQL-settings for lite og main**
```yaml
MySQL:
    Host: 127.0.0.1
    Username: root
    Password: dev
    Database: ukmdev_dev_ss3 | ukmdelta_db | ukmdev_dev_wp
    Port: 3306
```

# Tips på veien

## MacOs: shared folders
Hvis du hele tiden må skrive inn host-passordet i OS X for å sette opp networking ifbm. NFS og shared folders kan du gjøre det følgende for å fikse på det:

- `sudo visudo` - Bla deg til enden av filen, trykk `i` for å gå i Insert Mode.
- Lim inn følgende (OBS: erstatt `~` med faktisk path): 
```
    Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
    Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
    Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
    Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp ~/.vagrant.d/tmp/hosts.local /etc/hosts
    %admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE, VAGRANT_HOSTMANAGER_UPDATE
```
- Trykk `ESC` for å gå ut av Insert Mode
- Trykk `:w` for å lagre.
- Trykk `:q:` for å avslutte redigering (`:q!` for å avslutte uten å lagre).

## Windows: "The guest additions on this VM do not match the installed version of"
Prøv 
`$ vagrant plugin install vagrant-vbguest` ([takk til Shamli Singh](https://medium.com/@botdotcom/installing-virtualbox-and-vagrant-on-windows-10-2e5cbc6bd6ad))

## Windows: NFS is not supported
Requirements: 
- Windows 10 Pro
- Vagrant <2.2.10 (testet OK med 2.2.5)
- Testet OK med VirtualBox 6.0, Guest Additions 6.0.6.

Se også https://github.com/hashicorp/vagrant/issues/12059

De ulike VM'ene
===

## Lite
Lite-maskinen kan du bruke for å kjøre opp enkle kode-prosjekter. Denne svarer på https://lite.ukm.dev, og alt du putter i `/server_data/lite/` havner i `/var/www/` på VM'en. 

Databasen kjøres lokalt på VM'en med testdata, og du har tilgang til [UKMlib](https://github.com/UKMNorge/UKMAPI/) under `server_data/ukmlib/`.


For å aksessere [UKMlib](https://github.com/UKMNorge/UKMAPI) i koden din, trenger du bare:
```php
require_once('UKM/Autoloader.php');
```

**OBS:** fordi [UKMDesign](https://github.com/UKMNorge/UKMDesign) benytter https://ukm.dev/wp-content/themes/UKMDesign/, og ikke https://grafikk.ukm.dev/ for å hente inn jQuery, css osv, legger lite-maskinen til `ukm.dev` i hostsfilen. Hvis du kjører både lite og main samtidig, bør du manuelt kommentere ut denne linjen inntil videre. Problemet skal rettes i [UKMNorge/UKMapi]().

## Main
"Hoved-serveren vår". Her kjører vi wordpress (https://ukm.dev), og de fleste subdomenene på *.ukm.dev. Gir deg full tilgang til arrangørsystem, påmeldingssystem, nettsider osv. (og fungerer ikke atm 😬)


## Playback
Enkel fillagringsserver som passer på alle filer lastet opp gjennom [mediefiler-funksjonen](https://github.com/UKMNorge/UKMplayback).

## Lage ny VM
**1. Opprett [vagrant/boxconfig/`<role>`.rb](vagrant/boxconfig/)**
```rb
$boxConf['<role>'] = {
    disksize: '10GB',
    memory: '1024',
    ip: '10.0.10.xx',
    hostname: '<role>.ukm.dev'
}
```
>Du kan fortsatt sette opp andre subdomener selv om hostname defineres som subdomene.ukm.dev - dette er bare hoveddomenet for boksen. Bruker du ukm.dev vil du få konflikt med lite eller main-boksen.

**2. Oppdater [Vagrantfile](vagrant/Vagrantfile)**

I utgangspunktet er dette alt du trenger for å sette opp en VM med subdomener. Skal den ikke ha subdomener fjerner du `shareAndConfigureSubdomains()`-linjen.
```rb
config.vm.define "<role>" do |<role>|
    commonConf('<role>', <role>)
    share(<role>, '<role>/www', '/var/www/<role>/')
    shareAndConfigureSubdomains('<role>', <role>, config)
    doProvision('<role>', <role>)
end
```
Funksjoner vi bruker for å sette opp vagrantfile:
>
>**`commonConf(boxName, box)`:** setter opp hostname, ip, disksize etc.
>
>**`shareAndConfigureSubdomains(boxName, box, config)`:** setter opp shared folder mellom `/var/www/<subdomain>/` og host-maskinen for alle subdomener konfigurert i [pillar/ukmbox/subdomains/`<role>`.sls](vagrant/pillar/ukmbox/subdomains), samt konfigurerer hosts-fil for VM og host-maskin.
>
>**`share(box, host_folder, vm_folder)`:** setter opp shared folder mellom host-maskinens `<repo>/shared/<host_folder>`-mappe og gitt `<vm_folder>` på VM'en.
>- **host_folder:** relativ path fra `<repo>/shared/`-mappen
>- **vm_folder:** absolutt path i VM
>
>**`doProvision(boxName, box)`:** kjører salt-provisioning.

**3. Opprett [salt/vagrant-minion-`<role>`](vagrant/salt/)**

De ulike rollene finner du i [salt/top.sls](vagrant/salt/top.sls), og du står selvfølgelig fritt til å kombinere ulike roller - bare ikke kombiner de ulike boks-rollene (`lite`, `main`, `playback` osv), da det vil føre til feilkonfigurasjon.

```yaml
id: vagrant
file_client: local
grains:
    hostname: <role>.ukm.dev
    roles:
        - phpweb
        - ukmbox
        - <role>
```

**4. Definer rollen i [salt/top.sls](vagrant/salt/top.sls)**

Så lenge du husker å ta med `- ukmbox` i steg 3, vil denne filen som oftest være meget enkel:
```yaml
 'roles:<role>':
        - match: grain
        - ukmbox-<role>
```

**5. Definer [salt/ukmbox-`<role>`/init.sls](vagrant/salt)**

Her definerer du magien som salt skal utføre for deg. Typisk er dette opprettelse av www-folder, vhost og en git-clone:

**OBS:** vhost-filens document root er relativ til `/var/www/`, og require - ssl-key-ukm-dev er for å sikre at serveren har tilgang på ssl-key før apache restartes (og trenger den for å serve deg vhost'en).

```yaml
box-<role>-www-folder:
    file.directory:
        - name: /var/www/<role>/

box-<role>-git:
    git.latest:
        - name: https://github.com/...
        - target: /var/www/<role>/

box-<role>-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/<role>.ukm.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: <role>.ukm.dev
            document_root: <role>/
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
            - box-<role>-www-folder
        - watch_in:
            - service: apache
```

**6. Legg til VM'en i [UKM.code-workspace](UKM.code-workspace)**

```json
"folders": [
    [...]
    {
        "path": "./shared/<role>/",
        "name": "VM: <role>"
    },
    [...]
]
```


# Salt-stack
Hver VM (box) har sin egen minion-file i [vagrant/salt](vagrant/salt/). Her defineres de ulike rollene VM'en har.
Alle våre VM'er inkluderer rollen `ukmbox`, som gir oss noen basisverktøy for hurtig konfigurasjon. Videre konfigureres VM'en fra rollen `ukmbox-<role>`, som du selv må definere i [salt](vagrant/salt/).

**OBS:** pillar og salt ligger i vagrant-mappen, men for lesbarhetens skyld er de nedenfor referert som [salt/](vagrant/salt/) eller [pillar/](vagrant/pillar/)

## Subdomener
Installasjon av subdomener er i stor grad automatisert gjennom [salt/ukmbox/subdomains.sls](vagrant/salt/ukmbox/subdomains.sls) og konfigurert i [pillar/ukmbox/subdomains/`<role>`.sls](vagrant/pillar/ukmbox/subdomains/)

### Legge til
1. Rediger [pillar/ukm/subdomains/`<role>`.sls](vagrant/pillar/ukm/subdomains/)
2. Hvis dette er første subdomene for denne VM'en, må du også legge til følgende
linje i [pillar/ukm/init.sls](vagrant/pillar/ukm/init.sls) for å inkludere pillar-filen:
```yaml
{% elif '<role>' in grains['roles'] %}
include:
    - ukm.subdomains.<role>
```

### Konfigurere
Når du definerer subdomener som beskrevet ovenfor, er målet å automatisere mest mulig, og følgende parametre er tilgjengelig:

**`subdomain`:** mappen `/var/www/<subdomain>` opprettes, og vhost configureres.

**`document_root`:** benyttes hvis document root avviker fra `/var/www/<subdomain>` og må spesifiseres med full filbane.

**`github`:** full url til (public) github repo.

**`composer`:** hvis satt til true, kjøres `composer install` etter repo er ferdig klonet.

**`parameters`:** lager en `parameters.yml`-fil plassert som definert i `parameters.target`, basert på template (spesifisert med `parameters.source`). Source kan angis med URL, men er anbefalt angitt med `salt://`


Eksempel-yaml for Symfony-appen "Delta"
```yaml
    delta:
        subdomain: delta
        github: https://github.com/UKMNorge/UKMDelta.git
        composer: true
        document_root: /var/www/delta/web/
        parameters: 
            target: /var/www/delta/app/config/parameters.yml
            source: salt://ukmbox-main/files/params-delta.yml.j2
```

**Avansert:**
I de tilfellene ytterligere konfigurasjon av subdomenet er nødvendig, spesifiseres dette i [salt/ukmbox-`<role>`/subdomains/`<subdomain>`.sls](). Innholdet i denne filen definerer du akkurat som ønsket - bare pass på at du ikke dupliserer funksjonalitet fra standard-konfigurasjonen ovenfor.

Husk at subdomains-filen også må inkluderes fra [salt/ukmbox-`<role>`/subdomains/init.sls](). 

Eksempel på [subdomains/init.sls](vagrant/salt/ukmbox-main/subdomains/init.sls):
```yaml
include:
    - ukmbox-main.subdomains.download
    - ukmbox-main.subdomains.tv
```
