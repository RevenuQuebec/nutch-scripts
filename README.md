nutch-scripts
=============

L'utilisation d'Apache Nutch demande de réexécuter souvent les mêmes commandes de
manières redondantes. Ces scripts ont été créés afin de faciliter l’utilisation de ces commandes.

La manière la plus rapide pour récupérer les fichiers est d’utiliser git et récupérer les fichiers à
partir du dépot de code :
```
$ git clone https://github.com/RevenuQuebec/nutch-scripts.git
```

Pour faciliter l'utilisation des scripts, il est possible d'ajouter la ligne suivante dans le fichier
$HOME/.bashrc :
```
export PATH=$PATH:$HOME/scripts
```

Exemple d'utilisation
Par exemple, pour lancer le parcours complet du site en français jusqu'à l'indexation, les
commandes à exécuter sont :
```
$ cd apache-nutch-1.8-bin-en/
$ export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
$ ./bin/crawl ./urls ../crawl-fr htp://localhost:8080/solr/rq-fr 20
À l’aide des scripts d’administration, la commande est :
$ ./scripts/crawl rq-fr
```

Dans le cas où les insctructions ci-dessus ont été suivies afin d'ajouter la ligne
dans le fichier .bashrc, la commande est :
```
$ crawl rq-fr
```
