nutch-scripts
=============

L'utilisation d'Apache Nutch demande de réexécuter souvent les mêmes commandes de
manières redondantes. Ces scripts ont été créés afin de faciliter l’utilisation de ces commandes.

Les scripts doivent toujours recevoir en entrée le nom du *core* Apache Solr sur lequel les opérations doivent être effectuées.

## Installation

La manière la plus rapide pour récupérer les fichiers est d’utiliser git et récupérer les fichiers à
partir du dépôt de code :
```
$ git clone https://github.com/RevenuQuebec/nutch-scripts.git
```

Pour faciliter l'utilisation des scripts, il est possible d'ajouter la ligne suivante dans le fichier
$HOME/.bashrc :
```
export PATH=$PATH:$HOME/scripts
```

## Exemple d'utilisation

Par exemple, pour lancer le parcours complet du site en français jusqu'à l'indexation, les
commandes standard à exécuter en utilisant directement Apache Nutch sont :
```
$ cd apache-nutch-bin-en/
$ export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
$ ./bin/crawl ./urls ../crawl-fr htp://localhost:8080/solr/rq-fr 20
À l’aide des scripts d’administration, la commande est :
$ ./scripts/crawl rq-fr
```

Dans le cas où les instructions ci-dessus ont été suivies afin d'ajouter la ligne
dans le fichier .bashrc, la commande à utiliser est :
```
$ crawl rq-fr
```

## Documentation des différents scripts

Les scripts prennent en compte que l'installation d'Apache Nutch est effectuée dans le répertoire **$HOME/apache-nutch-*\<core\>***. Par exemple, pour un *core* nommé **rq-fr**, l'installation d'Apache Nutch est **$HOME/apache-nutch-rq-fr**.

Il est possible de réutiliser la même installation d'Apache Nutch en créant des liens symboliques. Par contre, la configuration des *cores* sera exactement pareille.

Les scripts prennent également en compte que le *crawldb* d'Apache Nutch se trouvera dans le répertoire **$HOME/crawldb-*\<core\>***. Par exemple, pour un *core* nommé **rq-fr**, le répertoire contenant le *crawldb* est **$HOME/crawldb-rq-fr**.

### crawl

La commande *crawl* permet de lancer le parcours du site web. Les données sont enregistrées dans le *crawldb* d'Apache Nutch.

**Note**: La liste des URLs à parcourir doit se trouver dans un fichier enregistré dans le répertoire *urls* se trouvant à la base de l'installation d'Apache Nutch.

**Note**: L'installation d'Apache Solr doit être disponible à l'URL **http://localhost:8080/solr/**.

**Note**: Par défaut, la profondeur maximale parcourue est de 20.

```
$ crawl rq-fr
```

### deleteCrawl

Raccourcis pour supprimer le répertoire *crawldb* pour un *core* donné lorsqu'il est désiré de recommencer le parcours du site web à partir de zéro. Les données indexées dans le *core* Apache Solr ne sont pas supprimées.

```
$ deleteCrawl rq-fr
```

### deleteIndex

Permets de vider l'index Apache Solr pour un *core* donné. Les données du *crawldb* ne sont pas supprimées.

```
$ deleteIndex rq-fr
```

### reindex

Permets de réindexer l'ensemble des pages web d'un *core* à partir des pages contenues dans le *crawldb*.

**Note**: Si l'index d'Apache Solr contient déjà des pages web et que certaines de ces pages ne sont plus présentes sur le site web, elles ne sont pas supprimées par la réindexation standard. Ce script commence donc par vider entièrement l'index d'Apache Solr pour être sûr d'avoir un index propre.

**Note**: Suite à une réindexation réussie, ce script lance également une optimisation de l'index.

```
$ reindex rq-fr
```

### optimizeIndex

Permets d'optimiser l'index d'un *core* Apache Solr suite à un changement majeur aux données indexées.

```
$ optimizeIndex rq-fr
```

### removeurl

Permets de supprimer une ou plusieurs URL d'un *crawldb* pour un *core* donné. L'URL à supprimer est sous la forme d'une expression régulière. Il est donc possible de supprimer de l'index une section entière.

**Note**: Après la suppression des données du *crawldb*, les données ne sont pas réindexées dans Apache Solr. Il faut ensuite manuellement réindexer les pages, si désiré.

```
$ removeurl rq-fr "^http:\/\/www\.[^\/]+\/(fr|en)\/partenaires\/.*$"
```

### stats

Permets de récupérer les statistiques du *crawldb* pour un *core* donné. Ces données permettent d'avoir des informations de base sur le contenu du *crawldb* (ex: nombre d'URL trouvées, score minimum et maximum pour l'ensemble des pages, statistiques sur l'état des pages, nombre de pages à récupérer, etc.).

```
$ stats rq-fr
Statistics for CrawlDb: /home/ubuntu/crawl-rq-fr/crawldb
TOTAL urls:     6303
retry 0:        6303
min score:      0.0
avg score:      0.0028278597
max score:      2.112
status 2 (db_fetched):  206
status 4 (db_redir_temp):       235
status 5 (db_redir_perm):       136
status 6 (db_notmodified):      5485
status 7 (db_duplicate):        241
CrawlDb statistics: done
```

Le script permet également d'avoir des informations sur une page précise afin de savoir si elle est présente dans le *crawldb*.

```
$ stats rq-fr http://www.revenuquebec.ca/fr/citoyen/pens_alim/defiscalisation.aspx
URL: http://www.revenuquebec.ca/fr/citoyen/pens_alim/defiscalisation.aspx
Version: 7
Status: 6 (db_notmodified)
Fetch time: Thu Aug 14 00:17:02 EDT 2014
Modified time: Wed Dec 31 19:00:00 EST 1969
Retries since fetch: 0
Retry interval: 345600 seconds (4 days)
Score: 0.009113262
Signature: 3f8759dd4e37c2fe171a5542daa84635
Metadata:
        Content-Type=text/html
        _pst_=success(1), lastModified=0
        _rs_=191
```

**Note**: Si la page n'est pas présente dans l'index, cela veut dire qu'elle n'a pas été récupérée à l'étape du parcours du site. Il est possible d'avoir plus d'informations sur les raisons pour lesquelles c'est le cas en utilisant les commandes *parsechecker* ou *indexchecker* d'Apache Nutch.

**Note**: Pour plus de détails sur le contenu du *crawldb*, il est possible d'utiliser directement la commande readdb d'Apache Nutch. Par exemple, pour obtenir l'ensemble des pages qui ont l'état de redirection temporaire :
```
$HOME/apache-nutch-rq-fr/bin/nutch readdb $HOME/crawl-rq-fr/crawldb -dump $HOME/crawldb-dump -status db_redir_temp
```

### search-cron

Ce script peut être utilisé à travers une tâche planifiée afin de gérer l'ensemble du parcours et de la réindexation d'un site web de manière quotidienne à partir de la configuration d'un *core*.

Le script commence par faire un *backup* du *crawldb* au cas où un problème surviendrait lors du parcours et provoquerait une corruption du *crawldb*. Si une erreur survient à cette étape, le *backup* est automatiquement restauré.

Ensuite, le script procède à une réindexation entière des pages web. Étant donné que la réindexation supprime entièrement le contenu de l'index Apache Solr, le script procède à un maximum de 5 tentatives afin d'avoir un index rempli.

Le script prend en entrée le nom des répertoires où seront enregistrés les fichiers de *logs* (standard et erreurs) et copiés les données pour le *backup* du *crawldb*.

```
search-cron $HOME/logs $HOME/backups
```

Il est possible d'utiliser le script de la manière suivante pour avoir une mise à jour à minuit et une suppression des *backups* et des fichiers de *logs* plus vieux de 2 jours à 1h00 :
```
$ crontab -e
0 0 * * * $HOME/scripts/search-cron $HOME/logs $HOME/backups;
0 1 * * * find $HOME/logs/ -type f -ctime +2 -exec rm -rf {} \;
0 1 * * * find $HOME/backups/ -type d -ctime +2 -exec rm -rf {} \;
```

### copyConfig

Ce script permet de copier les différents fichiers de configuration requis afin de recréer une copie de l'installation d'Apache Solr et d'Apache Nutch pour un *core* donné.

Le script crée l'archive compressée **$HOME/config-*\<core\>*.tar.bz2** à l'aide de l'ensemble des fichiers de configuration. Par exemple, pour un *core* nommé **rq-fr**, l'archive est **$HOME/config-rq-fr.tar.bz2**

```
$ copyConfig rq-fr
```
