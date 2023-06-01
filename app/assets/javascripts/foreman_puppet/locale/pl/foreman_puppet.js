 locales['foreman_puppet'] = locales['foreman_puppet'] || {}; locales['foreman_puppet']['pl'] = {
  "domain": "foreman_puppet",
  "locale_data": {
    "foreman_puppet": {
      "": {
        "Project-Id-Version": "foreman_puppet 5.0.0",
        "Report-Msgid-Bugs-To": "",
        "PO-Revision-Date": "2021-02-03 16:30+0000",
        "Last-Translator": "sziolkow <sziolkow@gmail.com>, 2022",
        "Language-Team": "Polish (https://www.transifex.com/foreman/teams/114/pl/)",
        "MIME-Version": "1.0",
        "Content-Type": "text/plain; charset=UTF-8",
        "Content-Transfer-Encoding": "8bit",
        "Language": "pl",
        "Plural-Forms": "nplurals=4; plural=(n==1 ? 0 : (n%10>=2 && n%10<=4) && (n%100<12 || n%100>14) ? 1 : n!=1 && (n%10>=0 && n%10<=1) || (n%10>=5 && n%10<=9) || (n%100>=12 && n%100<=14) ? 2 : 3);",
        "lang": "pl",
        "domain": "foreman_puppet",
        "plural_forms": "nplurals=4; plural=(n==1 ? 0 : (n%10>=2 && n%10<=4) && (n%100<12 || n%100>14) ? 1 : n!=1 && (n%10>=0 && n%10<=1) || (n%10>=5 && n%10<=9) || (n%100>=12 && n%100<=14) ? 2 : 3);"
      },
      "Ignored environment names resulting in booleans found. Please quote strings like true/false and yes/no in config/ignored_environments.yml": [
        ""
      ],
      "No changes to your environments detected": [
        "Brak zmian dla twojego środowiska."
      ],
      "Successfully updated environments and Puppet classes from the on-disk Puppet installation": [
        "Pomyślnie zaktualizowano środowisko i klasę puppet z instalacji Puppet na dysku"
      ],
      "Failed to update environments and Puppet classes from the on-disk Puppet installation: %s": [
        "Nie udało się zaktualizować środowisk i klas puppet z instalacji Puppet na dysku: %s"
      ],
      "No smart proxy was found to import environments from, ensure that at least one smart proxy is registered with the 'puppet' feature": [
        ""
      ],
      "Ignored environments: %s": [
        ""
      ],
      "Ignored classes in the environments: %s": [
        ""
      ],
      "List all host groups for a Puppet class": [
        "Lista wszystkich grup hostów dla jednej klasy Puppet"
      ],
      "ID of Puppetclass": [
        ""
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/environment_id": [
        ""
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/puppetclass_ids": [
        ""
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/config_group_ids": [
        ""
      ],
      "ID of associated puppet Environment": [
        ""
      ],
      "IDs of associated Puppetclasses": [
        ""
      ],
      "IDs of associated ConfigGroups": [
        ""
      ],
      "Import puppet classes from puppet proxy": [
        ""
      ],
      "Import puppet classes from puppet proxy for an environment": [
        "Import klas puppet ze środowiska puppet proxy."
      ],
      "Optional comma-delimited stringcontaining either 'new', 'updated', or 'obsolete'that is used to limit the imported Puppet classes": [
        ""
      ],
      "Failed to update the environments and Puppet classes from the on-disk puppet installation: %s": [
        "Nie udało się zaktualizować środowisk i klas puppet z instalacji puppet na dysku: %s"
      ],
      "The requested environment cannot be found.": [
        ""
      ],
      "No proxy found to import classes from, ensure that the smart proxy has the Puppet feature enabled.": [
        "Nie znaleziono proxy do importowania klas, upewnij się, że inteligentne proxy ma włączoną funkcję puppet."
      ],
      "List template combination": [
        "Połączenie listy szablonów"
      ],
      "Add a template combination": [
        "Dodaj kombinację szablonu"
      ],
      "Show template combination": [
        "Pokaż kombinację szablonu"
      ],
      "Update template combination": [
        "Aktualizuj kombinację szablonu"
      ],
      "ID of Puppet environment": [
        ""
      ],
      "environment id": [
        "id środowiska"
      ],
      "ID of environment": [
        "ID środowiska"
      ],
      "List hosts per environment": [
        "Lista hostów na środowisko"
      ],
      "ID of puppet environment": [
        ""
      ],
      "Deprecated in favor of host/puppet_attributes/environment_id": [
        ""
      ],
      "Deprecated in favor of host/puppet_attributes/puppetclass_ids": [
        ""
      ],
      "Deprecated in favor of host/puppet_attributes/config_group_ids": [
        ""
      ],
      "No environment selected!": [
        "Nie wybrano środowiska!"
      ],
      "Updated hosts: changed environment": [
        "Zaktualizowano hosty: zmieniono środowisko"
      ],
      "Unable to generate output, Check log files": [
        "Nie można wygenerować danych wyjściowych, Sprawdzenie logów"
      ],
      "No proxy selected!": [
        "Nie wybrano proxy!"
      ],
      "Invalid proxy selected!": [
        "Wybrano nieprawidłowe proxy!"
      ],
      "Failed to set %{proxy_type} proxy for %{host}.": [
        "Nie udało się ustawić %{proxy_type} proxy dla %{host}."
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}": [
        ""
      ],
      "The %{proxy_type} proxy of the selected hosts was cleared.": [
        "Wyczyszczono %{proxy_type} proxy wybranego hostu."
      ],
      "The %{proxy_type} proxy could not be set for host: %{host_names}.": [
        "",
        ""
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}.": [
        "%{proxy_type} proxy wybranego hostu zostało ustawione na %{proxy_name}."
      ],
      "Puppet": [
        "Puppet"
      ],
      "Puppet CA": [
        "Puppet CA"
      ],
      "List of config groups": [
        "Lista wszystkich grup konfiguracji"
      ],
      "Show a config group": [
        "Pokaż grupę konfiguracji"
      ],
      "Create a config group": [
        "Utwórz grupę konfiguracji"
      ],
      "Update a config group": [
        "Edytuj grupę konfiguracji"
      ],
      "Delete a config group": [
        "Usuń grupę konfiguracji"
      ],
      "List all environments": [
        "Lista wszystkich środowisk"
      ],
      "List environments of Puppet class": [
        "Lista środowisk klasy Puppet"
      ],
      "List environments per location": [
        "Lista środowisk na lokalizację"
      ],
      "List environments per organization": [
        "Lista środowisk na organizację"
      ],
      "ID of Puppet class": [
        "ID klasy Puppet"
      ],
      "Show an environment": [
        "Pokaż środowisko"
      ],
      "Create an environment": [
        "Utwórz środowisko"
      ],
      "Update an environment": [
        "Edytuj środowisko"
      ],
      "Delete an environment": [
        "Usuń środowisko"
      ],
      "List all Puppet class IDs for host": [
        "Lista wszystkich ID klasy Puppet dla hostów"
      ],
      "Add a Puppet class to host": [
        "Dodaj klasę Puppet do hostu"
      ],
      "ID of host": [
        "ID hostu"
      ],
      "Remove a Puppet class from host": [
        "Usuń klasę Puppet z hostu"
      ],
      "List all Puppet class IDs for host group": [
        "Lista wszystkich ID klasy Puppet dla grupy hostów"
      ],
      "Add a Puppet class to host group": [
        "Dodaj klasę Puppeta do grupy hostów"
      ],
      "ID of host group": [
        "ID grupy hostów"
      ],
      "Remove a Puppet class from host group": [
        "Usuń klasę Puppet z grupy hostów"
      ],
      "List of override values for a specific smart class parameter": [
        "Lista nadpisanych wartości dla konkretnego parametru smart class"
      ],
      "Display hidden values": [
        ""
      ],
      "Show an override value for a specific smart class parameter": [
        "Pokaż wartość nadpisaną dla konkretnego parametru inteligentnej klasy"
      ],
      "Override match": [
        "Zastąp dopasowanie"
      ],
      "Override value, required if omit is false": [
        ""
      ],
      "Foreman will not send this parameter in classification output": [
        ""
      ],
      "Create an override value for a specific smart class parameter": [
        "Utwórz wartość nadpisaną dla konkretnego parametru inteligentnej klasy"
      ],
      "Update an override value for a specific smart class parameter": [
        "Aktualizuj wartość nadpisaną dla konkretnego parametru inteligentnej klasy"
      ],
      "Delete an override value for a specific smart class parameter": [
        "Usuń wartość nadpisaną dla konkretnego parametru inteligentnej klasy"
      ],
      "%{model} with id '%{id}' was not found": [
        "%{model} o id '%{id}' nie został znaleziony"
      ],
      "List all Puppet classes": [
        "Lista wszystkich klas Puppet"
      ],
      "List all Puppet classes for a host": [
        "Lista wszystkich klas Puppet dla hosta"
      ],
      "List all Puppet classes for a host group": [
        "Lista wszystkich klas Puppet dla grupy hostów"
      ],
      "List all Puppet classes for an environment": [
        "Lista wszystkich klas Puppet dla środowiska"
      ],
      "Show a Puppet class": [
        "Pokaż klasę Puppet"
      ],
      "Show a Puppet class for host": [
        "Pokaż klasę Puppet dla hosta"
      ],
      "Show a Puppet class for a host group": [
        "Pokaż klasę Puppet dla grupy hostów"
      ],
      "Show a Puppet class for an environment": [
        "Pokaż klasę Puppet dla środowiska"
      ],
      "Create a Puppet class": [
        "Utwórz klasę Puppet"
      ],
      "Update a Puppet class": [
        "Aktualizuj klasy Puppet"
      ],
      "Delete a Puppet class": [
        "Usuń klasę Puppet"
      ],
      "List all smart class parameters": [
        "Lista wszystkich parametrów klasy inteligentnych"
      ],
      "List of smart class parameters for a specific host": [
        "Lista parametrów inteligentnych klasy dla konkretnego hosta"
      ],
      "List of smart class parameters for a specific host group": [
        "Lista parametrów inteligentnej klasy dla określonej grupy hostów"
      ],
      "List of smart class parameters for a specific Puppet class": [
        "Lista parametrów inteligentnych klasy dla konkretnej klasy Puppet"
      ],
      "List of smart class parameters for a specific environment": [
        "Lista parametrów inteligentnych klasy dla konkretnego środowiska"
      ],
      "List of smart class parameters for a specific environment/Puppet class combination": [
        "Lista parametrów inteligentnych klasy dla określonego środowiska / Połączenie klasy Puppet"
      ],
      "Show a smart class parameter": [
        "Pokaż parametry inteligentnej klasy"
      ],
      "Update a smart class parameter": [
        "Aktualizacja parametru inteligentnej klasy"
      ],
      "Whether the smart class parameter value is managed by Foreman": [
        "Czy inteligentna wartość parametru klasy jest zarządzana przez Foreman"
      ],
      "Description of smart class": [
        "Opis inteligentnej klasy"
      ],
      "Value to use when there is no match": [
        "Warto używać, gdy nie ma dopasowania"
      ],
      "When enabled the parameter is hidden in the UI": [
        "Gdy upoważniony parametr jest ukryty e UI"
      ],
      "Foreman will not send this parameter in classification output.Puppet will use the value defined in the Puppet manifest for this parameter": [
        ""
      ],
      "The order in which values are resolved": [
        "Kolejność, w jakiej wartości są rozwiązane"
      ],
      "Types of validation values": [
        "Rodzaje walidacji wartości"
      ],
      "Used to enforce certain values for the parameter values": [
        "Służy do wymuszenia pewnych wartości dla wartości parametrów"
      ],
      "Types of variable values": [
        "Rodzaje wartości zmiennych"
      ],
      "If true, will raise an error if there is no default value and no matcher provide a value": [
        "Jeśli to prawda, zgłosi błąd, jeśli nie ma wartości domyślnej ani podanej dopasowanej wartości"
      ],
      "Merge all matching values (only array/hash type)": [
        "Scalanie wszystkie pasujących wartości (tylko tablica / typ hash)"
      ],
      "Include default value when merging all matching values": [
        "Dołącz wartość domyślną podczas łączenia wszystkich pasujących wartości"
      ],
      "Remove duplicate values (only array type)": [
        "Usuń zduplikowane wartości (tylko typ tablicowy)"
      ],
      "Successfully overridden all parameters of Puppet class %s": [
        "Pomyślnie nadpisano wszystkie parametry klasy Puppet %s"
      ],
      "Successfully reset all parameters of Puppet class %s to their default values": [
        "Pomyślnie zresetowano wszystkie parametry klasy Puppet %s do wartości domyślnych."
      ],
      "No parameters to override for Puppet class %s": [
        "Brak parametrów przesłaniających dla klasy Puppet %s"
      ],
      "Create Puppet Environment": [
        ""
      ],
      "Help": [
        "Pomoc"
      ],
      "Change Environment": [
        "Zmień środowisko"
      ],
      "Change Puppet Master": [
        "Zmień Puppet Master"
      ],
      "Puppet YAML": [
        ""
      ],
      "Puppet external nodes YAML dump": [
        "Węzły zewnętrzne Puppet przerzucone na YAML "
      ],
      "Puppet Environment": [
        "Środowisko Puppet"
      ],
      "Omit from classification output": [
        ""
      ],
      "Override this value": [
        "Nadpisz wartość"
      ],
      "Remove this override": [
        "Usuń nadpisaną wartość"
      ],
      "Default value": [
        "Domyślna wartość "
      ],
      "Original value info": [
        "Wartość oryginalnej informacji"
      ],
      "<b>Description:</b> %{desc}<br/>\\n        <b>Type:</b> %{type}<br/>\\n        <b>Matcher:</b> %{matcher}<br/>\\n        <b>Inherited value:</b> %{inherited_value}": [
        ""
      ],
      "Required parameter without value.<br/><b>Please override!</b><br/>": [
        "Wymagany parametr nie ma wartości.<br/><b>Proszę nadpisać!</b><br/>"
      ],
      "Optional parameter without value.<br/><i>Still managed by Foreman, the value will be empty.</i><br/>": [
        ""
      ],
      "Empty environment": [
        "puste środowisko"
      ],
      "Deleted environment": [
        "Usunięte środowiska"
      ],
      "Deleted environment %{env} and %{pcs}": [
        "Usunięte środowiska%{env} i %{pcs}"
      ],
      "Ignored environment": [
        ""
      ],
      "Import": [
        "Import"
      ],
      "Import environments from %s": [
        ""
      ],
      "Import classes from %s": [
        ""
      ],
      "%{name} has %{num_tag} class": [
        "",
        ""
      ],
      "Click to remove %s": [
        "Kliknij, aby usunąć %s"
      ],
      "Click to add %s": [
        "Kliknij, aby dodać %s"
      ],
      "None": [
        "Brak"
      ],
      "When editing a template, you must assign a list \\\\\\n  of operating systems which this template can be used with. Optionally, you can \\\\\\n  restrict a template to a list of host groups and/or environments.": [
        ""
      ],
      "When a Host requests a template (e.g. during provisioning), Foreman \\\\\\n  will select the best match from the available templates of that type, in the \\\\\\n  following order:": [
        ""
      ],
      "Host group and Environment": [
        "Lista hostów i środowisko"
      ],
      "Host group only": [
        "Tylko grupa hostów"
      ],
      "Environment only": [
        "Tylko środowisko"
      ],
      "Operating system default": [
        "Domyślny system operacyjny"
      ],
      "The final entry, Operating System default, can be set by editing the %s page.": [
        "Końcowa pozycja, domyślny system operacyjny, można ustawić poprzez edycję %s strony."
      ],
      "Operating System": [
        "System operacyjny"
      ],
      "Can't find a valid Foreman Proxy with a Puppet feature": [
        "nie można znaleźć poprawnego Foreman Proxy z wtyczką Puppet"
      ],
      "%{puppetclass} does not belong to the %{environment} environment": [
        ""
      ],
      "Failed to import %{klass} for %{name}: doesn't exists in our database - ignoring": [
        "Nie udało się zaimportować %{klass} dla %{name}: nie istnieje w naszej bazie danych - ignoruj"
      ],
      "with id %{object_id} doesn't exist or is not assigned to proper organization and/or location": [
        ""
      ],
      "must be true to edit the parameter": [
        ""
      ],
      "Puppet parameter": [
        ""
      ],
      "Can't find a valid Proxy with a Puppet feature": [
        ""
      ],
      "Changed environments": [
        "Zmieniono środowisko"
      ],
      "Select the changes you want to apply to Foreman": [
        ""
      ],
      "Toggle": [
        "Przełącznik"
      ],
      "New": [
        "Nowy"
      ],
      "Check/Uncheck new": [
        "Zaznacz / odznacz nową"
      ],
      "Updated": [
        "Zaktualizowano"
      ],
      "Check/Uncheck updated": [
        "Zaznacz/ Odznacz aktualizację "
      ],
      "Obsolete": [
        "Przestarzały"
      ],
      "Check/Uncheck obsolete": [
        "Zaznacz/ Odznacz nieaktualny "
      ],
      "Check/Uncheck all": [
        "Zaznacz/ Odznacz wszystko"
      ],
      "Environment": [
        "Środowisko"
      ],
      "Operation": [
        "Operacja"
      ],
      "Puppet Modules": [
        "Moduły Puppet"
      ],
      "Check/Uncheck all %s changes": [
        "Zaznacz/Odznacz wszystkie %s zmainy"
      ],
      "Add:": [
        "Dodaj:"
      ],
      "Remove:": [
        "Usuń:"
      ],
      "Update:": [
        "Aktualizacja:"
      ],
      "Ignored:": [
        ""
      ],
      "Cancel": [
        "Anuluj"
      ],
      "Update": [
        "Aktualizacja:"
      ],
      "included already from parent": [
        "zawarte już od rodzica"
      ],
      "Remove": [
        ""
      ],
      "Add": [
        ""
      ],
      "%s is not in environment": [
        "%s nie ma w środowisku"
      ],
      "Included Config Groups": [
        "Zawiera grupy konfiguracji"
      ],
      "Available Config Groups": [
        "Dostępne grupy konfiguracji"
      ],
      "Edit %s": [
        "Edytuj %s"
      ],
      "Config Groups": [
        ""
      ],
      "Create Config Group": [
        ""
      ],
      "Puppet Classes": [
        "Klasy Puppet"
      ],
      "Hosts": [
        "Hosty"
      ],
      "Host Groups": [
        "Grupy hostów"
      ],
      "Actions": [
        "Akcja"
      ],
      "Delete %s?": [
        "Usunąć %s?"
      ],
      "A config group provides a one-step method of associating many Puppet classes to either a host or host group. Typically this would be used to add a particular application profile or stack in one step.": [
        ""
      ],
      "Locations": [
        "Lokalizacje"
      ],
      "Organizations": [
        "Organizacje"
      ],
      "Puppet Environments": [
        "Środowiska Puppet"
      ],
      "Environment|Name": [
        "Środowisko|Nazwa"
      ],
      "Classes": [
        "Klasy"
      ],
      "Create Environment": [
        ""
      ],
      "Puppet environments": [
        "środowisko Puppet"
      ],
      "Number of classes": [
        "Liczba klas"
      ],
      "Total": [
        "W sumie"
      ],
      "No environments found": [
        "Nie znaleziono środowisk"
      ],
      "There are no puppet environments set up on this puppet master. Please check the puppet master configuration.": [
        "Nie ma konfiguracji środowisk Puppet w tym Puppet Master. Proszę sprawdzić konfigurację Puppet Mastera."
      ],
      "Smart Class Parameters": [
        ""
      ],
      "Parameter": [
        "Parametr"
      ],
      "Puppet Class": [
        "Klasa Puppet"
      ],
      "Number of Overrides": [
        ""
      ],
      "Parameterized class support permits detecting, importing, and supplying parameters directly to classes which support it, via the ENC and depending on a set of rules (Smart Matchers).": [
        ""
      ],
      "Included Classes": [
        "Dołączone klasy"
      ],
      "Not authorized to edit classes": [
        "Brak autoryzacji do edytowania klasy"
      ],
      "Inherited Classes from %s": [
        ""
      ],
      "Available Classes": [
        "Dostępne klasy"
      ],
      "Filter classes": [
        "Filtruj klasy"
      ],
      "belongs to config group": [
        "należy do grupy konfiguracji"
      ],
      "Name": [
        "Nazwa"
      ],
      "Value": [
        "Wartość"
      ],
      "Omit": [
        ""
      ],
      "The class could not be saved because of an error in one of the class parameters.": [
        ""
      ],
      "Smart Class Parameter": [
        "Parametr inteligentnej klasy"
      ],
      "Host groups": [
        "Grupa hostów"
      ],
      "This Puppet class has no parameters in its signature.": [
        "Ta klasa Puppet nie ma parametrów w jej podpisie."
      ],
      "To update the class signature, go to the Puppet Classes page and select \\\"Import\\\".": [
        "Aby zaktualizować sygnaturę klasy, przejdź do strony klas Puppet i wybierz \\\"Importuj\\\"."
      ],
      "Filter by name": [
        "Filtrowanie według nazwy"
      ],
      "All environments - (not filtered)": [
        "Wszystkie środowiska - (nie filtrowane)"
      ],
      "Overridden": [
        ""
      ],
      "Edit Puppet Class %s": [
        "Edytuj klasę Puppet %s"
      ],
      "Puppetclass|Name": [
        "KlasaPuppet|Nazwa"
      ],
      "Environments": [
        "Środowiska"
      ],
      "Parameters": [
        "Parametry"
      ],
      "Override all parameters": [
        "Zastąp wszystkie parametry"
      ],
      "This will set all parameters of the class %s as overridden. Continue?": [
        "Spowoduje to ustawienie wszystkich parametrów klasy %s jako nadpisane. Kontynuować?"
      ],
      "Set parameters to defaults": [
        "Ustaw domyślne wartości parametrów"
      ],
      "This will reset parameters of the class %s to their default values. Continue?": [
        "Spowoduje to przywrócenie parametrów klasy %s do wartości domyślnych. Kontynuować?"
      ],
      "Puppet Class Parameters": [
        ""
      ],
      "Notice": [
        "Uwaga"
      ],
      "Please select an environment first": [
        "Proszę najpierw utworzyć środowisko"
      ],
      "Select environment": [
        "Wybierz środowisko"
      ],
      "*Clear environment*": [
        "* Wyczyść środowisko *"
      ],
      "*Inherit from host group*": [
        "* Dziedziczenie z grupy hosta *"
      ],
      "Hostgroup": [
        "Grupa hostów "
      ],
      "Remove Combination": [
        ""
      ],
      "Valid Host Group and Environment Combinations": [
        ""
      ],
      "Add Combination": [
        ""
      ],
      "General": [
        "Generalnie"
      ],
      "Hosts managed:": [
        "Zarządzane hosty:"
      ],
      "Facts": [
        "Fakty"
      ],
      "Foreman will default to this puppet environment if it cannot auto detect one": [
        "Foreman będzie domyślny do tego środowiska puppet jeśli nie wykryje niczego innego"
      ],
      "Default Puppet environment": [
        "Domyślne środowisko Puppet"
      ],
      "Foreman will explicitly set the puppet environment in the ENC yaml output. This will avoid conflicts between the environment in puppet.conf and the environment set in Foreman": [
        "Foreman będzie jawnie ustawiać środowisko puppet na wyjściu END YAML. Pozwoli to uniknąć konfliktów między środowiskiem w puppet.conf i środowiskiem określonym w Foreman"
      ],
      "ENC environment": [
        "Środowisko ENC"
      ],
      "Foreman will update a host's environment from its facts": [
        "Foreman będzie aktualizować środowisko hosta od jej Informacji"
      ],
      "Update environment from facts": [
        "Aktualizuj środowisko na podstawie faktów"
      ],
      "Config Management": [
        ""
      ],
      "Duration in minutes after servers reporting via Puppet are classed as out of sync.": [
        ""
      ],
      "Puppet interval": [
        "interwał Puppet"
      ],
      "Disable host configuration status turning to out of sync for %s after report does not arrive within configured interval": [
        ""
      ],
      "%s out of sync disabled": [
        ""
      ],
      "Puppet ENC": [
        ""
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
        ""
      ],
      "This tab is still a work in progress": [
        ""
      ],
      "Smart class parameters": [
        "Parametry inteligentnych klas"
      ],
      "Successfully copied to clipboard!": [
        ""
      ],
      "Copy to clipboard": [
        ""
      ],
      "Couldn't find any ENC data for this host": [
        ""
      ],
      "Error!": [
        ""
      ],
      "Puppet details": [
        ""
      ],
      "Puppet environment": [
        ""
      ],
      "Puppet Smart Proxy": [
        ""
      ],
      "Puppet CA Smart Proxy": [
        ""
      ],
      "Reports": [
        "Raporty"
      ],
      "ENC Preview": [
        ""
      ],
      "Click to remove config group": [
        "Kliknij by usunąć grupę konfiguracji"
      ],
      " Remove": [
        "Usuń"
      ],
      "Loading parameters...": [
        "Ładowanie parametrów ..."
      ],
      "Some Puppet Classes are unavailable in the selected environment": [
        ""
      ],
      "Action with sub plans": [
        ""
      ],
      "Import facts": [
        ""
      ],
      "Import Puppet classes": [
        ""
      ],
      "Remote action:": [
        ""
      ],
      "Allow assigning Puppet environments and classes to the Foreman Hosts.": [
        ""
      ]
    }
  }
};