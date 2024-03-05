 locales['foreman_puppet'] = locales['foreman_puppet'] || {}; locales['foreman_puppet']['zh_CN'] = {
  "domain": "foreman_puppet",
  "locale_data": {
    "foreman_puppet": {
      "": {
        "Project-Id-Version": "foreman_puppet 5.0.0",
        "Report-Msgid-Bugs-To": "",
        "PO-Revision-Date": "2021-02-03 16:30+0000",
        "Last-Translator": "Amit Upadhye <aupadhye@redhat.com>, 2022",
        "Language-Team": "Chinese (China) (https://www.transifex.com/foreman/teams/114/zh_CN/)",
        "MIME-Version": "1.0",
        "Content-Type": "text/plain; charset=UTF-8",
        "Content-Transfer-Encoding": "8bit",
        "Language": "zh_CN",
        "Plural-Forms": "nplurals=1; plural=0;",
        "lang": "zh_CN",
        "domain": "foreman_puppet",
        "plural_forms": "nplurals=1; plural=0;"
      },
      "Ignored environment names resulting in booleans found. Please quote strings like true/false and yes/no in config/ignored_environments.yml": [
        "已找到被忽略的生成布尔值的环境名称。请用引号刮起 config/ignored_environments.yml 中的 true/false 以及 yes/no 之类的字符串"
      ],
      "No changes to your environments detected": [
        "未探测到您的环境有任何变化"
      ],
      "Successfully updated environments and Puppet classes from the on-disk Puppet installation": [
        "成功使用磁盘 Puppet 安装更新环境及 Puppet 类别"
      ],
      "Failed to update environments and Puppet classes from the on-disk Puppet installation: %s": [
        "无法使用磁盘 Puppet 安装更新环境及 Puppet 类别：%s"
      ],
      "No smart proxy was found to import environments from, ensure that at least one smart proxy is registered with the 'puppet' feature": [
        "没有找到可用来导入环境的智能代理服务器，请确保至少有一个智能代理服务器注册了 'puppet' 功能"
      ],
      "Ignored environments: %s": [
        "忽略的环境：%s"
      ],
      "Ignored classes in the environments: %s": [
        "环境中忽略的类别： %s"
      ],
      "List all host groups for a Puppet class": [
        "列出 Puppet 类别的所有主机组"
      ],
      "ID of Puppetclass": [
        "Puppetclass ID"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/environment_id": [
        "已过时，首选使用 hostgroup/puppet_attributes/environment_id"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/puppetclass_ids": [
        "已过时，首选使用 hostgroup/puppet_attributes/puppetclass_ids"
      ],
      "Deprecated in favor of hostgroup/puppet_attributes/config_group_ids": [
        "已过时，首先使用 hostgroup/puppet_attributes/config_group_ids"
      ],
      "ID of associated puppet Environment": [
        "与 puppet 环境关联的 ID"
      ],
      "IDs of associated Puppetclasses": [
        "与 Puppetclasses 关联的 ID"
      ],
      "IDs of associated ConfigGroups": [
        "与 ConfigGroups 关联的 ID"
      ],
      "Import puppet classes from puppet proxy": [
        "从 puppet 代理服务器导入 puppet 类"
      ],
      "Import puppet classes from puppet proxy for an environment": [
        "从 puppet 代理服务器为环境导入 puppet 类别"
      ],
      "Optional comma-delimited stringcontaining either 'new', 'updated', or 'obsolete'that is used to limit the imported Puppet classes": [
        "自选用逗号分开包含 'new'、'updated' 或 'obsolete' 的字符串，用来限制导入的 Puppet 类别"
      ],
      "Failed to update the environments and Puppet classes from the on-disk puppet installation: %s": [
        "使用磁盘 Puppet 安装更新环境及 Puppet 类别失败：%s"
      ],
      "The requested environment cannot be found.": [
        "无法找到请求的环境。"
      ],
      "No proxy found to import classes from, ensure that the smart proxy has the Puppet feature enabled.": [
        "没有找到可用来导入类别的代理服务器，请确定至少有一个启用 Puppet 的智能代理服务器。"
      ],
      "List template combination": [
        "列出模板组合"
      ],
      "Add a template combination": [
        "添加模板组合"
      ],
      "Show template combination": [
        "显示模板组合"
      ],
      "Update template combination": [
        "更新模板组合"
      ],
      "ID of Puppet environment": [
        "Puppet 环境的 ID"
      ],
      "environment id": [
        "环境 ID"
      ],
      "ID of environment": [
        "环境 ID"
      ],
      "List hosts per environment": [
        "列出各个环境的主机"
      ],
      "ID of puppet environment": [
        "puppet 环境的 ID"
      ],
      "Deprecated in favor of host/puppet_attributes/environment_id": [
        "已过时，首选使用 host/puppet_attributes/environment_id"
      ],
      "Deprecated in favor of host/puppet_attributes/puppetclass_ids": [
        "已过时，首选使用 host/puppet_attributes/puppetclass_ids"
      ],
      "Deprecated in favor of host/puppet_attributes/config_group_ids": [
        "已过时，首选使用 host/puppet_attributes/config_group_ids"
      ],
      "No environment selected!": [
        "没有选择环境！"
      ],
      "Updated hosts: changed environment": [
        "已更新主机：更改环境"
      ],
      "Unable to generate output, Check log files": [
        "无法生成输出结果，检查日志文件"
      ],
      "No proxy selected!": [
        "未选择代理服务器！"
      ],
      "Invalid proxy selected!": [
        "所选代理服务器无效！"
      ],
      "Failed to set %{proxy_type} proxy for %{host}.": [
        "无法为 %{host} 设置 {proxy_type} 代理服务器。"
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}": [
        "所选主机的 %{proxy_type} 代理服务器被设置为 %{proxy_name}"
      ],
      "The %{proxy_type} proxy of the selected hosts was cleared.": [
        "所选主机的 %{proxy_type} 代理服务器已被清除。"
      ],
      "The %{proxy_type} proxy could not be set for host: %{host_names}.": [
        "无法为主机 %{host_names} 设置 %{proxy_type} 代理服务器。"
      ],
      "The %{proxy_type} proxy of the selected hosts was set to %{proxy_name}.": [
        "所选主机的 %{proxy_type} 代理服务器被设置为 {proxy_name}。"
      ],
      "Puppet": [
        "Puppet"
      ],
      "Puppet CA": [
        "Puppet CA"
      ],
      "List of config groups": [
        "配置组列表"
      ],
      "Show a config group": [
        "显示配置组"
      ],
      "Create a config group": [
        "建立配置群組"
      ],
      "Update a config group": [
        "更新配置群組"
      ],
      "Delete a config group": [
        "删除配置组"
      ],
      "List all environments": [
        "列出所有环境"
      ],
      "List environments of Puppet class": [
        "列出 Puppet 类的环境"
      ],
      "List environments per location": [
        "列出各个位置的环境"
      ],
      "List environments per organization": [
        "列出各个机构的环境"
      ],
      "ID of Puppet class": [
        "Puppet 类别 ID"
      ],
      "Show an environment": [
        "显示环境"
      ],
      "Create an environment": [
        "创建环境"
      ],
      "Update an environment": [
        "更新环境"
      ],
      "Delete an environment": [
        "删除环境"
      ],
      "List all Puppet class IDs for host": [
        "列出主机的所有 Puppet 类 ID"
      ],
      "Add a Puppet class to host": [
        "新增 Puppet 類別至主機"
      ],
      "ID of host": [
        "主机 ID"
      ],
      "Remove a Puppet class from host": [
        "從主機移除一個 Puppet 類別"
      ],
      "List all Puppet class IDs for host group": [
        "列出主机组的所有 Puppet 类 ID"
      ],
      "Add a Puppet class to host group": [
        "为主机组添加一个 Puppet 类"
      ],
      "ID of host group": [
        "主机组 ID"
      ],
      "Remove a Puppet class from host group": [
        "从主机组中删除一个 Puppet 类"
      ],
      "List of override values for a specific smart class parameter": [
        "具体智能分类参数替代值列表"
      ],
      "Display hidden values": [
        "显示隐藏值"
      ],
      "Show an override value for a specific smart class parameter": [
        "显示具体智能类别参数的替代值"
      ],
      "Override match": [
        "替代匹配"
      ],
      "Override value, required if omit is false": [
        "覆盖值，omit 为 false 时必需"
      ],
      "Foreman will not send this parameter in classification output": [
        "Foreman 不会在分类输出中发送此参数"
      ],
      "Create an override value for a specific smart class parameter": [
        "为具体智能类别参数创建替代值"
      ],
      "Update an override value for a specific smart class parameter": [
        "更新具体智能类别参数的替代值"
      ],
      "Delete an override value for a specific smart class parameter": [
        "删除具体智能类别参数替代值"
      ],
      "%{model} with id '%{id}' was not found": [
        "找不到 ID 为 '%{id}' 的 %{model}"
      ],
      "List all Puppet classes": [
        "列出所有 Puppet 类别"
      ],
      "List all Puppet classes for a host": [
        "列出主机的所有 Puppet 类别"
      ],
      "List all Puppet classes for a host group": [
        "列出主机组的所有 Puppet 类别"
      ],
      "List all Puppet classes for an environment": [
        "列出环境的所有 Puppet 类别"
      ],
      "Show a Puppet class": [
        "显示 Puppet 类别"
      ],
      "Show a Puppet class for host": [
        "显示主机的 Puppet 类别"
      ],
      "Show a Puppet class for a host group": [
        "显示主机组的 Puppet 类别"
      ],
      "Show a Puppet class for an environment": [
        "显示环境的 Puppet 类别"
      ],
      "Create a Puppet class": [
        "创建 Puppet 类别"
      ],
      "Update a Puppet class": [
        "更新 Puppet 类别"
      ],
      "Delete a Puppet class": [
        "删除 Puppet 类别"
      ],
      "List all smart class parameters": [
        "列出所有智能类别参数"
      ],
      "List of smart class parameters for a specific host": [
        "具体主机的智能类别参数列表"
      ],
      "List of smart class parameters for a specific host group": [
        "具体主机组的智能类别参数列表"
      ],
      "List of smart class parameters for a specific Puppet class": [
        "具体 Puppet 类别的智能类别参数列表"
      ],
      "List of smart class parameters for a specific environment": [
        "具体环境的智能类别参数列表"
      ],
      "List of smart class parameters for a specific environment/Puppet class combination": [
        "具体环境/Puppet 类别组合的智能类别参数列表"
      ],
      "Show a smart class parameter": [
        "显示智能类别参数"
      ],
      "Update a smart class parameter": [
        "更新智能类别参数"
      ],
      "Whether the smart class parameter value is managed by Foreman": [
        "是否由 Foreman 管理智能类别参数值"
      ],
      "Description of smart class": [
        "智能类别描述"
      ],
      "Value to use when there is no match": [
        "未发现匹配时使用的值"
      ],
      "When enabled the parameter is hidden in the UI": [
        "何时将启用的参数隐藏到 UI 中"
      ],
      "Foreman will not send this parameter in classification output.Puppet will use the value defined in the Puppet manifest for this parameter": [
        "Foreman 不会在分类输出中发送此参数。Puppet 将使用 Puppet 清单中为此参数定义的值"
      ],
      "The order in which values are resolved": [
        "值解析的順序"
      ],
      "Types of validation values": [
        "验证值类型"
      ],
      "Used to enforce certain values for the parameter values": [
        "用来在参数中强制使用某些值"
      ],
      "Types of variable values": [
        "变量值类型"
      ],
      "If true, will raise an error if there is no default value and no matcher provide a value": [
        "如为 true，则会在没有默认值且没有匹配程序提供参数值时出错"
      ],
      "Merge all matching values (only array/hash type)": [
        "合并所有匹配的值（仅用于阵列/哈希类型）"
      ],
      "Include default value when merging all matching values": [
        "合并所有匹配值时包括默认值"
      ],
      "Remove duplicate values (only array type)": [
        "删除重复值（仅用于阵列类型）"
      ],
      "Successfully overridden all parameters of Puppet class %s": [
        "成功覆盖 Puppet 类 %s 的所有参数"
      ],
      "Successfully reset all parameters of Puppet class %s to their default values": [
        "成功将 Puppet 类 %s 的所有参数重置为默认值"
      ],
      "No parameters to override for Puppet class %s": [
        "没有用于 Puppet 类 %s 的覆盖参数"
      ],
      "Create Puppet Environment": [
        "创建 Puppet 环境"
      ],
      "Help": [
        "帮助"
      ],
      "Change Environment": [
        "改变环境"
      ],
      "Change Puppet Master": [
        "更改 Puppet 主服务器"
      ],
      "Puppet YAML": [
        "Puppet YAML"
      ],
      "Puppet external nodes YAML dump": [
        "Puppet 外部节点 YAML 转储"
      ],
      "Puppet Environment": [
        "Puppet 环境"
      ],
      "Omit from classification output": [
        "从分类输出中省略"
      ],
      "Override this value": [
        "重设此值"
      ],
      "Remove this override": [
        "删除此覆盖"
      ],
      "Default value": [
        "默认值"
      ],
      "Original value info": [
        "原始值信息"
      ],
      "<b>Description:</b> %{desc}<br/>\\n        <b>Type:</b> %{type}<br/>\\n        <b>Matcher:</b> %{matcher}<br/>\\n        <b>Inherited value:</b> %{inherited_value}": [
        "<b>描述：</b> %{desc}<br/> \\n <b>type:</b> %{type}<br/> \\n <b>Matcher:</b> %{matcher}<br/> \\n <b>inherited value:</b> %{inherited_value}"
      ],
      "Required parameter without value.<br/><b>Please override!</b><br/>": [
        "需要的参数没有值。<br/><b>请覆盖</b><br/>"
      ],
      "Optional parameter without value.<br/><i>Still managed by Foreman, the value will be empty.</i><br/>": [
        "可选的参数没有值。<br/><i>仍由 Foreman 管理，该值将为空。</i><br/>"
      ],
      "Empty environment": [
        "空环境"
      ],
      "Deleted environment": [
        "删除环境"
      ],
      "Deleted environment %{env} and %{pcs}": [
        "删除环境 %{env} 和 %{pcs}"
      ],
      "Ignored environment": [
        "忽略的环境"
      ],
      "Import": [
        "导入"
      ],
      "Import environments from %s": [
        "从 %s 导入环境"
      ],
      "Import classes from %s": [
        "从 %s 导入类"
      ],
      "%{name} has %{num_tag} class": [
        "%{name} 具有 ％{num_tag}类"
      ],
      "Click to remove %s": [
        "点删除 %s"
      ],
      "Click to add %s": [
        "点添加 %s"
      ],
      "None": [
        "没有"
      ],
      "When editing a template, you must assign a list \\\\\\n  of operating systems which this template can be used with. Optionally, you can \\\\\\n  restrict a template to a list of host groups and/or environments.": [
        "在编辑模板时，您必须分配可搭配\\\\\\n此模板使用的一系列操作系统。您也可\\\\\\n选择将模板限制到一系列主机组和/或环境。"
      ],
      "When a Host requests a template (e.g. during provisioning), Foreman \\\\\\n  will select the best match from the available templates of that type, in the \\\\\\n  following order:": [
        "当主机需要一个模板时（比如在置备过程中），Foreman \\\\\\n将从该类型的可用模板中选择最匹配的一个，选择\\\\\\n顺序如下："
      ],
      "Host group and Environment": [
        "主机组和环境"
      ],
      "Host group only": [
        "仅主机组"
      ],
      "Environment only": [
        "仅环境"
      ],
      "Operating system default": [
        "作業系統預設值"
      ],
      "The final entry, Operating System default, can be set by editing the %s page.": [
        "最终条目，操作系统默认值，可以通过编辑 %s 页设置。"
      ],
      "Operating System": [
        "操作系统"
      ],
      "Can't find a valid Foreman Proxy with a Puppet feature": [
        "无法找到带有 Puppet 功能的有效 Foreman 代理"
      ],
      "%{puppetclass} does not belong to the %{environment} environment": [
        "%{puppetclass} 不属于 %{environment} 环境"
      ],
      "Failed to import %{klass} for %{name}: doesn't exists in our database - ignoring": [
        "为 %{name} 导入 %{klass} 失败：不存在于我们的数据库中 -- 忽略"
      ],
      "with id %{object_id} doesn't exist or is not assigned to proper organization and/or location": [
        "id %{object_id} 不存在，或没有被分配到适当的机构/位置"
      ],
      "must be true to edit the parameter": [
        "必须为 true 以编辑参数"
      ],
      "Puppet parameter": [
        "Puppet 参数"
      ],
      "Can't find a valid Proxy with a Puppet feature": [
        "找不到具有 Puppet 功能的有效代理"
      ],
      "Changed environments": [
        "修改的环境"
      ],
      "Puppet Environments": [
        "Puppet 环境"
      ],
      "Select the changes you want to apply to Foreman": [
        "选择您要应用到 Foreman 的更改"
      ],
      "Toggle": [
        "切換"
      ],
      "New": [
        "新"
      ],
      "Check/Uncheck new": [
        "選取/反選新項目"
      ],
      "Updated": [
        "已更新"
      ],
      "Check/Uncheck updated": [
        "选择/取消 更新"
      ],
      "Obsolete": [
        "废弃的"
      ],
      "Check/Uncheck obsolete": [
        "選取/反選已淘汰項目"
      ],
      "Check/Uncheck all": [
        "選取/反選全部"
      ],
      "Environment": [
        "环境"
      ],
      "Operation": [
        "操作"
      ],
      "Puppet Modules": [
        "Puppet 模組"
      ],
      "Check/Uncheck all %s changes": [
        "选中/取消选中全部%s变化"
      ],
      "Add:": [
        "添加："
      ],
      "Remove:": [
        "删除："
      ],
      "Update:": [
        "更新："
      ],
      "Ignored:": [
        "已忽略："
      ],
      "Cancel": [
        "取消"
      ],
      "Update": [
        "更新"
      ],
      "included already from parent": [
        "已在上级包含"
      ],
      "Remove": [
        "移除"
      ],
      "Add": [
        "添加"
      ],
      "%s is not in environment": [
        "%s 未在环境中"
      ],
      "Included Config Groups": [
        "包含的配置组"
      ],
      "Available Config Groups": [
        "可用配置组"
      ],
      "Edit %s": [
        "编辑 %s"
      ],
      "Config Groups": [
        "配置组"
      ],
      "Create Config Group": [
        "创建配置组"
      ],
      "Puppet Classes": [
        "Puppet 类"
      ],
      "Hosts": [
        "主机"
      ],
      "Host Groups": [
        "主机组"
      ],
      "Actions": [
        "操作"
      ],
      "Delete %s?": [
        "刪除 %s?"
      ],
      "A config group provides a one-step method of associating many Puppet classes to either a host or host group. Typically this would be used to add a particular application profile or stack in one step.": [
        "配置组提供了将多个 Puppet 类关联到一个主机或主机组的一步方法。此方法一般用于通过一个步骤添加特定的应用配置文件或堆栈。"
      ],
      "Locations": [
        "位置"
      ],
      "Organizations": [
        "机构"
      ],
      "Environment|Name": [
        "名称"
      ],
      "Classes": [
        "类"
      ],
      "Create Environment": [
        "创建环境"
      ],
      "Puppet environments": [
        "Puppet 环境"
      ],
      "Number of classes": [
        "类数"
      ],
      "Total": [
        "总计"
      ],
      "No environments found": [
        "未找到任何环境"
      ],
      "There are no puppet environments set up on this puppet master. Please check the puppet master configuration.": [
        "这台 puppet 主服务器中未设置任何 puppet 环境。请检查 puppet 主服务器配置。"
      ],
      "Smart Class Parameters": [
        "智能类参数"
      ],
      "Parameter": [
        "参数"
      ],
      "Puppet Class": [
        "Puppet 类"
      ],
      "Number of Overrides": [
        "覆盖数"
      ],
      "Parameterized class support permits detecting, importing, and supplying parameters directly to classes which support it, via the ENC and depending on a set of rules (Smart Matchers).": [
        "参数化类支持允许根据一组规则（智能匹配器），通过 ENC 对支持它的类直接实施检测、导入和提供参数。"
      ],
      "Included Classes": [
        "包含的类"
      ],
      "Not authorized to edit classes": [
        "没有授权编辑类"
      ],
      "Inherited Classes from %s": [
        "从 %s 继承的类"
      ],
      "Available Classes": [
        "可用类"
      ],
      "Filter classes": [
        "筛选类"
      ],
      "belongs to config group": [
        "属于配置组"
      ],
      "Name": [
        "名称"
      ],
      "Value": [
        "值"
      ],
      "Omit": [
        "省略"
      ],
      "The class could not be saved because of an error in one of the class parameters.": [
        "此类无法保存，因为其中一个类参数含有错误。"
      ],
      "Smart Class Parameter": [
        "智能代理参数"
      ],
      "Host groups": [
        "主机组"
      ],
      "This Puppet class has no parameters in its signature.": [
        "这个 Puppet 类别在其签名中没有参数。"
      ],
      "To update the class signature, go to the Puppet Classes page and select \\\"Import\\\".": [
        "请进入 Puppet 类别页面，选择“导入”就可以更新该类别签名。"
      ],
      "Filter by name": [
        "按名称筛选"
      ],
      "All environments - (not filtered)": [
        "所有环境 - （未过滤）"
      ],
      "Overridden": [
        "覆盖"
      ],
      "Edit Puppet Class %s": [
        "编辑 Puppet 类 %s"
      ],
      "Puppetclass|Name": [
        "Puppetclass|名称"
      ],
      "Environments": [
        "环境"
      ],
      "Parameters": [
        "参数"
      ],
      "Override all parameters": [
        "覆盖所有参数"
      ],
      "This will set all parameters of the class %s as overridden. Continue?": [
        "这会将类 %s 的所有参数设定为覆盖值。继续吗？"
      ],
      "Set parameters to defaults": [
        "将参数设定为默认"
      ],
      "This will reset parameters of the class %s to their default values. Continue?": [
        "这会将类 %s 的参数重置为其默认值。继续吗？"
      ],
      "Puppet Class Parameters": [
        "Puppet 类参数"
      ],
      "Notice": [
        "注意事項"
      ],
      "Please select an environment first": [
        "请先选择环境"
      ],
      "Select environment": [
        "选择环境"
      ],
      "*Clear environment*": [
        "*环境清除*"
      ],
      "*Inherit from host group*": [
        "*从主机组继承*"
      ],
      "Hostgroup": [
        "主机组"
      ],
      "Remove Combination": [
        "删除组合"
      ],
      "Valid Host Group and Environment Combinations": [
        "有效的主机组和环境组合"
      ],
      "Add Combination": [
        "添加组合"
      ],
      "General": [
        "常规"
      ],
      "Hosts managed:": [
        "管理的主机："
      ],
      "Facts": [
        "Facts"
      ],
      "Foreman will default to this puppet environment if it cannot auto detect one": [
        "如果无法自动探测到环境，Foreman 将默认使用这个 puppet 环境"
      ],
      "Default Puppet environment": [
        "默认 Puppet 环境"
      ],
      "Foreman will explicitly set the puppet environment in the ENC yaml output. This will avoid conflicts between the environment in puppet.conf and the environment set in Foreman": [
        "Foreman 将在 ENC yaml 输出中明确设置这个 puppet 环境。这样可以避免 puppet.conf 以及 Foreman 中设置的环境冲突"
      ],
      "ENC environment": [
        "ENC 环境"
      ],
      "Foreman will update a host's environment from its facts": [
        "Foreman 将根据其详情更新主机环境"
      ],
      "Update environment from facts": [
        "根据系统信息更新环境"
      ],
      "Config Management": [
        "配置管理"
      ],
      "Duration in minutes after servers reporting via Puppet are classed as out of sync.": [
        "在其时间后（以分钟为单位）经过 Puppet 的服务器报告被认为已不同步。"
      ],
      "Puppet interval": [
        "Puppet 间隔"
      ],
      "Disable host configuration status turning to out of sync for %s after report does not arrive within configured interval": [
        "禁用在配置的间隔时间后没有获得报告时把主机（%s）配置状态变为不同步"
      ],
      "%s out of sync disabled": [
        "%s 不同步被禁用"
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
        "分配的类"
      ],
      "This tab is still a work in progress": [
        "这个标签页仍在进行中"
      ],
      "Smart class parameters": [
        "智能类参数"
      ],
      "Successfully copied to clipboard!": [
        ""
      ],
      "Copy to clipboard": [
        ""
      ],
      "Couldn't find any ENC data for this host": [
        "无法找到此主机的任何 ENC 数据"
      ],
      "Error!": [
        "错误！"
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
        "Puppet 详情"
      ],
      "Puppet environment": [
        "Puppet 环境"
      ],
      "Puppet Smart Proxy": [
        "Puppet 智能代理"
      ],
      "Puppet CA Smart Proxy": [
        "Puppet CA 智能代理"
      ],
      "Reports": [
        "报表"
      ],
      "ENC Preview": [
        "ENC 预览"
      ],
      "Click to remove config group": [
        "点删除配置组"
      ],
      " Remove": [
        " 移除"
      ],
      "Loading parameters...": [
        "正在载入参数..."
      ],
      "Some Puppet Classes are unavailable in the selected environment": [
        "某些 Puppet 类在所选的环境中不可用"
      ],
      "Action with sub plans": [
        "有子计划的操作"
      ],
      "Import facts": [
        "导入事实"
      ],
      "Import Puppet classes": [
        "导入 Puppet 类"
      ],
      "Remote action:": [
        "远程操作："
      ],
      "Allow assigning Puppet environments and classes to the Foreman Hosts.": [
        "允许将 Puppet 环境和类分配给 Foreman 主机。"
      ]
    }
  }
};