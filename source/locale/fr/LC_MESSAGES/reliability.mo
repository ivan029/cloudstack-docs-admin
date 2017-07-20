��    E      D  a   l      �     �       	        '     @     E  4   J  w    &   �       O  9     �	     �	  >   �	  e   �	  )   R
  3   |
  3   �
  .   �
       .   3  �  b  [        b     o     �     �     �  "   �  �   �  q  �  V      )   w  E  �      �       u     �   �     ]  $   s     �     �  &   �    �  j   �     V  (   b     �  
  �  �  �  N     �   l  K  	  �   U  >  �  2  '  �   Z     �  ,  �  �   $!  �   �!    X"    g#  �   u$  J   e%  �   �%  �   �&  �   !'  �  (     �)     �)  	   
*     *     -*     2*  K   7*  �  �*  ?   ,  +   T,  �  �,     9.     P.  F   d.  �   �.  )   9/  3   c/  4   �/  /   �/      �/  /   0  7  M0  �   �2     3     3     73     S3     X3  9   f3    �3  �  �4  r   |6  =   �6  �  -7  ,   �8     �8  �   �8  *  �9     �:  6   �:  	   ;     ;  8   %;  f  ^;  x   �<     >=  (   J=     s=  :  w=  �  �>  \   o@  �   �@  �  �A  �   /D  �  �D  �  �F  �   iI     DJ  �  HJ  �   �K  �   �L  5  eM  :  �N  0  �O  ]   Q  .  eQ  �   �R  �   S     %      (       !       E       *   B           9   6         7          .            <             /       2   ?             D       :       
           =   3   8              #          &   1   -                 	      A                   +          C       )         4          ,      0   5   $       ;   @                         '          >   "        **Optional Settings** **Required Settings** 80 or 443 8080 (or 20400 with AJP) 8096 8250 Be sure you have set the following in db.properties: CloudStack can use a load balancer to provide a virtual IP for multiple Management Servers. The administrator is responsible for creating the load balancer rules for the Management Servers. The application requires persistence or stickiness across multiple sessions. The following chart lists the ports that should be load balanced and whether or not persistence is required. Configuring Database High Availability Database High Availability Database replication in CloudStack is provided using the MySQL replication capabilities. The steps to set up replication can be found in the MySQL documentation (links are provided below). It is suggested that you set up two-way replication, which involves two database nodes. In this case, for example, you might have node1 and node2. Dedicated HA Hosts Destination Port Even if persistence is not required, enabling it is permitted. Events from the database side are not integrated with the CloudStack Management Server events system. Example: ``db.cloud.initialTimeout=3600`` Example: ``db.cloud.queriesBeforeRetryMaster=5000`` Example: ``db.cloud.secondsBeforeRetryMaster=3600`` Example: ``db.cloud.slaves=node2,node3,node4`` Example: ``db.ha.enabled=true`` Example: ``db.usage.slaves=node2,node3,node4`` For a Zone that has only one secondary storage server, a secondary storage outage will have feature level impact to the system but will not impact running guest VMs. It may become impossible to create a VM with the selected template for a user. A user may also not be able to save snapshots or examine/restore saved snapshots. These features will automatically be available when the secondary storage comes back online. HA features work with iSCSI or NFS primary storage. HA with local storage is not supported. HA for Hosts HA for Management Server HA-Enabled Virtual Machines HTTP HTTP (or AJP) How to Set Up Database Replication If you set ha.tag, be sure to actually use that tag on at least one host in your cloud. If the tag specified in ha.tag is not set for any host in the cloud, the HA-enabled VMs will fail to restart after a crash. In addition to above settings, the administrator is responsible for setting the 'host' global config value from the management server IP to load balancer virtual IP address. If the 'host' value is not set to the VIP for Port 8250 and one of your management servers crashes, the UI is still available but the system VMs will not be able to contact the management server. Keep HA-enabled VMs from restarting on hosts which may be reserved for other purposes. Limitations on Database High Availability Make it easier to determine which VMs have been restarted as part of the CloudStack high-availability function. If a VM is running on a dedicated HA host, then it must be an HA-enabled VM whose original host failed. (With one exception: It is possible for an administrator to manually migrate any VM to a dedicated HA host.). Management Server Load Balancing No Normal operation of Hosts is not impacted by an outage of all Management Serves. All guest VMs will continue to work. One or more hosts can be designated for use only by HA-enabled VMs that are restarting due to a host failure. Setting up a pool of such dedicated HA hosts as the recovery destination for all HA-enabled VMs is useful to: Persistence Required? Primary Storage Outage and Data Loss Protocol References: Secondary Storage Outage and Data Loss Secondary storage data loss will impact recently added user data including templates, snapshots, and ISO images. Secondary storage should be backed up periodically. Multiple secondary storage servers can be provisioned within each zone to increase the scalability of the system. Slave hosts can not be monitored through CloudStack. You will need to have a separate means of monitoring. Source Port System Reliability and High Availability TCP The CloudStack Management Server should be deployed in a multi-node configuration such that it is not susceptible to individual server failures. The Management Server itself (as distinct from the MySQL database) is stateless and may be placed behind a load balancer. The dedicated HA option is set through a special host tag when the host is created. To allow the administrator to dedicate hosts to only HA-enabled VMs, set the global configuration variable ha.tag to the desired tag (for example, "ha\_host"), and restart the Management Server. Enter the value in the Host Tags field when adding the host(s) that you want to dedicate to HA-enabled VMs. The following limitations exist in the current implementation of this feature. The following settings must be present in db.properties, but you are not required to change the default values unless you wish to do so for tuning purposes: The user can specify a virtual machine as HA-enabled. By default, all virtual router VMs and Elastic Load Balancing VMs are automatically configured as HA-enabled. When an HA-enabled VM crashes, CloudStack detects the crash and restarts the VM automatically within the same Availability Zone. HA is never performed across different Availability Zones. CloudStack has a conservative policy towards restarting VMs and ensures that there will never be two instances of the same VM running at the same time. The Management Server attempts to start the VM on another Host in the same cluster. To control the database high availability behavior, use the following configuration settings in the file /etc/cloudstack/management/db.properties. To help ensure high availability of the databases that store the internal data for CloudStack, you can set up database replication. This covers both the main CloudStack database and the Usage database. Replication is achieved using the MySQL connector parameters and two-way replication. Tested with MySQL 5.1 and 5.5. When a primary storage outage occurs the hypervisor immediately stops all VMs stored on that storage device. Guests that are marked for HA will be restarted as soon as practical when the primary storage comes back on line. With NFS, the hypervisor may allow the virtual machines to continue running depending on the nature of the issue. For example, an NFS hang will cause the guest VMs to be suspended until storage connectivity is restored.Primary storage is not designed to be backed up. Individual volumes in primary storage can be backed up using snapshots. When the Management Server is down, no new VMs can be created, and the end user and admin UI, API, dynamic load distribution, and HA will cease to work. Yes You can also set up chain replication, which involves more than two nodes. In this case, you would first set up two-way replication with node1 and node2. Next, set up one-way replication from node2 to node3. Then set up one-way replication from node3 to node4, and so on for all the additional nodes. You must periodically perform manual clean-up of bin log files generated by replication on database nodes. If you do not clean up the log files, the disk can become full. ``db.cloud.initialTimeout``: Initial time the MySQL connector should wait before trying again to connect to the master. Default is 3600. ``db.cloud.queriesBeforeRetryMaster``: The minimum number of queries to be sent to the database before trying again to connect to the master after the master went down. Default is 5000. The retry might happen sooner if db.cloud.secondsBeforeRetryMaster is reached first. ``db.cloud.secondsBeforeRetryMaster``: The number of seconds the MySQL connector should wait before trying again to connect to the master after the master went down. Default is 1 hour. The retry might happen sooner if db.cloud.queriesBeforeRetryMaster is reached first. ``db.cloud.slaves``: set to a comma-delimited set of slave hosts for the cloud database. This is the list of nodes set up with replication. The master node is not in the list, since it is already mentioned elsewhere in the properties file. ``db.ha.enabled``: set to true if you want to use the replication feature. ``db.usage.slaves``: set to a comma-delimited set of slave hosts for the usage database. This is the list of nodes set up with replication. The master node is not in the list, since it is already mentioned elsewhere in the properties file. `http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html <http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html>`_ `https://wikis.oracle.com/display/CommSuite/MySQL+High+Availability+and+Replication+Information+For+Calendar+Server <https://wikis.oracle.com/display/CommSuite/MySQL+High+Availability+and+Replication+Information+For+Calendar+Server>`_ Project-Id-Version: Apache CloudStack Administration RTD
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2014-06-30 12:52+0200
PO-Revision-Date: 2017-07-20 16:18+0200
Language-Team: French (http://www.transifex.com/ke4qqq/apache-cloudstack-administration-rtd/language/fr/)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Language: fr
Plural-Forms: nplurals=2; plural=(n > 1);
Last-Translator: 
X-Generator: Poedit 2.0.2
 **Paramètres optionnels** **Configuration Requise** 80 ou 443 8080 (ou 20400 avec AJP) 8096 8259 Assurez vous d'avoir configurer ce qui suit dans le fichier db.properties : CloudStack peut utiliser un répartiteur de charge pour fournir une IP virtuelle à plusieurs serveurs de gestion. L'administrateur est responsable de créer les règles de répartition de charge pour les serveurs de gestion. L'application nécessite la persistance ou l'affinité de sessions. Le graphique suivant listent les ports qui devraient être répartis et si la persistance est nécessaire. Configuration de la haute disponibilité de la base de données Haute disponibilité de la base de données La réplication de la base de données dans CloudStack est obtenue en utilisant les possibilités de réplication de MySQL. Les étapes pour configurer le réplication peuvent être trouvées dans la documentation MySQL (les liens sont fournis ci-dessous). Il est suggéré que vous configuriez une réplication bi-directionnelle, ce qui implique deux noeuds de base de données. Dans ce cas, par exemple, vous devriez avoir node1 et node2. HA des hôtes dédiés Port de destination Même si la persistance n'est pas requise, son activation est permise. Les évènements du point de vue base de données ne sont pas intégrés avec le système d'évènements du serveur de gestion de CloudStack. Exemple: ``db.cloud.initialTimeout=3600`` Exemple: ``db.cloud.queriesBeforeRetryMaster=5000`` Exemple : ``db.cloud.secondsBeforeRetryMaster=3600`` Exemple : ``db.cloud.slaves=node2,node3,node4`` Exemple : ``db.ha.enabled=true`` Exemple : ``db.usage.slaves=node2,node3,node4`` Pour une zone qui ne dispose que d'un seul serveur de stockage secondaire, une interruption du stockage secondaire va avoir un impact au niveau des fonctionnalités du système mais ne va pas impacter les VM invités en fonctionnement. Il peut devenir impossible de créer une VM avec le modèle sélectionné par un utilisateur. Un utilisateur ne pourra pas non plus sauvegarder des instantanés ou examiner/restaurer les instantanés sauvegardés. Ces fonctionnalités vont automatiquement être disponible lorsque le stockage secondaire sera à nouveau disponible. Les fonctionnalités de HA fonctionnent avec le stockage primaire iSCSI ou NFS. La HA ave un stockage local n'est pas supporté. HA pour les hôtes HA pour le Serveur de Gestion Machines Virtuelles avec HA HTTP HTTP (ou AJP) Comment configurer la réplication de la base de données Si vous configurés l'option ha.tag, assurez vous d'utiliser cette étiquette sur au moins un hôte dans votre cloud. Si le tag spécifié dans l'option ha.tag n'est configuré sur aucun hôte dans le cloud, les VM avec HA ne vont pas pouvoir redémarrer après un crash. En complément aux paramètres ci-dessus, l'administrateur est responsable de remplacer l'IP du serveur de gestion contenue dans la variable de configuration globale 'host' par l'adresse virtuelle du répartiteur de charge. si la valeur 'host' n'est pas configurée pour le port 8250 de la VIP et qu'un de vos serveurs de gestion se plante alors l'UI sera toujours disponible mais les VM systèmes seront dans l'incapacité de contacter le serveur de gestion. Empêcher les VM avec la HA activée de redémarrer sur des hôtes qui auraient été réservés à d'autres fins. Limitations de la Haute Disponibilité de la Base de Données Déterminer plus simplement quelles VM ont été redémarrées par la fonctionnalité de haute disponibilité de CloudStack. Si un VM est lancée sur un hôte dédiée à la HA, alors elle doit être une VM avec HA activée dont l'hôte d'origine est tombé en panne (avec une exception : il est possible pour un administrateur de migrer manuellement n'importe quelle VM vers un hôte dédié à la HA). Répartition de charge du serveur de gestion Non L'exploitation normale des hôtes n'est pas impactée par une panne de l'ensemble des serveurs de gestion. Toutes les VM invitées vont continuer à fonctionner. Un ou plusieurs hôtes peuvent être désignés pour n'être utilisés que par les VM avec la HA activée et qui sont redémarrées à cause d'une panne de leur hôte. Configurer un tel ensemble d'hôtes HA comme destination de récupération pour toutes les VM avec la HA activée est utile pour : Persistance requise ? Interruption du stockage primaire et perte de données Protocole Références : Interruption du stockage secondaire et perte de données Une perte de données du stockage secondaire va impacter les données utilisateurs récemment ajoutées incluant les modèles, les instantanés et les images ISO. Le stockage secondaire devrait être sauvegardé périodiquement. Plusieurs serveurs de stockage secondaire peuvent etre provisionnés dans chaque zone pour augmenter l'évolutivité du système. Les hôtes esclaves ne peuvent pas être surveillés via CloudStack. Vous devrez avoir un moyen de supervision séparé. Port source Fiabilité et disponibilité du système TCP Le Serveur de Gestion de CloudStack devrait être déployé dans une configuration multi-noeuds de sorte qu'il ne soit pas soumis sensible à une panne de serveur. Le serveur de gestion lui-même (par opposition à la base de données MySQL) est sans état et peut être placé derrière un répartiteur de charge. L'option de HA dédiée est configurée via un tag spécial d'hôte lorsque l'hôte est créé. Pour permettre à l'administrateur de dédier des hôtes pour les seules VM avec HA, mettre la variable de configuration globale ha.tag pour le tag désiré (par exemple, "ha\_host") et redémarrer le serveur de gestion. Entrer la valeur dans le champ Etiquettes d'hôte lorsque vous ajoutez le ou les hôtes que vous voulez dédier aux VM avec HA. Les limitations suivantes existent dans l'implémentation courante de cette fonctionnalité. Les paramètres suivant doivent être présent dans db.properties, mais vous n'avez pas besoin de changer les valeurs par défaut sauf si vous voulez le faire à des fins de mise au point : L'utilisateur peut spécifier qu'une machine virtuelle est activée pour la HA. Par défaut, toutes les VM routeurs virtuels et les VM Répartition de charge Elastic sont automatiquement configurée avec la HA. Quand une VM avec la HA se plante, CloudStack détecte le plantage et redémarre la VM automatiquement dans la même zone de disponibilité. La HA n'est jamais effectuée entre des zones de disponibilité différentes. CloudStack a une politique prudente de redémarrage des VM et s'assure qu'il n'y aura jamais deux instances de la même VM en fonctionnement en même temps. Le serveur de gestion essaie de démarrer la VM sur un autre hôte dans le même cluster. Pour contrôler le comportement de la haute disponibilité de la base de données, utilisez les options de configuration suivantes dans le fichier /etc/cloudstack/management/db.properties. Pour aider à s'assurer de la haute disponibilité des bases de données qui stockent les données internes à CloudStack, vous pouvez configurer la réplication de base de données. Cela concerne à la fois la base de données principale de CloudStack et la base de données Usage. La réplication est obtenue en utilisant les paramètres du connecteur MySQL et la réplication bi-directionnelle. Testé avec MySQL 5.1 et 5.5. Lorsqu'une interruption du stockage primaire arrive l'hyperviseur stoppe immédiatement toutes les VM stockées sur ce périphérique de stockage. Les invités qui sont marqués pour la HA vont être redémarrés dès que possible lorsque le stockage primaire sera à nouveau en ligne. Avec NFS, l'hyperviseur peut autoriser les machines virtuelles à continuer de fonctionner en fonction de la nature de la panne. Par exemple, une coupure NFS va entraîner la suspension des VM invitées jusqu'à ce que la connectivité au stockage soit restaurée. Les stockages primaires ne sont pas conçu pour être sauvegardés. Les volumes individuels du stockage primaire peuvent être sauvegardé en utilisant les instantanés. Quand le serveur de gestion est stoppé, aucune nouvelle VM ne peut être créée et l'interface utilisateur final, l'interface d'administration, la distribution dynamique de charge et la HA vont cesser de fonctionner. Oui Vous pouvez aussi configurer une chaîne de réplication, ce qui implique plus de deux noeuds. Dans ce cas, vous configurerez une réplication bi-directionnelle entre les noeuds 1 et 2. Ensuite, configurez une réplication mono-directionnelle du noeud 2 vers le noeud 3. Puis configurez une réplication mono-directionnelle du noeud 3 au noeud 4 et ainsi de suite pour tous les noeuds additionnels. Vous devez périodiquement effectuer un nettoyage des fichiers de log binaires générés par la réplication sur les noeuds de base de données. Si vous ne nettoyez pas les fichiers de journaux, le disque peut se remplir complètement. ``db.cloud.initialTimeout``: Temps initial que le connecteur MySQL doit attendre avant de réessayer de se connecter au maître. La valeur par défaut est 3600. ``db.cloud.queriesBeforeRetryMaster``: Le nombre minimum de requêtes à envoyer à la base de données avant de réessayer de se connecter au maître après qu'il soit tombé. La valeur par défaut est 5000. Le nouvel essais peut arriver plus tôt si db.cloud.secondsBeforeRetryMaster est atteint en premier. ``db.cloud.secondsBeforeRetryMaster``: Le nombre de secondes que le connecteur MySQL doit attendre avant d'essayer à nouveau de se connecter au maître après qu'il soit tombé. La valeur par défaut est 1 heure. Le nouvel essais peut arriver plus tôt si db.cloud.queriesBeforeRetryMaster est atteint en premier. ``db.cloud.slaves``: saisir une liste de machines esclaves séparées par une virgule pour la base de données du cloud. Il s'agit de la liste des noeuds à configurer pour la réplication. Le noeud maître n'est pas dans la liste puisqu'il est déjà mentionné ailleurs dans le fichier de propriétés. ``db.ha.enabled``: mettre à true si vous voulez utiliser la fonctionnalité de réplication. ``db.usage.slaves``:  saisir une liste de machines esclaves séparées par une virgule pour la base de données usage. Il s'agit de la liste des noeuds à configurer pour la réplication. Le noeud maître n'est pas dans la liste puisqu'il est déjà mentionné ailleurs dans le fichier de propriétés. `http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html <http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html>`_ `https://wikis.oracle.com/display/CommSuite/MySQL+High+Availability+and+Replication+Information+For+Calendar+Server <https://wikis.oracle.com/display/CommSuite/MySQL+High+Availability+and+Replication+Information+For+Calendar+Server>`_ 