 locales['foreman_puppet'] = locales['foreman_puppet'] || {}; locales['foreman_puppet']['ja'] = {
  "domain": "foreman_puppet",
  "locale_data": {
    "foreman_puppet": {
      "": {
        "Project-Id-Version": "foreman_puppet 5.0.0",
        "Report-Msgid-Bugs-To": "",
        "PO-Revision-Date": "2021-02-03 16:30+0000",
        "Last-Translator": "Amit Upadhye <aupadhye@redhat.com>, 2022",
        "Language-Team": "Japanese (https://www.transifex.com/foreman/teams/114/ja/)",
        "MIME-Version": "1.0",
        "Content-Type": "text/plain; charset=UTF-8",
        "Content-Transfer-Encoding": "8bit",
        "Language": "ja",
        "Plural-Forms": "nplurals=1; plural=0;",
        "lang": "ja",
        "domain": "foreman_puppet",
        "plural_forms": "nplurals=1; plural=0;"
      },
      "Ignored environment names resulting in booleans found. Please quote strings like true/false and yes/no in config/ignored_environments.yml": [
        "環境名を無視したブール値が見つかりました。config/ignored_environments.yml の true/false および yes/no などの文字列を引用符で囲んでください"
      ],
      "No changes to your environments detected": [
        "環境への変更が検出されませんでした"
      ],
      "Successfully updated environments and Puppet classes from the on-disk Puppet installation": [
        "オンディスクの Puppet インストールから環境および Puppet クラスを正常に更新しました"
      ],
      "Failed to update environments and Puppet classes from the on-disk Puppet installation: %s": [
        "オンディスクの Puppet インストールからの環境と Puppet クラスの更新に失敗しました: %s"
      ],
      "No smart proxy was found to import environments from, ensure that at least one smart proxy is registered with the 'puppet' feature": [
        "環境のインポート元となる Smart Proxy が見つかりませんでした。1 つ以上の Smart Proxy が「Puppet」機能で登録されていることを確認してください"
      ],
      "Ignored environments: %s": [
        "無視された環境: %s"
      ],
      "Ignored classes in the environments: %s": [
        "環境内で無視されたクラス: %s"
      ],
      "List all host groups for a Puppet class": [
        "Puppet クラスのすべてのホストグループを一覧表示"
      ],
      "ID of Puppetclass": [
        "Puppet クラスの ID"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/environment_id": [
        "hostgroup/puppet_attributes/environment_id を優先して非推奨となりました"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/puppetclass_ids": [
        "hostgroup/puppet_attributes/puppetclass_ids を優先して非推奨となりました"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/config_group_ids": [
        "hostgroup/puppet_attributes/config_group_ids を優先して非推奨となりました"
      ],
      "ID of associated puppet Environment": [
        "関連する Puppet 環境の ID"
      ],
      "IDs of associated Puppetclasses": [
        "関連する Puppet クラスの ID"
      ],
      "IDs of associated ConfigGroups": [
        "関連付けられた設定グループの ID"
      ],
      "Import puppet classes from puppet proxy": [
        "Puppet プロキシーから Puppet クラスをインポート"
      ],
      "Import puppet classes from puppet proxy for an environment": [
        "環境の Puppet プロキシーから Puppet クラスをインポート"
      ],
      "Optional comma-delimited stringcontaining either 'new', 'updated', or 'obsolete'that is used to limit the imported Puppet classes": [
        "インポートされた Puppet クラスを制限するために使用される '新規'、'更新済み'、または '旧版' のいずれかが含まれる、オプションのコンマ区切りの文字列"
      ],
      "Failed to update the environments and Puppet classes from the on-disk puppet installation: %s": [
        "オンディスクの Puppet インストールから環境および Puppet クラスを更新できませんでした: %s"
      ],
      "The requested environment cannot be found.": [
        "要求された環境は見つかりません。"
      ],
      "No proxy found to import classes from, ensure that the smart proxy has the Puppet feature enabled.": [
        "クラスのインポート元となるプロキシーが見つかりません。Smart Proxy で Puppet 機能が有効であることを確認してください。"
      ],
      "List template combination": [
        "テンプレートの組み合わせの一覧表示"
      ],
      "Add a template combination": [
        "テンプレートの組み合わせの追加"
      ],
      "Show template combination": [
        "テンプレートの組み合わせの表示"
      ],
      "Update template combination": [
        "テンプレートの組み合わせの更新"
      ],
      "ID of Puppet environment": [
        "Puppet 環境の ID"
      ],
      "environment id": [
        "環境 ID"
      ],
      "ID of environment": [
        "環境の ID"
      ],
      "List hosts per environment": [
        "環境ごとにホストを一覧表示"
      ],
      "ID of puppet environment": [
        "Puppet 環境の ID"
      ],
      "Deprecated in favor of host/puppet_attributes/environment_id": [
        "host/puppet_attributes/environment_id を優先して非推奨となりました"
      ],
      "Deprecated in favor of host/puppet_attributes/puppetclass_ids": [
        "host/puppet_attributes/puppetclass_ids を優先して非推奨となりました"
      ],
      "Deprecated in favor of host/puppet_attributes/config_group_ids": [
        "host/puppet_attributes/config_group_ids を優先して非推奨となりました"
      ],
      "No environment selected!": [
        "環境が選択されていません!"
      ],
      "Updated hosts: changed environment": [
        "更新済みホスト: 変更済み環境"
      ],
      "Unable to generate output, Check log files": [
        "出力を生成できません。ログファイルを確認してください"
      ],
      "No proxy selected!": [
        "プロキシーが選択されていません!"
      ],
      "Invalid proxy selected!": [
        "無効なプロキシーが選択されました!"
      ],
      "Failed to set %{proxy_type} proxy for %{host}.": [
        "%{host} に %{proxy_type} プロキシーを設定できませんでした。"
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}": [
        "選択したホストの %{proxy_type} プロキシーが %{proxy_name} に設定されました"
      ],
      "The %{proxy_type} proxy of the selected hosts was cleared.": [
        "選択したホストの %{proxy_type} プロキシーが消去されました。"
      ],
      "The %{proxy_type} proxy could not be set for host: %{host_names}.": [
        "ホスト: %{host_names} に %{proxy_type} プロキシーを設定できませんでした。"
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}.": [
        "選択したホストの %{proxy_type} プロキシーが %{proxy_name} に設定されました。"
      ],
      "Puppet": [
        "Puppet"
      ],
      "Puppet CA": [
        "Puppet CA"
      ],
      "List of config groups": [
        "設定グループの一覧"
      ],
      "Show a config group": [
        "設定グループの表示"
      ],
      "Create a config group": [
        "設定グループの作成"
      ],
      "Update a config group": [
        "設定グループの更新"
      ],
      "Delete a config group": [
        "設定グループの削除"
      ],
      "List all environments": [
        "すべての環境を一覧表示"
      ],
      "List environments of Puppet class": [
        "Puppet クラスの環境を一覧表示"
      ],
      "List environments per location": [
        "ロケーションごとに環境を一覧表示"
      ],
      "List environments per organization": [
        "組織ごとに環境を一覧表示"
      ],
      "ID of Puppet class": [
        "Puppet クラスの ID"
      ],
      "Show an environment": [
        "環境の表示"
      ],
      "Create an environment": [
        "環境の作成"
      ],
      "Update an environment": [
        "環境の更新"
      ],
      "Delete an environment": [
        "環境の削除"
      ],
      "List all Puppet class IDs for host": [
        "ホストのすべての Puppet クラス ID を一覧表示"
      ],
      "Add a Puppet class to host": [
        "Puppet クラスをホストに追加"
      ],
      "ID of host": [
        "ホストの ID"
      ],
      "Remove a Puppet class from host": [
        "ホストから Puppet クラスを削除"
      ],
      "List all Puppet class IDs for host group": [
        "ホストグループのすべての Puppet クラス ID を一覧表示"
      ],
      "Add a Puppet class to host group": [
        "Puppet クラスをホストグループに追加"
      ],
      "ID of host group": [
        "ホストグループの ID"
      ],
      "Remove a Puppet class from host group": [
        "ホストグループから Puppet クラスを削除"
      ],
      "List of override values for a specific smart class parameter": [
        "特定スマートクラスパラメーターの上書き値の一覧"
      ],
      "Display hidden values": [
        "非表示の値の表示"
      ],
      "Show an override value for a specific smart class parameter": [
        "特定スマートクラスパラメーターの上書き値を表示"
      ],
      "Override match": [
        "一致候補の上書き"
      ],
      "Override value, required if omit is false": [
        "上書き値 (omit が false の場合に必要)"
      ],
      "Foreman will not send this parameter in classification output": [
        "Foreman では、このパラメーターは分類出力で送信されません。"
      ],
      "Create an override value for a specific smart class parameter": [
        "特定スマートクラスパラメーターの上書き値を作成"
      ],
      "Update an override value for a specific smart class parameter": [
        "特定スマートクラスパラメーターの上書き値を更新"
      ],
      "Delete an override value for a specific smart class parameter": [
        "特定スマートクラスパラメーターの上書き値を削除"
      ],
      "%{model} with id '%{id}' was not found": [
        "id '%{id}' の %{model} が見つかりませんでした"
      ],
      "List all Puppet classes": [
        "すべての Puppet クラスを一覧表示する"
      ],
      "List all Puppet classes for a host": [
        "ホストのすべての Puppet クラスを一覧表示"
      ],
      "List all Puppet classes for a host group": [
        "ホストグループのすべての Puppet クラスを一覧表示"
      ],
      "List all Puppet classes for an environment": [
        "環境のすべての Puppet クラスを一覧表示"
      ],
      "Show a Puppet class": [
        "Puppet クラスの表示"
      ],
      "Show a Puppet class for host": [
        "ホストの Puppet クラスの表示"
      ],
      "Show a Puppet class for a host group": [
        "ホストグループの Puppet クラスの表示"
      ],
      "Show a Puppet class for an environment": [
        "環境の Puppet クラスの表示"
      ],
      "Create a Puppet class": [
        "Puppet クラスの作成"
      ],
      "Update a Puppet class": [
        "Puppet クラスの更新"
      ],
      "Delete a Puppet class": [
        "Puppet クラスの削除"
      ],
      "List all smart class parameters": [
        "すべてのスマートクラスパラメーターを一覧表示"
      ],
      "List of smart class parameters for a specific host": [
        "特定ホストのスマートクラスパラメーターの一覧"
      ],
      "List of smart class parameters for a specific host group": [
        "特定ホストグループのスマートクラスパラメーターの一覧"
      ],
      "List of smart class parameters for a specific Puppet class": [
        "特定 Puppet クラスのスマートクラスパラメーターの一覧"
      ],
      "List of smart class parameters for a specific environment": [
        "特定の環境のスマートクラスパラメーターの一覧"
      ],
      "List of smart class parameters for a specific environment/Puppet class combination": [
        "特定の環境/Puppet クラスの組み合わせ用のスマートクラスパラメーターの一覧"
      ],
      "Show a smart class parameter": [
        "スマートクラスパラメーターの表示"
      ],
      "Update a smart class parameter": [
        "スマートクラスパラメーターの更新"
      ],
      "Whether the smart class parameter value is managed by Foreman": [
        "スマートクラスパラメーター値が Foreman によって管理されているかどうか"
      ],
      "Description of smart class": [
        "スマートクラスの説明"
      ],
      "Value to use when there is no match": [
        "一致がない場合に使用する値"
      ],
      "When enabled the parameter is hidden in the UI": [
        "有効な場合はパラメーターは UI で非表示になります"
      ],
      "Foreman will not send this parameter in classification output.Puppet will use the value defined in the Puppet manifest for this parameter": [
        "Foreman はこのパラメーターを分類出力で送信しません。Puppet はこのパラメーターについて Puppet マニフェストで定義された値を使用します"
      ],
      "The order in which values are resolved": [
        "値が解決される順序"
      ],
      "Types of validation values": [
        "検証値のタイプ"
      ],
      "Used to enforce certain values for the parameter values": [
        "パラメーター値の特定の値を適用するために使用されます"
      ],
      "Types of variable values": [
        "変数値のタイプ"
      ],
      "If true, will raise an error if there is no default value and no matcher provide a value": [
        "true の場合は、デフォルト値がなく、Matcher が値を提供しないときにエラーが発生します"
      ],
      "Merge all matching values (only array/hash type)": [
        "一致するすべての値のマージ (配列/ハッシュタイプのみ)"
      ],
      "Include default value when merging all matching values": [
        "一致するすべての値をマージするときにデフォルト値を含めます"
      ],
      "Remove duplicate values (only array type)": [
        "重複する値の削除 (配列タイプのみ)"
      ],
      "Successfully overridden all parameters of Puppet class %s": [
        "Puppet クラス %s のすべてのパラメーターが正常に上書きされました"
      ],
      "Successfully reset all parameters of Puppet class %s to their default values": [
        "Puppet クラス %s の全パラメーターをデフォルト値に正常にリセットしました"
      ],
      "No parameters to override for Puppet class %s": [
        "Puppet クラス %s で上書きするパラメーターはありません"
      ],
      "Create Puppet Environment": [
        "Puppet 環境の作成"
      ],
      "Help": [
        "ヘルプ"
      ],
      "Change Environment": [
        "環境の変更"
      ],
      "Change Puppet Master": [
        "Puppet マスターの変更"
      ],
      "Puppet YAML": [
        "Puppet YAML"
      ],
      "Puppet external nodes YAML dump": [
        "Puppet 外部ノード YAML ダンプ"
      ],
      "Puppet Environment": [
        "Puppet 環境"
      ],
      "Omit from classification output": [
        "分類出力からの省略"
      ],
      "Override this value": [
        "この値の上書き"
      ],
      "Remove this override": [
        "この上書きの削除"
      ],
      "Default value": [
        "デフォルト値"
      ],
      "Original value info": [
        "元の値の情報"
      ],
      "<b>Description:</b> %{desc}<br/>\\n        <b>Type:</b> %{type}<br/>\\n        <b>Matcher:</b> %{matcher}<br/>\\n        <b>Inherited value:</b> %{inherited_value}": [
        "<b>説明:</b> %%{desc}<br/>\\n     <b>タイプ:</b> %%{type}<br/>\\n     <b>Matcher:</b> %%{matcher}<br/>\\n     <b>継承値:</b> %{inherited_value}"
      ],
      "Required parameter without value.<br/><b>Please override!</b><br/>": [
        "値なしの必須パラメーターです。<br/><b>上書きしてください!</b><br/>"
      ],
      "Optional parameter without value.<br/><i>Still managed by Foreman, the value will be empty.</i><br/>": [
        "値なしの任意パラメーターです。<br/><i>引き続き Foreman により管理されます。値は空白になります。</i><br/>"
      ],
      "Empty environment": [
        "空の環境"
      ],
      "Deleted environment": [
        "削除済みの環境"
      ],
      "Deleted environment %{env} and %{pcs}": [
        "削除済みの環境 %{env} および %{pcs}"
      ],
      "Ignored environment": [
        "無視された環境"
      ],
      "Import": [
        "インポート"
      ],
      "Import environments from %s": [
        "%s からの環境のインポート"
      ],
      "Import classes from %s": [
        "%s からのクラスのインポート"
      ],
      "%{name} has %{num_tag} class": [
        "%{name} には ％{num_tag}クラスが含まれます"
      ],
      "Click to remove %s": [
        "クリックして %s を削除"
      ],
      "Click to add %s": [
        "クリックして %s を追加"
      ],
      "None": [
        "なし"
      ],
      "When editing a template, you must assign a list \\\\\\n  of operating systems which this template can be used with. Optionally, you can \\\\\\n  restrict a template to a list of host groups and/or environments.": [
        "テンプレートの編集時に、このテンプレートを使用できる \\\\\\n  オペレーティングシステムの一覧を割り当てる必要があります。オプションで、テンプレート \\\\\\n  をホストグループや環境の一覧に制限することができます。"
      ],
      "When a Host requests a template (e.g. during provisioning), Foreman \\\\\\n  will select the best match from the available templates of that type, in the \\\\\\n  following order:": [
        "ホストがテンプレートを要求する際 (例: プロビジョニング時) に、Foreman \\\\\\n  は以下の順序で、該当タイプの利用可能なテンプレートからベストマッチ \\\\\\n  を選択します:"
      ],
      "Host group and Environment": [
        "ホストグループと環境"
      ],
      "Host group only": [
        "ホストグループのみ"
      ],
      "Environment only": [
        "環境のみ"
      ],
      "Operating system default": [
        "オペレーティングシステムのデフォルト"
      ],
      "The final entry, Operating System default, can be set by editing the %s page.": [
        "最終エントリーのオペレーティングシステムのデフォルトは、%s ページを編集して設定できます。"
      ],
      "Operating System": [
        "オペレーティングシステム"
      ],
      "Can't find a valid Foreman Proxy with a Puppet feature": [
        "Puppet 機能を持つ有効な Foreman プロキシーが見つかりません"
      ],
      "%{puppetclass} does not belong to the %{environment} environment": [
        "%{puppetclass} は %{environment} 環境に所属していません"
      ],
      "Failed to import %{klass} for %{name}: doesn't exists in our database - ignoring": [
        "%{name} の %{klass} のインポートに失敗しました: データベースに存在しません - 無視します"
      ],
      "with id %{object_id} doesn't exist or is not assigned to proper organization and/or location": [
        "id {object_id} が存在しないか、適切な組織またはロケーションに割り当てられていません"
      ],
      "must be true to edit the parameter": [
        "パラメーターを編集するには true に設定する必要があります"
      ],
      "Puppet parameter": [
        "Puppet パラメーター"
      ],
      "Can't find a valid Proxy with a Puppet feature": [
        "Puppet 機能を持つ有効なプロキシーが見つかりません"
      ],
      "Changed environments": [
        "変更済みの環境"
      ],
      "Puppet Environments": [
        "Puppet 環境"
      ],
      "Select the changes you want to apply to Foreman": [
        "Foreman に適用する変更を選択してください"
      ],
      "Toggle": [
        "切り替え"
      ],
      "New": [
        "新規"
      ],
      "Check/Uncheck new": [
        "新規の選択/選択解除"
      ],
      "Updated": [
        "更新済み"
      ],
      "Check/Uncheck updated": [
        "更新版の選択/選択解除"
      ],
      "Obsolete": [
        "旧版"
      ],
      "Check/Uncheck obsolete": [
        "旧版の選択/選択解除"
      ],
      "Check/Uncheck all": [
        "すべて選択/選択解除"
      ],
      "Environment": [
        "環境"
      ],
      "Operation": [
        "操作"
      ],
      "Puppet Modules": [
        "Puppet モジュール"
      ],
      "Check/Uncheck all %s changes": [
        "%s のすべての変更を選択/選択解除"
      ],
      "Add:": [
        "追加:"
      ],
      "Remove:": [
        "削除:"
      ],
      "Update:": [
        "更新:"
      ],
      "Ignored:": [
        "無視:"
      ],
      "Cancel": [
        "取り消し"
      ],
      "Update": [
        "更新"
      ],
      "included already from parent": [
        "すでに親から組み込まれています"
      ],
      "Remove": [
        "削除"
      ],
      "Add": [
        "追加"
      ],
      "%s is not in environment": [
        "%s は環境内にありません"
      ],
      "Included Config Groups": [
        "組み込まれた設定グループ"
      ],
      "Available Config Groups": [
        "選択可能な設定グループ"
      ],
      "Edit %s": [
        "%s の編集"
      ],
      "Config Groups": [
        "設定グループ"
      ],
      "Create Config Group": [
        "設定グループの作成"
      ],
      "Puppet Classes": [
        "Puppet クラス"
      ],
      "Hosts": [
        "ホスト"
      ],
      "Host Groups": [
        "ホストグループ"
      ],
      "Actions": [
        "アクション"
      ],
      "Delete %s?": [
        "%s を削除しますか?"
      ],
      "A config group provides a one-step method of associating many Puppet classes to either a host or host group. Typically this would be used to add a particular application profile or stack in one step.": [
        "設定グループは、多くの Puppet クラスをホストまたはホストグループのいずれかに関連付けるワンステップの方法を提供します。通常、これは特定のアプリケーションプロファイルまたはスタックを 1 つのステップで追加するために使用されます。"
      ],
      "Locations": [
        "ロケーション"
      ],
      "Organizations": [
        "組織"
      ],
      "Environment|Name": [
        "名前"
      ],
      "Classes": [
        "クラス"
      ],
      "Create Environment": [
        "環境の作成"
      ],
      "Puppet environments": [
        "Puppet 環境"
      ],
      "Number of classes": [
        "クラスの数"
      ],
      "Total": [
        "合計"
      ],
      "No environments found": [
        "環境が見つかりません"
      ],
      "There are no puppet environments set up on this puppet master. Please check the puppet master configuration.": [
        "この puppet マスターには puppet 環境がセットアップされていません。puppet マスター設定を確認してください。"
      ],
      "Smart Class Parameters": [
        "スマートクラスパラメーター"
      ],
      "Parameter": [
        "パラメーター"
      ],
      "Puppet Class": [
        "Puppet クラス"
      ],
      "Number of Overrides": [
        "上書き数"
      ],
      "Parameterized class support permits detecting, importing, and supplying parameters directly to classes which support it, via the ENC and depending on a set of rules (Smart Matchers).": [
        "パラメーター化クラスのサポートでは、ENC を介して一連のルール (Smart Matcher) に従い、パラメーターを検出してインポートし、そのパラメーターをサポートするクラスに直接渡すことができます。"
      ],
      "Included Classes": [
        "組み込み済みのクラス"
      ],
      "Not authorized to edit classes": [
        "クラスを編集する権限がありません"
      ],
      "Inherited Classes from %s": [
        "%s から継承されたクラス"
      ],
      "Available Classes": [
        "利用可能なクラス"
      ],
      "Filter classes": [
        "クラスのフィルター"
      ],
      "belongs to config group": [
        "設定グループに属します"
      ],
      "Name": [
        "名前"
      ],
      "Value": [
        "値"
      ],
      "Omit": [
        "省略"
      ],
      "The class could not be saved because of an error in one of the class parameters.": [
        "クラスパラメーターのいずれかにエラーがあるため、このクラスは保存できませんでした。"
      ],
      "Smart Class Parameter": [
        "スマートクラスパラメーター"
      ],
      "Host groups": [
        "ホストグループ"
      ],
      "This Puppet class has no parameters in its signature.": [
        "この Puppet クラスの署名にはパラメーターがありません。"
      ],
      "To update the class signature, go to the Puppet Classes page and select \\\"Import\\\".": [
        "クラス署名を更新するには「Puppet クラス」ページに移動して「インポート」を選択します。"
      ],
      "Filter by name": [
        "名前でフィルター"
      ],
      "All environments - (not filtered)": [
        "すべての環境 - (フィルターなし)"
      ],
      "Overridden": [
        "上書き済み"
      ],
      "Edit Puppet Class %s": [
        "Puppet クラス %s の編集"
      ],
      "Puppetclass|Name": [
        "名前"
      ],
      "Environments": [
        "環境"
      ],
      "Parameters": [
        "パラメーター"
      ],
      "Override all parameters": [
        "すべてのパラメーターの上書き"
      ],
      "This will set all parameters of the class %s as overridden. Continue?": [
        "これは、クラス %s のすべてのパラメーターを上書き済みとして設定します。続行しますか?"
      ],
      "Set parameters to defaults": [
        "パラメーターをデフォルトに設定"
      ],
      "This will reset parameters of the class %s to their default values. Continue?": [
        "この操作ではクラス %s のパラメーターをデフォルト値にリセットします。続行しますか?"
      ],
      "Puppet Class Parameters": [
        "Puppet クラスパラメーター"
      ],
      "Notice": [
        "注意"
      ],
      "Please select an environment first": [
        "まず環境を選択してください"
      ],
      "Select environment": [
        "環境の選択"
      ],
      "*Clear environment*": [
        "*環境をクリア*"
      ],
      "*Inherit from host group*": [
        "*ホストグループから継承*"
      ],
      "Hostgroup": [
        "ホストグループ"
      ],
      "Remove Combination": [
        "組み合わせの削除"
      ],
      "Valid Host Group and Environment Combinations": [
        "有効なホストグループと環境の組み合わせ"
      ],
      "Add Combination": [
        "組み合わせの追加"
      ],
      "General": [
        "全般"
      ],
      "Hosts managed:": [
        "管理されるホスト:"
      ],
      "Facts": [
        "ファクト"
      ],
      "Foreman will default to this puppet environment if it cannot auto detect one": [
        "Foreman は、自動検出できない場合にこの puppet 環境にデフォルト設定されます"
      ],
      "Default Puppet environment": [
        "デフォルトの Puppet 環境"
      ],
      "Foreman will explicitly set the puppet environment in the ENC yaml output. This will avoid conflicts between the environment in puppet.conf and the environment set in Foreman": [
        "Foreman は ENC YAML 出力で puppet 環境を明示的に設定します。これにより、puppet.conf の環境と Foreman で設定される環境間の競合を避けられます"
      ],
      "ENC environment": [
        "ENC 環境"
      ],
      "Foreman will update a host's environment from its facts": [
        "Foreman はホスト環境をそのファクトで更新します"
      ],
      "Update environment from facts": [
        "ファクトから環境を更新"
      ],
      "Config Management": [
        "設定管理"
      ],
      "Duration in minutes after servers reporting via Puppet are classed as out of sync.": [
        "Puppet 経由で報告するサーバーが非同期として分類されるまでの期間 (分単位)。"
      ],
      "Puppet interval": [
        "Puppet の間隔"
      ],
      "Disable host configuration status turning to out of sync for %s after report does not arrive within configured interval": [
        "設定した間隔でレポートが到達しない場合に、%s のホスト設定ステータスが非同期に切り替わらないように無効にします"
      ],
      "%s out of sync disabled": [
        "%s の非同期切り替えを無効にしました"
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
        "割り当てられたクラス"
      ],
      "This tab is still a work in progress": [
        "このタブはまだ進行中です"
      ],
      "Smart class parameters": [
        "スマートクラスパラメーター"
      ],
      "Successfully copied to clipboard!": [
        ""
      ],
      "Copy to clipboard": [
        ""
      ],
      "Couldn't find any ENC data for this host": [
        "このホストの ENC データを見つけられませんでした"
      ],
      "Error!": [
        "エラー!"
      ],
      "Last configuration status": [
        ""
      ],
      "Never": [
        ""
      ],
      "No configuration status available": [
        ""
      ],
      "Failed": [
        ""
      ],
      "Changed": [
        ""
      ],
      "Scheduled": [
        ""
      ],
      "Failed to start": [
        ""
      ],
      "Restarted": [
        ""
      ],
      "Corrective Change": [
        ""
      ],
      "Skipped": [
        ""
      ],
      "Out of sync": [
        ""
      ],
      "Puppet metrics": [
        ""
      ],
      "Puppet details": [
        "Puppet の詳細"
      ],
      "Puppet environment": [
        "Puppet 環境"
      ],
      "Puppet Smart Proxy": [
        "Puppet Smart Proxy"
      ],
      "Puppet CA Smart Proxy": [
        "Puppet CA Smart Proxy"
      ],
      "Reports": [
        "レポート"
      ],
      "ENC Preview": [
        "ENC プレビュー"
      ],
      "Click to remove config group": [
        "クリックして設定グループを削除"
      ],
      " Remove": [
        " 削除"
      ],
      "Loading parameters...": [
        "パラメーターのロード中..."
      ],
      "Some Puppet Classes are unavailable in the selected environment": [
        "選択した環境では、一部の Puppet クラスは利用できません"
      ],
      "Action with sub plans": [
        "サブプランによるアクション"
      ],
      "Import facts": [
        "ファクトのインポート"
      ],
      "Import Puppet classes": [
        "Puppet クラスのインポート"
      ],
      "Remote action:": [
        "リモートアクション:"
      ],
      "Allow assigning Puppet environments and classes to the Foreman Hosts.": [
        "Puppet 環境とクラスを Foreman ホストに割り当てることを許可します。"
      ]
    }
  }
};