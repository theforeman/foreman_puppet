 locales['foreman_puppet'] = locales['foreman_puppet'] || {}; locales['foreman_puppet']['fr'] = {
  "domain": "foreman_puppet",
  "locale_data": {
    "foreman_puppet": {
      "": {
        "Project-Id-Version": "foreman_puppet 5.0.0",
        "Report-Msgid-Bugs-To": "",
        "PO-Revision-Date": "2021-02-03 16:30+0000",
        "Last-Translator": "Amit Upadhye <aupadhye@redhat.com>, 2022",
        "Language-Team": "French (https://www.transifex.com/foreman/teams/114/fr/)",
        "MIME-Version": "1.0",
        "Content-Type": "text/plain; charset=UTF-8",
        "Content-Transfer-Encoding": "8bit",
        "Language": "fr",
        "Plural-Forms": "nplurals=3; plural=(n == 0 || n == 1) ? 0 : n != 0 && n % 1000000 == 0 ? 1 : 2;",
        "lang": "fr",
        "domain": "foreman_puppet",
        "plural_forms": "nplurals=3; plural=(n == 0 || n == 1) ? 0 : n != 0 && n % 1000000 == 0 ? 1 : 2;"
      },
      "Ignored environment names resulting in booleans found. Please quote strings like true/false and yes/no in config/ignored_environments.yml": [
        "Noms d'environnement ignorés donnant lieu à des valeurs booléennes. Mentionnez des chaînes telles que true/false et yes/no dans config/ignored_environments.yml"
      ],
      "No changes to your environments detected": [
        "Aucun changement détecté dans vos environnements"
      ],
      "Successfully updated environments and Puppet classes from the on-disk Puppet installation": [
        "Mise à jour réussie des environnements et classes Puppet depuis l'installation Puppet présente sur le disque"
      ],
      "Failed to update environments and Puppet classes from the on-disk Puppet installation: %s": [
        "Échec de la mise à jour des environnements et classes Puppet depuis l'installation Puppet sur disque : %s"
      ],
      "No smart proxy was found to import environments from, ensure that at least one smart proxy is registered with the 'puppet' feature": [
        "Aucun smart proxy n'a été trouvé pour importer les environnements. Assurez vous qu'au moins un proxy smart est enregistré avec la fonction 'puppet'."
      ],
      "Ignored environments: %s": [
        "Environnement ignoré : %s"
      ],
      "Ignored classes in the environments: %s": [
        "Classes ignorées dans les environnements : %s"
      ],
      "List all host groups for a Puppet class": [
        "Afficher tous les groupes d'hôtes pour une classe Puppet"
      ],
      "ID of Puppetclass": [
        "ID Puppetclass"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/environment_id": [
        "Déprécié en faveur de hostgroup/puppet_attributes/environment_id"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/puppetclass_ids": [
        "Déprécié au profit de hostgroup/puppet_attributes/puppetclass_ids"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/config_group_ids": [
        "Déprécié en faveur de hostgroup/puppet_attributes/config_group_ids"
      ],
      "ID of associated puppet Environment": [
        "ID environnement Puppet associé"
      ],
      "IDs of associated Puppetclasses": [
        "ID des classes Puppet associées"
      ],
      "IDs of associated ConfigGroups": [
        "ID des groupes de configuration associés"
      ],
      "Import puppet classes from puppet proxy": [
        "Importer des classes puppet depuis le proxy puppet"
      ],
      "Import puppet classes from puppet proxy for an environment": [
        "Import des classes puppet depuis le proxy puppet d'un environnement"
      ],
      "Optional comma-delimited stringcontaining either 'new', 'updated', or 'obsolete'that is used to limit the imported Puppet classes": [
        "Chaîne facultative délimitée par des virgules contenant soit \\\"nouveau\\\", \\\"mis à jour\\\" ou \\\"obsolète\\\", utilisée pour limiter les classes Puppet importées"
      ],
      "Failed to update the environments and Puppet classes from the on-disk puppet installation: %s": [
        "Échec de la mise à jour des environnements et classes Puppet depuis l'application Puppet présente sur le disque : %s"
      ],
      "The requested environment cannot be found.": [
        "Les environnements demandés n’ont pas pu être trouvés."
      ],
      "No proxy found to import classes from, ensure that the smart proxy has the Puppet feature enabled.": [
        "Aucun proxy trouvé pour l'import des classes. Assurez vous qu'un smart proxy ait la fonction Puppet active."
      ],
      "List template combination": [
        "Lister les combinaisons de modèles"
      ],
      "Add a template combination": [
        "Ajouter une combinaison de modèle"
      ],
      "Show template combination": [
        "Afficher la combinaison de modèles"
      ],
      "Update template combination": [
        "Mise à jour de la combinaison de modèle"
      ],
      "ID of Puppet environment": [
        "ID environnement Puppet"
      ],
      "environment id": [
        "id d'environnement"
      ],
      "ID of environment": [
        "ID de l'environnement"
      ],
      "List hosts per environment": [
        "Liste des hôtes par environnement"
      ],
      "ID of puppet environment": [
        "ID environnement Puppet"
      ],
      "Deprecated in favor of host/puppet_attributes/environment_id": [
        "Déprécié en faveur de host/puppet_attributes/environment_id"
      ],
      "Deprecated in favor of host/puppet_attributes/puppetclass_ids": [
        "Déprécié en faveur de host/puppet_attributes/puppetclass_ids"
      ],
      "Deprecated in favor of host/puppet_attributes/config_group_ids": [
        "Déprécié en faveur de host/puppet_attributes/config_group_ids"
      ],
      "No environment selected!": [
        "Aucun environnement sélectionné."
      ],
      "Updated hosts: changed environment": [
        "Mise à jour des hôtes : l'environnement a changé"
      ],
      "Unable to generate output, Check log files": [
        "Impossible de générer une sortie, vérifiez les fichiers de journaux"
      ],
      "No proxy selected!": [
        "Aucun proxy sélectionné."
      ],
      "Invalid proxy selected!": [
        "Un proxy non valide a été sélectionné."
      ],
      "Failed to set %{proxy_type} proxy for %{host}.": [
        "N’a pas pu définir le proxy %{proxy_type} pour %%{host}."
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}": [
        "Le proxy %{proxy_type} pour les hôtes sélectionnés a été défini à %{proxy_name}"
      ],
      "The %{proxy_type} proxy of the selected hosts was cleared.": [
        "Le proxy %{proxy_type}pour les hôtes sélectionnés a été effacé"
      ],
      "The %{proxy_type} proxy could not be set for host: %{host_names}.": [
        "Le proxy %{proxy_type} n'a pas pu être défini pour l'hôte : %{host_names}.",
        "Le proxy %{proxy_type} puppet ca n'a pas pu être défini pour les hôtes : %{host_names}.",
        "Le proxy %{proxy_type} puppet ca n'a pas pu être défini pour les hôtes : %{host_names}."
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}.": [
        "Le proxy %{proxy_type} pour les hôtes sélectionnés a été défini à %{proxy_name}."
      ],
      "Puppet": [
        "Puppet"
      ],
      "Puppet CA": [
        "Puppet CA"
      ],
      "List of config groups": [
        "Liste des groupes de configuration"
      ],
      "Show a config group": [
        "Afficher un groupe de configuration"
      ],
      "Create a config group": [
        "Créer un groupe de configuration"
      ],
      "Update a config group": [
        "Mise à jour d'un groupe de configuration"
      ],
      "Delete a config group": [
        "Supprimer un groupe de configuration"
      ],
      "List all environments": [
        "Afficher tous les environnements"
      ],
      "List environments of Puppet class": [
        "Liste des environnements d'une classe Puppet"
      ],
      "List environments per location": [
        "Liste des environnements par emplacement"
      ],
      "List environments per organization": [
        "Liste des environnements par organisation"
      ],
      "ID of Puppet class": [
        "ID de la classe Puppet"
      ],
      "Show an environment": [
        "Afficher un environnement"
      ],
      "Create an environment": [
        "Créer un environnement"
      ],
      "Update an environment": [
        "Mettre à jour un environnement"
      ],
      "Delete an environment": [
        "Supprimer un environnement"
      ],
      "List all Puppet class IDs for host": [
        "Afficher tous les ID des classes Puppet pour un hôte"
      ],
      "Add a Puppet class to host": [
        "Ajout d'une classe Puppet à l'hôte"
      ],
      "ID of host": [
        "ID de l'hôte"
      ],
      "Remove a Puppet class from host": [
        "Supprimer une classe Puppet d'un hôte"
      ],
      "List all Puppet class IDs for host group": [
        "Afficher tous les ID des classes Puppet pour un groupe d'hôtes"
      ],
      "Add a Puppet class to host group": [
        "Ajouter une classe Puppet à un groupe d'hôtes"
      ],
      "ID of host group": [
        "ID du groupe d'hôtes"
      ],
      "Remove a Puppet class from host group": [
        "Supprimer une classe Puppet d'un groupe d'hôtes"
      ],
      "List of override values for a specific smart class parameter": [
        "Liste des valeurs de substitution pour un paramètre smart class"
      ],
      "Display hidden values": [
        "Afficher les valeurs masquées"
      ],
      "Show an override value for a specific smart class parameter": [
        "Afficher une valeur de substitution pour un paramètre smart class spécifique"
      ],
      "Override match": [
        "Élément conditionnel d'emplacement"
      ],
      "Override value, required if omit is false": [
        "Remplacer la valeur, requis si Omettre est sur false"
      ],
      "Foreman will not send this parameter in classification output": [
        "Foreman n'enverra pas ce paramètre dans la sortie de classification."
      ],
      "Create an override value for a specific smart class parameter": [
        "Créer une valeur de substitution pour un paramètre d'une smart class spécifique"
      ],
      "Update an override value for a specific smart class parameter": [
        "Mise à jour d'une valeur de substitution pour un paramètre smart class"
      ],
      "Delete an override value for a specific smart class parameter": [
        "Supprimer une valeur de substitution pour un paramètre d'une smart class spécifique"
      ],
      "%{model} with id '%{id}' was not found": [
        "%%{model} aynat pour id '%%{id}' n'a pas été trouvé"
      ],
      "List all Puppet classes": [
        "Afficher toutes les classes Puppet"
      ],
      "List all Puppet classes for a host": [
        "Afficher toutes les classes Puppet d'un hôte"
      ],
      "List all Puppet classes for a host group": [
        "Afficher toutes les classes Puppet d'un groupe d'hôtes"
      ],
      "List all Puppet classes for an environment": [
        "Afficher toutes les classes Puppet d'un environnement"
      ],
      "Show a Puppet class": [
        "Afficher une classe Puppet"
      ],
      "Show a Puppet class for host": [
        "Afficher une classe Puppet pour un hôte"
      ],
      "Show a Puppet class for a host group": [
        "Afficher une classe Puppet pour un groupe d'hôtes"
      ],
      "Show a Puppet class for an environment": [
        "Afficher une classe Puppet pour un environnement"
      ],
      "Create a Puppet class": [
        "Créer une classe Puppet"
      ],
      "Update a Puppet class": [
        "Mise à jour d'une classe Puppet"
      ],
      "Delete a Puppet class": [
        "Supprimer une classe Puppet"
      ],
      "List all smart class parameters": [
        "Afficher tous les paramètres des smart class"
      ],
      "List of smart class parameters for a specific host": [
        "Liste des paramètres smart class pour un hôte spécifique"
      ],
      "List of smart class parameters for a specific host group": [
        "Liste des paramètres smart class pour un groupe d'hôtes spécifique"
      ],
      "List of smart class parameters for a specific Puppet class": [
        "Liste des paramètres smart class pour une classe Puppet spécifique"
      ],
      "List of smart class parameters for a specific environment": [
        "Liste des paramètres smart class pour un environnement spécifique"
      ],
      "List of smart class parameters for a specific environment/Puppet class combination": [
        "Liste des paramètres smart class pour une combinaison environnement / classe Puppet spécifique"
      ],
      "Show a smart class parameter": [
        "Afficher un paramètre de smart class"
      ],
      "Update a smart class parameter": [
        "Mise à jour d'un paramètre de smart class"
      ],
      "Whether the smart class parameter value is managed by Foreman": [
        "Dépend si le paramètre smart class est géré par Foreman"
      ],
      "Description of smart class": [
        "Description de la smart class"
      ],
      "Value to use when there is no match": [
        "Valeur à utiliser quand il n'y a pas de concordance"
      ],
      "When enabled the parameter is hidden in the UI": [
        "Quand activé, le paramètre est caché dans l'interface"
      ],
      "Foreman will not send this parameter in classification output.Puppet will use the value defined in the Puppet manifest for this parameter": [
        "Foreman n'enverra pas ce paramètre dans la sortie de la classification. Puppet utilisera la valeur définie dans le manifeste de Puppet pour ce paramètre"
      ],
      "The order in which values are resolved": [
        "L'ordre dans lequel les valeurs sont interprétées"
      ],
      "Types of validation values": [
        "Types des valeurs pour la validation"
      ],
      "Used to enforce certain values for the parameter values": [
        "Utilisé pour forcer certaines valeurs pour les valeurs des paramètres"
      ],
      "Types of variable values": [
        "Types de variables des valeurs"
      ],
      "If true, will raise an error if there is no default value and no matcher provide a value": [
        "Si coché, Foreman va générer une erreur s'il n'y a pas de valeur par défaut et aucun matcher ne fournit de valeur"
      ],
      "Merge all matching values (only array/hash type)": [
        "Fusionner toutes les valeurs qui correspondent (seulement pour les types tableau/hachage)"
      ],
      "Include default value when merging all matching values": [
        "Inclus la valeur par défaut lors qu'on fusionne les valeurs de concordance"
      ],
      "Remove duplicate values (only array type)": [
        "Supprime les valeurs dupliquées (seulement pour le type tableau)"
      ],
      "Successfully overridden all parameters of Puppet class %s": [
        "Substitution de tous les paramètres de la classe Puppet %s réussie"
      ],
      "Successfully reset all parameters of Puppet class %s to their default values": [
        "Réinitialisation réussie de tous les paramètres de la classe Puppet %s à leur valeurs par défaut"
      ],
      "No parameters to override for Puppet class %s": [
        "Aucun paramètre à remplacer pour la classe Puppet %s"
      ],
      "Create Puppet Environment": [
        "Créer un environnement Puppet"
      ],
      "Help": [
        "Assistance"
      ],
      "Change Environment": [
        "Changer l'environnement"
      ],
      "Change Puppet Master": [
        "Changer le Puppet Master"
      ],
      "Puppet YAML": [
        "Puppet YAML"
      ],
      "Puppet external nodes YAML dump": [
        "Dump YAML des noeud externes de Puppet"
      ],
      "Puppet Environment": [
        "Environnement Puppet"
      ],
      "Omit from classification output": [
        "Omettre de la sortie de classification"
      ],
      "Override this value": [
        "Remplacer cette valeur"
      ],
      "Remove this override": [
        "Supprimer cette valeur de substitution"
      ],
      "Default value": [
        "Valeur par défaut"
      ],
      "Original value info": [
        "Information sur la valeur d'origine"
      ],
      "<b>Description:</b> %{desc}<br/>\\n        <b>Type:</b> %{type}<br/>\\n        <b>Matcher:</b> %{matcher}<br/>\\n        <b>Inherited value:</b> %{inherited_value}": [
        "<b>Description :</b> %%{desc}<br/>\\n     <b>Type :</b> %%{type}<br/>\\n     <b>Correspondant :</b> %%{matcher}<br/>\\n     <b>Valeur héritée :</b> %{inherited_value}"
      ],
      "Required parameter without value.<br/><b>Please override!</b><br/>": [
        "Paramètre requis sans valeur.<br/><b>Merci d’effectuer une substitution</b><br/>."
      ],
      "Optional parameter without value.<br/><i>Still managed by Foreman, the value will be empty.</i><br/>": [
        "Paramètre en option sans valeur..<br/><i>Toujours géré par Foreman, la valeur sera vide.</i><br/>"
      ],
      "Empty environment": [
        "Environnement vide"
      ],
      "Deleted environment": [
        "A supprimé l'environnement"
      ],
      "Deleted environment %{env} and %{pcs}": [
        "A supprimé environnements %%{env} et %%{pcs}"
      ],
      "Ignored environment": [
        "Environnement ignoré"
      ],
      "Import": [
        "Importation"
      ],
      "Import environments from %s": [
        "Importer environnements de %s"
      ],
      "Import classes from %s": [
        "Importer classes de %s"
      ],
      "%{name} has %{num_tag} class": [
        "%%{name} a %{num_tag} classe",
        "%%{name} a %{num_tag} classes",
        "%%{name} a %{num_tag} classes"
      ],
      "Click to remove %s": [
        "Cliquez pour supprimer %s"
      ],
      "Click to add %s": [
        "Cliquez pour ajouter %s"
      ],
      "None": [
        "Aucun(e)"
      ],
      "When editing a template, you must assign a list \\\\\\n  of operating systems which this template can be used with. Optionally, you can \\\\\\n  restrict a template to a list of host groups and/or environments.": [
        "Lors de la modification d'un modèle, vous devez attribuer une liste \\\\\\n de systèmes d'exploitation qui peuvent utiliser ce modèle. Vous pouvez également \\\\\\nrestreindre un modèle à un groupe d'hôtes et/ou des environnements."
      ],
      "When a Host requests a template (e.g. during provisioning), Foreman \\\\\\n  will select the best match from the available templates of that type, in the \\\\\\n  following order:": [
        "Lorsqu'un hôte demande un modèle (par ex. pendant le provisioning), Foreman \\\\\\n choisit la meilleure correspondance entre les types de modèles existants \\\\\\n selon cet ordre :"
      ],
      "Host group and Environment": [
        "Groupe d'hôtes et Environnement"
      ],
      "Host group only": [
        "Seulement un groupe d'hôte"
      ],
      "Environment only": [
        "Seulement un environnement"
      ],
      "Operating system default": [
        "Système d'Exploitation par défaut"
      ],
      "The final entry, Operating System default, can be set by editing the %s page.": [
        "La dernière entrée, le système d'exploitation par défaut, peut être défini en modifiant la page %s."
      ],
      "Operating System": [
        "Système d'exploitation"
      ],
      "Can't find a valid Foreman Proxy with a Puppet feature": [
        "Impossible de trouver un proxy Foreman ayant la fonction Puppet"
      ],
      "%{puppetclass} does not belong to the %{environment} environment": [
        "%%{puppetclass} n'appartient pas à l'environnement %%{environment}"
      ],
      "Failed to import %{klass} for %{name}: doesn't exists in our database - ignoring": [
        "Échec lors de l'importation de %%{klass}  pour %%{name} : l'entrée n'existe pas dans la base de donnée - ignore"
      ],
      "with id %{object_id} doesn't exist or is not assigned to proper organization and/or location": [
        "avec id %{object_id} n'existe pas ou n'a pas été assigné à l'organisation et/ou emplacement qui convient"
      ],
      "must be true to edit the parameter": [
        "Doit être vrai pour éditer le paramètre"
      ],
      "Puppet parameter": [
        "Paramètre Puppet"
      ],
      "Can't find a valid Proxy with a Puppet feature": [
        "Impossible de trouver un proxy valide ayant une fonction Puppet"
      ],
      "Changed environments": [
        "Environnements modifiés"
      ],
      "Puppet Environments": [
        "Environnements Puppet"
      ],
      "Select the changes you want to apply to Foreman": [
        "Sélectionner les changements que vous souhaitez appliquer à Foreman"
      ],
      "Toggle": [
        "Inverser"
      ],
      "New": [
        "Nouveau"
      ],
      "Check/Uncheck new": [
        "Cocher / Décocher les nouveaux"
      ],
      "Updated": [
        "Mis à jour"
      ],
      "Check/Uncheck updated": [
        "Cocher / Décocher mis à jour "
      ],
      "Obsolete": [
        "Obsolète"
      ],
      "Check/Uncheck obsolete": [
        "Cocher / Décocher les obsolètes"
      ],
      "Check/Uncheck all": [
        "Cocher / Tout décocher"
      ],
      "Environment": [
        "Environnement"
      ],
      "Operation": [
        "Opération"
      ],
      "Puppet Modules": [
        "Modules Puppet"
      ],
      "Check/Uncheck all %s changes": [
        "Tout Cocher / Décocher les %s changements"
      ],
      "Add:": [
        "Ajouter :"
      ],
      "Remove:": [
        "Suppression:"
      ],
      "Update:": [
        "Mise à jour:"
      ],
      "Ignored:": [
        "Ignoré :"
      ],
      "Cancel": [
        "Annuler"
      ],
      "Update": [
        "Mise à jour"
      ],
      "included already from parent": [
        "déjà inclus depuis le parent"
      ],
      "Remove": [
        "Supprimer"
      ],
      "Add": [
        "Ajouter"
      ],
      "%s is not in environment": [
        "%s n'est pas dans un environnement"
      ],
      "Included Config Groups": [
        "Groupes de configurations inclus"
      ],
      "Available Config Groups": [
        "Groupes de configuration disponibles"
      ],
      "Edit %s": [
        "Modifier %s"
      ],
      "Config Groups": [
        "Groupes de configuration"
      ],
      "Create Config Group": [
        "Créer un groupe de configuration"
      ],
      "Puppet Classes": [
        "Classes Puppet"
      ],
      "Hosts": [
        "Hôtes"
      ],
      "Host Groups": [
        "Groupe d'Hôtes"
      ],
      "Actions": [
        "Actions"
      ],
      "Delete %s?": [
        "Supprimer %s?"
      ],
      "A config group provides a one-step method of associating many Puppet classes to either a host or host group. Typically this would be used to add a particular application profile or stack in one step.": [
        "Un groupe de configuration fournit une méthode en une seule étape pour associer de nombreuses classes Puppet à un hôte ou à un groupe d'hôtes. Typiquement, ceci serait utilisé pour ajouter un profil d'application particulier ou une pile en une seule étape."
      ],
      "Locations": [
        "Emplacements"
      ],
      "Organizations": [
        "Organisations"
      ],
      "Environment|Name": [
        "Nom"
      ],
      "Classes": [
        "Classes"
      ],
      "Create Environment": [
        "Créer un environnement"
      ],
      "Puppet environments": [
        "Environnements Puppet"
      ],
      "Number of classes": [
        "Nombre de classes"
      ],
      "Total": [
        "Total"
      ],
      "No environments found": [
        "Aucun environnement trouvé"
      ],
      "There are no puppet environments set up on this puppet master. Please check the puppet master configuration.": [
        "Il n'y a aucun environnement Puppet défini pour ce Puppet Master. Veuillez vérifier la configuration de votre Puppet Master."
      ],
      "Smart Class Parameters": [
        "Paramètres smart class"
      ],
      "Parameter": [
        "Paramètre"
      ],
      "Puppet Class": [
        "Classe Puppet"
      ],
      "Number of Overrides": [
        "Nombre de valeurs de remplacement"
      ],
      "Parameterized class support permits detecting, importing, and supplying parameters directly to classes which support it, via the ENC and depending on a set of rules (Smart Matchers).": [
        "La prise en charge des classes paramétrées permet de détecter, d'importer et de fournir des paramètres directement aux classes qui le prennent en charge, via l'ENC et en fonction d'un ensemble de règles (Smart Matchers)."
      ],
      "Included Classes": [
        "Classes incluses"
      ],
      "Not authorized to edit classes": [
        "Non autorisé à modifier les classes"
      ],
      "Inherited Classes from %s": [
        "Classes héritées de %s"
      ],
      "Available Classes": [
        "Classes disponibles"
      ],
      "Filter classes": [
        "Filtrer les classes"
      ],
      "belongs to config group": [
        "appartient au groupe de configuration"
      ],
      "Name": [
        "Nom"
      ],
      "Value": [
        "Valeur"
      ],
      "Omit": [
        "Omettre"
      ],
      "The class could not be saved because of an error in one of the class parameters.": [
        "La classe n'a pas pu être enregistrée en raison d'une erreur dans l'un des paramètres de classe."
      ],
      "Smart Class Parameter": [
        "Paramètre Smart Class"
      ],
      "Host groups": [
        "Groupes d'hôtes"
      ],
      "This Puppet class has no parameters in its signature.": [
        "Cette classe Puppet n'a pas de paramètre dans sa signature."
      ],
      "To update the class signature, go to the Puppet Classes page and select \\\"Import\\\".": [
        "Pour mettre à jour les signatures des classes, allez sur la page Classes Puppet et choisissez \\\"Import depuis ...\\\"."
      ],
      "Filter by name": [
        "Filtrer par nom"
      ],
      "All environments - (not filtered)": [
        "Tous les environnements - (non filtrés)"
      ],
      "Overridden": [
        "Remplacé"
      ],
      "Edit Puppet Class %s": [
        "Modifier la classe Puppet %s"
      ],
      "Puppetclass|Name": [
        "Nom"
      ],
      "Environments": [
        "Environnements"
      ],
      "Parameters": [
        "Paramètres"
      ],
      "Override all parameters": [
        "Remplacer tous les paramètres"
      ],
      "This will set all parameters of the class %s as overridden. Continue?": [
        "Cela définira tous les paramètres de la classe %s comme remplacés. Continuer ?"
      ],
      "Set parameters to defaults": [
        "Positionner les paramètres aux valeurs par défaut"
      ],
      "This will reset parameters of the class %s to their default values. Continue?": [
        "Réinitialisation de tous les paramètres de la classe Puppet %s à leur valeur par défaut. Continuer ?"
      ],
      "Puppet Class Parameters": [
        "Paramètres des classes Puppet"
      ],
      "Notice": [
        "Note"
      ],
      "Please select an environment first": [
        "Tout d'abord, sélectionner un environnement"
      ],
      "Select environment": [
        "Choisir l'environnement"
      ],
      "*Clear environment*": [
        "*Nettoyer l'environnement*"
      ],
      "*Inherit from host group*": [
        "*hérité d'un groupe d'hôtes*"
      ],
      "Hostgroup": [
        "Groupe d'hôtes"
      ],
      "Remove Combination": [
        "Supprimer la combinaison"
      ],
      "Valid Host Group and Environment Combinations": [
        "Combinaisons valide de groupe d'hôtes et d'environnement"
      ],
      "Add Combination": [
        "Ajouter une combinaison"
      ],
      "General": [
        "Général"
      ],
      "Hosts managed:": [
        "Hôtes gérés :"
      ],
      "Facts": [
        "Faits"
      ],
      "Foreman will default to this puppet environment if it cannot auto detect one": [
        "L'environnement Puppet par défaut si Foreman n'arrive pas à le détecter automatiquement"
      ],
      "Default Puppet environment": [
        "Environnements Puppet par défaut"
      ],
      "Foreman will explicitly set the puppet environment in the ENC yaml output. This will avoid conflicts between the environment in puppet.conf and the environment set in Foreman": [
        "Foreman fournira l'environnement Puppet dans la sortie YAML de l'ENC. Cela supprime  les incohérences entre l'environnement dans puppet.conf et l'environnement dans l'ENC."
      ],
      "ENC environment": [
        "Environnement de l'ENC"
      ],
      "Foreman will update a host's environment from its facts": [
        "Foreman mettra à jour l'environnement de l'hôte d'après les facts"
      ],
      "Update environment from facts": [
        "Mise à jour de l'environnement depuis les facts"
      ],
      "Config Management": [
        "Gestion de configuration"
      ],
      "Duration in minutes after servers reporting via Puppet are classed as out of sync.": [
        "Durée en minutes après laquelle les serveurs envoyant des rapports via Puppet sont classés comme désynchronisés."
      ],
      "Puppet interval": [
        "Intervalle de temps pour Puppet"
      ],
      "Disable host configuration status turning to out of sync for %s after report does not arrive within configured interval": [
        "Désactiver l'état de la configuration de l'hôte à 'out of sync' pour %s, après que le rapport n'est pas arrivé dans l'intervalle configuré"
      ],
      "%s out of sync disabled": [
        "Désynchronisation de %s désactivée"
      ],
      "Puppet ENC": [
        "Puppet ENC"
      ],
      "Puppet env": [
        ""
      ],
      "If you are planning to use Foreman as an external node classifier you should provide information about one or more environments.{newLine}This information is commonly imported from a pre-existing Puppet configuration by the use of the {puppetClassesLinkToDocs} and environment importer.": [
        ""
      ],
      "Puppet classes": [
        ""
      ],
      "Assigned classes": [
        "Classes assignées"
      ],
      "This tab is still a work in progress": [
        "Cet onglet est toujours un travail en cours"
      ],
      "Smart class parameters": [
        "Paramètres smart class"
      ],
      "Successfully copied to clipboard!": [
        ""
      ],
      "Copy to clipboard": [
        ""
      ],
      "Couldn't find any ENC data for this host": [
        "Je n'ai pas trouvé de données ENC pour cet hôte."
      ],
      "Error!": [
        "Erreur"
      ],
      "Puppet details": [
        "Détails Puppet"
      ],
      "Puppet environment": [
        "Environnement Puppet"
      ],
      "Puppet Smart Proxy": [
        "Créer un proxy Smart"
      ],
      "Puppet CA Smart Proxy": [
        "Proxy Smart CA Puppet"
      ],
      "Reports": [
        "Rapports"
      ],
      "ENC Preview": [
        "Prévisualisation ENC"
      ],
      "Click to remove config group": [
        "Cliquez pour supprimer le groupe de configuration"
      ],
      " Remove": [
        " Supprimer"
      ],
      "Loading parameters...": [
        "Chargement des paramètres ..."
      ],
      "Some Puppet Classes are unavailable in the selected environment": [
        "Certaines classes Puppet sont indisponibles dans l'environnement sélectionné"
      ],
      "Action with sub plans": [
        "Action avec sous-plans"
      ],
      "Import facts": [
        "Importer des faits"
      ],
      "Import Puppet classes": [
        "Importer des classes Puppet"
      ],
      "Remote action:": [
        "Action distante :"
      ],
      "Allow assigning Puppet environments and classes to the Foreman Hosts.": [
        "Permet d'assigner des environnements et des classes Puppet aux hôtes Foreman."
      ]
    }
  }
};